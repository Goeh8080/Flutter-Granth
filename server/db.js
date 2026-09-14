const low = require('lowdb');
const FileSync = require('lowdb/adapters/FileSync');
const bcrypt = require('bcryptjs');
const path = require('path');
const fs = require('fs');

const dataDir = path.join(__dirname, '..', 'data');
if (!fs.existsSync(dataDir)) fs.mkdirSync(dataDir, { recursive: true });

const adapter = new FileSync(path.join(dataDir, 'db.json'));
const db = low(adapter);

db.defaults({
  admins: [],
  topics: [],
  granths: [],
  pramans: [],
  feedbacks: [],
  packVersion: 0,
  packUrl: null,
}).write();

// Seed the default admin account exactly once, as requested:
// username = amit8080, password = amit8080
if (db.get('admins').size().value() === 0) {
  db.get('admins')
    .push({
      id: 'admin-' + Date.now(),
      username: 'amit8080',
      passwordHash: bcrypt.hashSync('amit8080', 10),
      createdAt: new Date().toISOString(),
    })
    .write();
  console.log('Seeded default admin: amit8080 / amit8080 — please change this after first login.');
}

module.exports = db;
