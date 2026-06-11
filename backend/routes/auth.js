const express = require('express');
const router = express.Router();
const supabase = require('../supabaseClient');

// POST /api/auth/signup
router.post('/signup', async (req, res) => {
  const { email, password, full_name, phone } = req.body;
  if (!email || !password || !full_name) {
    return res.status(400).json({ error: 'email, password, full_name required' });
  }
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: { data: { full_name, phone: phone ?? '' } },
  });
  if (error) return res.status(400).json({ error: error.message });
  res.status(201).json({ user: data.user });
});

// POST /api/auth/login
router.post('/login', async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) return res.status(400).json({ error: 'email and password required' });
  const { data, error } = await supabase.auth.signInWithPassword({ email, password });
  if (error) return res.status(401).json({ error: error.message });
  res.json({ user: data.user, session: data.session });
});

// POST /api/auth/logout
router.post('/logout', async (req, res) => {
  await supabase.auth.signOut();
  res.json({ message: 'Logged out' });
});

module.exports = router;
