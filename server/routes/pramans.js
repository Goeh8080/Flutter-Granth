const express = require('express');
const db = require('../db');
const { requireAuth } = require('../auth');
const upload = require('../upload');
const { rebuildPack } = require('../packBuilder');

const router = express.Router();

function baseUrl(req) {
  return `${req.protocol}://${req.get('host')}`;
}

router.get('/', requireAuth, (req, res) => {
  res.json(db.get('pramans').value());
});

router.post('/', requireAuth, upload.single('image'), async (req, res) => {
  const { title, description, topic_id, granth_id, youtube_url, youtube_desc, youtube_start } = req.body;
  if (!title) return res.status(400).json({ error: 'Title is required' });

  const praman = {
    id: 'praman-' + Date.now(),
    title,
    description: description || '',
    topic_id: topic_id || null,
    granth_id: granth_id || null,
    youtube_url: youtube_url || null,
    youtube_desc: youtube_desc || null,
    youtube_start: youtube_start ? parseInt(youtube_start, 10) : null,
    image: req.file ? `images/${req.file.filename}` : null,
  };
  db.get('pramans').push(praman).write();
  await rebuildPack(baseUrl(req));
  res.status(201).json(praman);
});

router.put('/:id', requireAuth, upload.single('image'), async (req, res) => {
  const existing = db.get('pramans').find({ id: req.params.id }).value();
  if (!existing) return res.status(404).json({ error: 'Praman not found' });

  const b = req.body;
  const updates = {
    title: b.title ?? existing.title,
    description: b.description ?? existing.description,
    topic_id: b.topic_id ?? existing.topic_id,
    granth_id: b.granth_id ?? existing.granth_id,
    youtube_url: b.youtube_url ?? existing.youtube_url,
    youtube_desc: b.youtube_desc ?? existing.youtube_desc,
    youtube_start: b.youtube_start ? parseInt(b.youtube_start, 10) : existing.youtube_start,
    image: req.file ? `images/${req.file.filename}` : existing.image,
  };
  db.get('pramans').find({ id: req.params.id }).assign(updates).write();
  await rebuildPack(baseUrl(req));
  res.json(db.get('pramans').find({ id: req.params.id }).value());
});

router.delete('/:id', requireAuth, async (req, res) => {
  db.get('pramans').remove({ id: req.params.id }).write();
  await rebuildPack(baseUrl(req));
  res.json({ success: true });
});

module.exports = router;
