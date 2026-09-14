# ग्रंथ प्रबंधन — Full Platform (Server + Admin App + Viewer App)

Three independent pieces that work together:

```
server/       Node.js + Express backend — the single source of truth
admin_app/    Flutter app for authoring content (talks to the server)
viewer_app/   Flutter app for end users (downloads a resource pack, then offline)
```

## How data flows

1. Admin logs into **admin_app** and adds/edits Topics, Granths, Pramans, Feedback —
   each save is an API call straight to **server**, images included.
2. Every single change automatically rebuilds `granth_pack_vN.zip` on the server
   (manifest.json + all images) and bumps the version number. Nothing to
   manually "publish" — it's always live.
3. **viewer_app** periodically checks `GET /api/pack/version`. If the version
   is newer than what's installed, it downloads and extracts the new zip.
   Between checks, it works fully offline from the last-downloaded pack.
4. Feedback submitted inside **viewer_app** posts straight back to the server
   (`POST /api/feedback`, no login required) and shows up for the admin
   immediately in **admin_app**'s Feedback tab.

## 1. Deploy the server

You don't need a computer for this — Render's free tier builds straight from
GitHub in the browser:

1. Push the `server/` folder to a GitHub repo (same Termux flow you already
   used for the previous project — `git init`, `add`, `commit`, `push`).
2. Go to https://render.com → sign up with GitHub → **New +** → **Web Service**
3. Select your repo, set:
   - **Root Directory:** `server`
   - **Build Command:** `npm install`
   - **Start Command:** `npm start`
   - **Instance type:** Free
4. Add an environment variable `JWT_SECRET` set to any long random string.
5. Deploy. Render gives you a URL like `https://granth-server.onrender.com`.

⚠️ **Free tier note:** Render's free web services spin down after inactivity
and take ~30–60s to wake back up on the next request — expect a delay on the
first request after idle time. Fine for testing; upgrade the plan later if
you need always-on.

⚠️ **Storage note:** Free tiers usually don't persist disk between deploys.
Uploaded images and `data/db.json` living in the project folder will be wiped
on redeploy/restart. For a genuinely permanent setup, add a persistent disk
(Render's paid "Disks" add-on) mounted at `server/data` and `server/uploads`,
or swap in cloud storage (S3/Cloudinary) later — the code is structured so
that's a small change in `upload.js` and `db.js`, not a rewrite.

## 2. Run the Admin app

```bash
cd admin_app
flutter pub get
flutter run          # or: flutter build apk
```
On first launch: Settings (gear icon on login screen) → paste your server URL
→ Save. Then log in with `amit8080` / `amit8080` and change it via
**Manage Admins** once you're in (add your own account, then optionally
remove the default one — but keep at least one admin at all times).

## 3. Run the Viewer app

```bash
cd viewer_app
flutter pub get
flutter run          # or: flutter build apk
```
On first launch it needs your server URL too (gear icon, top right of the
loading screen) before it can do its first sync. After that, it's offline
until you tap the sync icon.

## Appearance

Both apps ship with three modes, switchable at runtime (Admin: drawer →
Appearance. Viewer: palette icon in the app bar):
- **Light** — the original saffron/maroon/gold look
- **Dark** — same palette, dark surfaces
- **Liquid Glass** — frosted, translucent cards over a gradient backdrop

## Before you ship to real users

- Change `JWT_SECRET` to something random and keep it secret.
- Log in as `amit8080` and either change its password or create your own
  admin and delete the default one.
- Move off the free Render tier (or add a persistent disk) once you have
  real content you don't want to lose.
- Give each app its own Android `applicationId` / iOS bundle ID so both can
  be installed on the same device without conflicting.
- Add app icons (`flutter_launcher_icons` package) — currently both use the
  default Flutter icon.
