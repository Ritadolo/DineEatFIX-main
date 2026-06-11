require('dotenv').config();
const express = require('express');
const cors    = require('cors');

const restaurantsRouter = require('./routes/restaurants');
const bookingsRouter    = require('./routes/bookings');
const authRouter        = require('./routes/auth');

const app  = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// ── Routes ────────────────────────────────────────────────────────────────────
app.use('/api/restaurants', restaurantsRouter);
app.use('/api/bookings',    bookingsRouter);
app.use('/api/auth',        authRouter);

app.get('/', (req, res) => res.json({ status: 'DineAndGo API running' }));

app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));
