require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');

const authRoutes = require('./routes/auth');
const topicsRoutes = require('./routes/topics');
const granthsRoutes = require('./routes/granths');
const pramansRoutes = require('./routes/pramans');
const feedbackRoutes = require('./routes/feedback');
const packRoutes = require('./routes/pack');

const app = express();
const PORT = process.env.PORT || 4000;

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve generated resource pack zips + uploaded images statically.
app.use('/packs', express.static(path.join(__dirname, 'public', 'packs')));
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

app.get('/', (req, res) => res.json({ status: 'ok', service: 'granth-server' }));

app.use('/api/auth', authRoutes);
app.use('/api/topics', topicsRoutes);
app.use('/api/granths', granthsRoutes);
app.use('/api/pramans', pramansRoutes);
app.use('/api/feedback', feedbackRoutes);
app.use('/api/pack', packRoutes);

// Basic error handler (e.g. multer file-type/size errors)
app.use((err, req, res, next) => {
  console.error(err);
  res.status(400).json({ error: err.message || 'Something went wrong' });
});

app.listen(PORT, () => {
  console.log(`Granth server running on http://localhost:${PORT}`);
});
