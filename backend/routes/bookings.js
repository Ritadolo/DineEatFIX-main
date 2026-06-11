const express = require('express');
const router = express.Router();
const supabase = require('../supabaseClient');

// GET /api/bookings?user_id=xxx
router.get('/', async (req, res) => {
  const { user_id } = req.query;
  if (!user_id) return res.status(400).json({ error: 'user_id required' });
  const { data, error } = await supabase
    .from('bookings')
    .select('*, restaurants(name, image_url, cuisine)')
    .eq('user_id', user_id)
    .order('created_at', { ascending: false });
  if (error) return res.status(500).json({ error: error.message });
  res.json(data);
});

// POST /api/bookings
router.post('/', async (req, res) => {
  const { user_id, restaurant_id, date, time, guests, table_number, special_requests } = req.body;
  if (!user_id || !restaurant_id || !date || !time || !guests) {
    return res.status(400).json({ error: 'Missing required fields' });
  }
  const { data, error } = await supabase.from('bookings').insert({
    user_id,
    restaurant_id,
    date,
    time,
    guests,
    table_number,
    special_requests,
    status: 'pending',
  }).select().single();
  if (error) return res.status(500).json({ error: error.message });
  res.status(201).json(data);
});

// PATCH /api/bookings/:id/cancel
router.patch('/:id/cancel', async (req, res) => {
  const { data, error } = await supabase
    .from('bookings')
    .update({ status: 'cancelled' })
    .eq('id', req.params.id)
    .select()
    .single();
  if (error) return res.status(500).json({ error: error.message });
  res.json(data);
});

// PATCH /api/bookings/:id/confirm  (admin)
router.patch('/:id/confirm', async (req, res) => {
  const { data, error } = await supabase
    .from('bookings')
    .update({ status: 'confirmed' })
    .eq('id', req.params.id)
    .select()
    .single();
  if (error) return res.status(500).json({ error: error.message });
  res.json(data);
});

module.exports = router;
