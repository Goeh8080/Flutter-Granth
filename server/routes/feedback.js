const express = require('express');
const db = require('../db');
const { requireAuth } = require('../auth');
const upload = require('../upload');
const { rebuildPack } = require('../packBuilder');

const router = express.Router();

function baseUrl(req) {
  return `${req.protocol}://${req.get('host')}`;
}

// Public: anyone using the Viewer app can submit feedback, no login needed.
router.post('/', upload.single('image'), async (req, res) => {
  const { description, topic_id, granth_id, praman_id } = req.body;
  if (!description) return res.status(400).json({ error: 'Description is required' });

  const feedback = {
    id: 'feedback-' + Date.now(),
    description,
    topic_id: topic_id || null,
    granth_id: granth_id || null,
    praman_id: praman_id || null,
    image: req.file ? `images/${req.file.filename}` : null,
    createdAt: new Date().toISOString(),
  };
  db.get('feedbacks').push(feedback).write();
  await rebuildPack(baseUrl(req));
  res.status(201).json(feedback);
});

// Admin-only: view and moderate.
router.get('/', requireAuth, (req, res) => {
  res.json(db.get('feedbacks').value());
});

router.delete('/:id', requireAuth, async (req, res) => {
  db.get('feedbacks').remove({ id: req.params.id }).write();
  await rebuildPack(baseUrl(req));
  res.json({ success: true });
});

module.exports = router;
