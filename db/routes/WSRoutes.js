const express = require('express');
const router = express.Router();
const WS = require('../models/WS');
router.get('/getByPage', async (req, res) => {
    const { page = 1, limit = 10 } = req.query;
    
    const wss = await WS.find()
      .sort({ thoi_gian: -1 }) 
      .limit(limit * 1)
      .skip((page - 1) * limit)
      .exec();
  
    const count = await WS.countDocuments();
    res.json({
      wss,
      totalPages: Math.ceil(count / limit),
      currentPage: page
    });
  });
  module.exports = router;