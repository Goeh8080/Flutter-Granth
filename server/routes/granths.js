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
  res.json(db.get('granths').value());
});

router.post('/', requireAuth, upload.single('image'), async (req, res) => {
  const { title, description, topic_id } = req.body;
  if (!title) return res.status(400).json({ error: 'Title is required' });

  const granth = {
    id: 'granth-' + Date.now(),
    title,
    description: description || '',
    topic_id: topic_id || null,
    image: req.file ? `images/${req.file.filename}` : null,
  };
  db.get('granths').push(granth).write();
  await rebuildPack(baseUrl(req));
  res.status(201).json(granth);
});

router.put('/:id', requireAuth, upload.single('image'), async (req, res) => {
  const existing = db.get('granths').find({ id: req.params.id }).value();
  if (!existing) return res.status(404).json({ error: 'Granth not found' });

  const updates = {
    title: req.body.title ?? existing.title,
    description: req.body.description ?? existing.description,
    topic_id: req.body.topic_id ?? existing.topic_id,
    image: req.file ? `images/${req.file.filename}` : existing.image,
  };
  db.get('granths').find({ id: req.params.id }).assign(updates).write();
  await rebuildPack(baseUrl(req));
  res.json(db.get('granths').find({ id: req.params.id }).value());
});

router.delete('/:id', requireAuth, async (req, res) => {
  db.get('granths').remove({ id: req.params.id }).write();
  await rebuildPack(baseUrl(req));
  res.json({ success: true });
});

module.exports = router;
