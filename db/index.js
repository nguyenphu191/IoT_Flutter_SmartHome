const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const cors = require('cors');
const Detail = require('./models/Detail');
const WS = require('./models/WS');
const DetailRoutes = require('./routes/DetailRoutes');
const DeviceRoutes = require('./routes/DeviceRoutes');
const Counter = require('./models/Counter');
const mqtt = require('mqtt');
const { format } = require('date-fns');
const DeviceHis = require('./models/DeviceHis');
const WSRoutes = require('./routes/WSRoutes');

mongoose.connect('mongodb://localhost:27017/smart_home');

const app = express();
app.use(cors());
app.use(bodyParser.json());

let deviceCounters = {
  device1: { on: 0, off: 0 },
  device2: { on: 0, off: 0 },
  device3: { on: 0, off: 0 },
  device4: { on: 0, off: 0 },
};
// Kết nối tới Mosquitto Broker cục bộ với username và password
const mqttOptions = {
  host: '172.20.10.2',  // Địa chỉ IP của máy chạy Mosquitto broker
  port: 1889,  
  username: 'Phu',
  password: 'B21DCCN592',
  protocol: 'mqtt'
};
const client = mqtt.connect(mqttOptions);
client.on('connect', () => {
  console.log('MQTT connected');
  
  client.subscribe('esp8266/dht11', (err) => {
    if (!err) {
      console.log('Subscribed to topic esp8266/dht11');
    } else {
      console.error('Failed to subscribe:', err);
    }
  });
  client.subscribe('esp8266/response', (err) => {
    if (!err) {
      console.log('Subscribed to topic esp8266/response');
    } else {
      console.error('Failed to subscribe to response topic:', err);
    }
  });
});
async function getNextSequence(name) {
  const counter = await Counter.findOneAndUpdate(
    { name },
    { $inc: { seq: 1 } },
    { new: true, upsert: true }  
  );
  return counter.seq;
}

client.on('message', async (topic, message) => {
  try {
    if (topic === 'esp8266/dht11') {
      const data = JSON.parse(message.toString());  // Chuyển đổi dữ liệu từ JSON
      const { nhiet_do, do_am, anh_sang, ws } = data; // Định nghĩa tất cả các trường trong một lần

      // Lưu thông tin Detail vào MongoDB
      const nextId = await getNextSequence('Detail');
      const newDetail = new Detail({
        id: `t${nextId}`, 
        nhiet_do,
        do_am,
        anh_sang,
        thoi_gian: format(new Date().toISOString(), 'yyyy-MM-dd HH:mm:ss'),
      });

      newDetail.save()
        .then(() => {
          console.log('Data saved:', newDetail);
        })
        .catch((err) => {
          console.error('Error saving data:', err);
        });

      // Kiểm tra giá trị WS và điều khiển thiết bị
      if (ws > 60) {
        client.publish('esp8266/blink', 'ON', (error) => {
          if (error) {
            console.error('Error :', error);
          }
        });
      }else{
        client.publish('esp8266/blink', 'OFF', (error) => {
          if (error) {
            console.error('Error :', error);
          }
        });
      }

      // Lưu thông tin WS vào MongoDB
      const nextId1 = await getNextSequence('WS');
      const newWS = new WS({
        id: `ws${nextId1}`,
        ws,
        thoi_gian: format(new Date().toISOString(), 'yyyy-MM-dd HH:mm:ss'),
      });

      newWS.save()
        .then(() => {
          console.log('Data saved:', newWS);
        })
        .catch((err) => {
          console.error('Error saving data:', err);
        });
    }
  } catch (err) {
    console.error('Error processing message:', err);
  }
});

app.post('/api/controlled_device', async (req, res) => {
  try {
    const { device, action } = req.body;
    const topic = `esp8266/${device}`;
    let name = "";

    if (device === "device1") {
      name = "Quạt";
    } else if (device === "device2") {
      name = "Đèn";
    } else if (device === "device3") {
      name = "Điều hòa";
    } else if (device === "device4") {
      name = "WS";
    }

    if (action === "ON" || action === "OFF") {
      let responseReceived = false;  // Cờ để kiểm tra phản hồi đã được gửi hay chưa

      client.publish(topic, action, async (error) => {
        if (error) {
          return res.status(500).json({ message: 'Error controlling' });
        }

        // Lắng nghe phản hồi MQTT
        const onMessage = async (responseTopic, message) => {
          if (responseTopic === 'esp8266/response' && !responseReceived) {  
            responseReceived = true; // Đánh dấu đã nhận phản hồi
            const response = message.toString();
            console.log('Response:', response);

            if (response === 'SUCCESS') {
              const nextId = await getNextSequence('DeviceHis');
              const newDevicehis = new DeviceHis({
                id: `dv_${nextId.toString().padStart(3, '0')}`,
                ten: name,
                tinh_trang: action,
                thoi_gian: format(new Date(), 'yyyy-MM-dd HH:mm:ss'),
                onCount: action === 'ON' ? deviceCounters[device].on + 1 : deviceCounters[device].on,
              });

              await newDevicehis.save();
              console.log('Device history saved:', newDevicehis);
              if (action === "ON") deviceCounters[device].on += 1;
              else if (action === "OFF") deviceCounters[device].off += 1;
              // Hủy lắng nghe sự kiện sau khi đã xử lý xong
              client.removeListener('message', onMessage);

              // Gửi phản hồi về cho Flutter
              return res.status(200).json({ message: `${device} turned ${action}` });
            } else {
              console.error('Unexpected response:', response);
              return res.status(500).json({ message: 'Failed to control device' });
            }
          }
        };

        // Đặt thời gian chờ 5 giây nếu không nhận được phản hồi
        const timeout = setTimeout(() => {
          if (!responseReceived) {
            client.removeListener('message', onMessage);  // Hủy lắng nghe nếu không có phản hồi
            return res.status(408).json({ message: 'Request Timeout: No response from device' });
          }
        }, 5000);  // 5 giây chờ phản hồi

        // Kích hoạt lắng nghe MQTT
        client.on('message', onMessage);
      });
    } else {
      res.status(400).json({ message: 'Invalid action' });
    }
  } catch (err) {
    console.error('Error processing request:', err);
    res.status(500).json({ message: 'Error processing request' });
  }
});



client.on('error', (err) => {
  console.error('MQTT error:', err);
});


// Sử dụng routes
app.use('/api/details', DetailRoutes);
app.use('/api/devicehis', DeviceRoutes);
app.use('/api/ws', WSRoutes);
app.get('/api/device_counts', (req, res) => {
  res.json(deviceCounters);
});
// Khởi động server
const PORT = 8000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});