const express = require('express');
const db = require('../db');

const router = express.Router();

// Public: the Viewer app polls this to know whether a newer pack exists.
router.get('/version', (req, res) => {
  res.json({
    version: db.get('packVersion').value() || 0,
    url: db.get('packUrl').value() || null,
  });
});

module.exports = router;
