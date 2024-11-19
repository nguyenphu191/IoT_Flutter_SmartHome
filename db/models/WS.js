const mongoose = require('mongoose');

const WSSchema = new mongoose.Schema({
  id: { type: String, required: true },
  ws: { type: Number, required: true },
  thoi_gian: { type: String, required: true }
});

module.exports = mongoose.model('WS', WSSchema);