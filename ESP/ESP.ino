#include <ESP8266WiFi.h>
#include "DHTesp.h"
#include <ArduinoJson.h>
#include <PubSubClient.h>

#define DHTpin 2
DHTesp dht;

// Định nghĩa các chân GPIO cho LED
#define LED1 5  // GPIO 5 (D1)
#define LED2 4  // GPIO 4 (D2)
#define LED3 0  // GPIO 0 (D3)
#define LED_BLINK 12 
const char* ssid = "iPhone of Fu";
const char* password = "123666888";

// Địa chỉ IP của Mosquitto broker
const char* mqtt_server = "172.20.10.2";
const int mqtt_port = 1889;  

// Thông tin đăng nhập Mosquitto
const char* mqtt_username = "Phu";
const char* mqtt_password = "B21DCCN592";

WiFiClient espClient;
PubSubClient client(espClient);

// Kết nối WiFi
void setup_wifi() {
  delay(10);
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}
// Biến để kiểm tra trạng thái nháy LED
// bool blinkState = false;
// Kết nối lại MQTT nếu mất kết nối
void reconnect() {
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    String clientID = "ESPClient-";
    clientID += String(random(0xffff), HEX);
    if (client.connect(clientID.c_str(), mqtt_username, mqtt_password)) {
      Serial.println("connected");
      client.subscribe("esp8266/client");
      // Subscribe vào các topic điều khiển thiết bị
      client.subscribe("esp8266/device");
      client.subscribe("esp8266/device1");
      client.subscribe("esp8266/device2");
      client.subscribe("esp8266/device3");
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      delay(5000);
    }
  }
}

// Hàm điều khiển bật/tắt LED
void controlled(int ledPin, String message) {
  if (message == "ON") {
    digitalWrite(ledPin, HIGH);
    Serial.print("LED ");
    Serial.print(ledPin);
    Serial.println(" ON");
    publishMessage("esp8266/response", "SUCCESS",true);
  } else if (message == "OFF") {
    digitalWrite(ledPin, LOW); 
    Serial.print("LED ");
    Serial.print(ledPin);
    Serial.println(" OFF");
    publishMessage("esp8266/response", "SUCCESS",true);
  }
}


// Hàm xử lý khi nhận được tin nhắn từ MQTT
void callback(char* topic, byte* payload, unsigned int length) {
  String message;
  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("]: ");
  Serial.println(message);

  // Kiểm tra topic và điều khiển LED tương ứng
  if (String(topic) == "esp8266/device1") {
    controlled(LED1, message);
  } else if (String(topic) == "esp8266/device2") {
    controlled(LED2, message);
  } else if (String(topic) == "esp8266/device3") {
    controlled(LED3, message);
  }else if(String(topic) == "esp8266/device"){
    controlled(LED1, message);
    controlled(LED2, message);
    controlled(LED3, message);
  }
}

// Gửi tin nhắn qua MQTT
void publishMessage(const char* topic, String payload, boolean retained) {
  if (client.publish(topic, payload.c_str(), retained))
    Serial.println("Message published [" + String(topic) + "]: " + payload);
}

void setup() {
  Serial.begin(9600);  // Bắt đầu kết nối Serial
  dht.setup(DHTpin, DHTesp::DHT11);  
  setup_wifi(); 
  client.setServer(mqtt_server, mqtt_port);  // Thiết lập MQTT server
  client.setCallback(callback);  // Đặt hàm callback để nhận tin nhắn

  // Cấu hình các chân LED làm đầu ra
  pinMode(LED1, OUTPUT);
  pinMode(LED2, OUTPUT);
  pinMode(LED3, OUTPUT);
  pinMode(LED_BLINK, OUTPUT);
  // Tắt tất cả các đèn LED ban đầu
  digitalWrite(LED1, LOW);
  digitalWrite(LED2, LOW);
  digitalWrite(LED3, LOW);
  // digitalWrite(LED_BLINK, LOW);
}

unsigned long lastTime = 0;
unsigned long timerDelay = 5000;  // Đặt thời gian chờ 10 giây

// unsigned long blinkInterval = 500;  // Khoảng thời gian nháy LED (0.5 giây)
// unsigned long lastBlinkTime = 0;  // Lưu thời gian của lần nháy cuối cùng
void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  if (millis() - lastTime > timerDelay) {
    lastTime = millis();

    // Đọc dữ liệu từ DHT11
    double nhiet_do = dht.getTemperature();
    double do_am = dht.getHumidity();
    
    // Đọc giá trị từ quang trở (LDR) kết nối với chân A0
    int ldrValue = analogRead(A0);
    
    // Chuyển đổi giá trị LDR thành đơn vị Lux
    double anh_sang = map(ldrValue, 0, 1023, 0, 1000);  // Điều chỉnh phạm vi Lux nếu cần


    // Tạo JSON để gửi dữ liệu qua MQTT
    DynamicJsonDocument doc(1024);
    doc["nhiet_do"] = String(nhiet_do,1);
    doc["do_am"] = String(do_am,1);
    doc["anh_sang"] = String(anh_sang,1);

    // Chuyển đổi JSON thành chuỗi
    String mqtt_message;
    serializeJson(doc, mqtt_message);

    // Gửi dữ liệu qua MQTT
    publishMessage("esp8266/dht11", mqtt_message, true);
    // if (anh_sang > 500) {
    //   if (millis() - lastBlinkTime > blinkInterval) {
    //     blinkState = !blinkState;  // Đảo trạng thái LED
    //     digitalWrite(LED_BLINK, blinkState ? HIGH : LOW);
    //     lastBlinkTime = millis();
    //   }
    // } else {
    //   digitalWrite(LED_BLINK, LOW);  // Tắt LED nếu ánh sáng >= 100
    // }
  }
}
