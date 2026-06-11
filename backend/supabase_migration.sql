-- ============================================================
-- DineAndGo – Supabase Database Migration (clean reset)
-- Jalankan script ini di: Supabase Dashboard > SQL Editor
-- ============================================================

-- 0. DROP existing objects
-- Policies are dropped automatically by CASCADE on the tables.
drop trigger  if exists on_auth_user_created on auth.users;
drop function if exists public.handle_new_user();

drop table if exists public.bookings    cascade;
drop table if exists public.restaurants cascade;
drop table if exists public.profiles    cascade;

-- 1. PROFILES
create table public.profiles (
  id         uuid primary key references auth.users(id) on delete cascade,
  full_name  text,
  phone      text,
  avatar_url text,
  created_at timestamptz default now()
);

-- Auto-create profile row on new signup
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
begin
  insert into public.profiles (id, full_name, phone)
  values (
    new.id,
    new.raw_user_meta_data->>'full_name',
    new.raw_user_meta_data->>'phone'
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- 2. RESTAURANTS
create table public.restaurants (
  id          text primary key,
  name        text not null,
  cuisine     text,
  address     text,
  image_url   text,
  category    text,
  price_range text,
  distance    text,
  rating      numeric(3,1) default 0,
  created_at  timestamptz default now()
);

-- 3. BOOKINGS
create table public.bookings (
  id               uuid primary key default gen_random_uuid(),
  user_id          uuid not null references auth.users(id) on delete cascade,
  restaurant_id    text references public.restaurants(id),
  date             date not null,
  time             text not null,
  guests           int  not null default 1,
  table_number     text,
  special_requests text,
  status           text not null default 'pending'
                     check (status in ('pending','confirmed','cancelled')),
  created_at       timestamptz default now()
);

-- 4. ROW LEVEL SECURITY
alter table public.profiles    enable row level security;
alter table public.restaurants enable row level security;
alter table public.bookings    enable row level security;

-- profiles
create policy "profiles_select" on public.profiles
  for select using (auth.uid() = id);
create policy "profiles_update" on public.profiles
  for update using (auth.uid() = id);
create policy "profiles_insert" on public.profiles
  for insert with check (auth.uid() = id);

-- restaurants: anyone (logged-in or not) can read
create policy "restaurants_select" on public.restaurants
  for select using (true);

-- bookings: users manage their own rows
create policy "bookings_select" on public.bookings
  for select using (auth.uid() = user_id);
create policy "bookings_insert" on public.bookings
  for insert with check (auth.uid() = user_id);
create policy "bookings_update" on public.bookings
  for update using (auth.uid() = user_id);

-- 5. SEED restaurants
insert into public.restaurants (id, name, cuisine, address, image_url, category, price_range, distance, rating)
values
  ('r1', 'L''Aura',          'Modern French', '124 Elegance Ave, Downtown District', 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&q=80', 'Fine Dining', '$$$$', '1.2 mi', 4.9),
  ('r2', 'Kintaro',          'Omakase',        '88 Sakura Lane, Midtown',              'https://images.unsplash.com/photo-1617196034183-421b4040ed20?w=800&q=80', 'Omakase',     '$$$$', '2.5 mi', 4.8),
  ('r3', 'Le Bernardin',     'French Seafood', '55 Ocean Drive, West Side',            'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=80', 'Seafood',     '$$$$', '1.2 mi', 4.8),
  ('r4', 'L''Atelier d''Or', 'Fine Dining',    '12 Prestige Blvd, Uptown',             'https://images.unsplash.com/photo-1544025162-d76694265947?w=800&q=80', 'Fine Dining', '$$$$', '0.9 mi', 4.7);
