const express = require('express');
const bcrypt = require('bcryptjs');
const db = require('../db');
const { signToken, requireAuth } = require('../auth');

const router = express.Router();

router.post('/login', (req, res) => {
  const { username, password } = req.body;
  if (!username || !password) return res.status(400).json({ error: 'Username and password required' });

  const admin = db.get('admins').find({ username }).value();
  if (!admin || !bcrypt.compareSync(password, admin.passwordHash)) {
    return res.status(401).json({ error: 'Incorrect username or password' });
  }

  res.json({ token: signToken(admin), username: admin.username });
});

// List admins (requires being logged in already)
router.get('/admins', requireAuth, (req, res) => {
  const admins = db.get('admins').value().map((a) => ({ id: a.id, username: a.username, createdAt: a.createdAt }));
  res.json(admins);
});

// Create a new admin — any logged-in admin can create another one,
// per your requirement that admins can add more admins.
router.post('/admins', requireAuth, (req, res) => {
  const { username, password } = req.body;
  if (!username || !password || password.length < 6) {
    return res.status(400).json({ error: 'Username and a password of at least 6 characters are required' });
  }
  const exists = db.get('admins').find({ username }).value();
  if (exists) return res.status(409).json({ error: 'That username is already taken' });

  const newAdmin = {
    id: 'admin-' + Date.now(),
    username,
    passwordHash: bcrypt.hashSync(password, 10),
    createdAt: new Date().toISOString(),
  };
  db.get('admins').push(newAdmin).write();
  res.status(201).json({ id: newAdmin.id, username: newAdmin.username });
});

// Remove an admin (can't remove yourself, and can't remove the last admin)
router.delete('/admins/:id', requireAuth, (req, res) => {
  const all = db.get('admins').value();
  if (all.length <= 1) return res.status(400).json({ error: 'Cannot remove the only remaining admin' });
  if (req.admin.id === req.params.id) return res.status(400).json({ error: 'Cannot remove your own account while logged in' });

  db.get('admins').remove({ id: req.params.id }).write();
  res.json({ success: true });
});

module.exports = router;
