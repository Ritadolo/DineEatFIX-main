const express = require('express');
const router = express.Router();
const supabase = require('../supabaseClient');

// GET /api/restaurants
router.get('/', async (req, res) => {
  const { category } = req.query;
  let query = supabase.from('restaurants').select('*').order('rating', { ascending: false });
  if (category && category !== 'All') {
    query = query.eq('category', category);
  }
  const { data, error } = await query;
  if (error) return res.status(500).json({ error: error.message });
  res.json(data);
});

// GET /api/restaurants/:id
router.get('/:id', async (req, res) => {
  const { data, error } = await supabase
    .from('restaurants')
    .select('*')
    .eq('id', req.params.id)
    .single();
  if (error) return res.status(404).json({ error: 'Restaurant not found' });
  res.json(data);
});

module.exports = router;
