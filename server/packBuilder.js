const fs = require('fs');
const path = require('path');
const archiver = require('archiver');
const db = require('./db');

const UPLOADS_DIR = path.join(__dirname, 'uploads');
const PACKS_DIR = path.join(__dirname, 'public', 'packs');
if (!fs.existsSync(PACKS_DIR)) fs.mkdirSync(PACKS_DIR, { recursive: true });

/**
 * Rebuilds granth_pack_vN.zip from scratch out of whatever is currently
 * in the database, bumps the version number, and records the new
 * version + public URL so the Viewer app's version-check endpoint can
 * see it immediately. Called automatically after every create/update/
 * delete on topics/granths/pramans/feedback — the admin never has to
 * manually "publish".
 */
function rebuildPack(baseUrl) {
  const version = (db.get('packVersion').value() || 0) + 1;

  const manifest = {
    version,
    generated_at: new Date().toISOString(),
    topics: db.get('topics').value(),
    granths: db.get('granths').value(),
    pramans: db.get('pramans').value(),
    feedbacks: db.get('feedbacks').value(),
  };

  const zipPath = path.join(PACKS_DIR, `granth_pack_v${version}.zip`);
  const output = fs.createWriteStream(zipPath);
  const archive = archiver('zip', { zlib: { level: 9 } });

  return new Promise((resolve, reject) => {
    output.on('close', () => {
      db.set('packVersion', version).write();
      db.set('packUrl', `${baseUrl}/packs/granth_pack_v${version}.zip`).write();

      // Clean up older pack files so disk usage doesn't grow forever.
      fs.readdirSync(PACKS_DIR).forEach((f) => {
        if (f !== `granth_pack_v${version}.zip` && f.startsWith('granth_pack_v')) {
          fs.unlinkSync(path.join(PACKS_DIR, f));
        }
      });

      resolve({ version, url: `${baseUrl}/packs/granth_pack_v${version}.zip` });
    });
    archive.on('error', reject);
    archive.pipe(output);

    archive.append(JSON.stringify(manifest, null, 2), { name: 'manifest.json' });

    // Every image referenced by any entity is a path like "images/xyz.jpg"
    // that multer already saved under UPLOADS_DIR/images/xyz.jpg.
    const imagesDir = path.join(UPLOADS_DIR, 'images');
    if (fs.existsSync(imagesDir)) {
      archive.directory(imagesDir, 'images');
    }

    archive.finalize();
  });
}

module.exports = { rebuildPack };
