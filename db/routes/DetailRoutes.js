const express = require('express');
const router = express.Router();
const Detail = require('../models/Detail');

// Lưu một chi tiết mới (Detail)
// router.post('/', async (req, res) => {
//   const { id,nhiet_do, do_am, anh_sang} = req.body;
//   const thoi_gian = format(new Date(), 'yyyy-MM-dd HH:mm:ss');
//   try{
//     // Kiểm tra xem id đã tồn tại chưa
//     const detailExist = await Detail.findOne({ id });
//     if (detailExist) {return res.status(400).send('Detail with this id already exists');}
//     else{
//       const newDetail = new Detail({
//         id,
//         nhiet_do,
//         do_am,
//         anh_sang,
//         thoi_gian
//       });
//       await newDetail.save();
//       res.status(201).send(newDetail);
//     }
//   }
//   catch(err){
//     res.status(400).send(err);
//   }
// });
// Lấy danh sách chi tiết (Detail) với phân trang
// router.get('/', async (req, res) => {
//   try {
//     const details = await Detail.find()
//       .sort({ thoi_gian: -1 }) // Sắp xếp theo thời gian từ mới đến cũ
//       .exec();

//     res.json({
//       details
//     });
//   } catch (error) {
//     console.error(error);
//     res.status(500).json({ message: 'Server error' });
//   }
// });

router.get('/getByPage', async (req, res) => {
  const { page = 1, limit = 10 } = req.query;
  
  const details = await Detail.find()
    .sort({ thoi_gian: -1 }) 
    .limit(limit * 1)
    .skip((page - 1) * limit)
    .exec();

  const count = await Detail.countDocuments();
  res.json({
    details,
    totalPages: Math.ceil(count / limit),
    currentPage: page
  });
});
//Tìm kiếm sensor 
router.get('/search', async (req, res) => {
  const { query } = req.query;
  try {
    if (!query) {
      return res.status(400).json({ message: 'Missing query parameter' });
    }

    let details;

    if (isNaN(query)) {
      details = await Detail.find({
        thoi_gian: { $regex: query, $options: 'i' }
      });
    } else {
      const numericValue = parseInt(query, 10);
      details = await Detail.find({
        $or: [
          { nhiet_do: numericValue },
          { do_am: numericValue },
          { anh_sang: numericValue }
        ]
      });
    }

    res.json(details);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});


router.get('/today', async (req, res) => {
  try {
    const now = new Date();

    // Chuyển đổi thời gian 
    const startOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 0, 0, 0);
    const endOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 23, 59, 59, 999);

    const details = await Detail.find({
      thoi_gian: {
        $gte: startOfDay.toISOString(),
        $lt: endOfDay.toISOString(),
      },
    });
    res.json({ details });
  } catch (error) {
    console.error('Error fetching details:', error);
    res.status(500).json({ message: 'Error fetching details', error });
  }
});

module.exports = router;
