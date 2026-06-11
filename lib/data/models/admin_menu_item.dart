class AdminMenuItem {
  final String id;
  String name;
  String category;
  double price;
  String description;
  String imageUrl;
  String prepTime;
  String tags;
  bool available;

  AdminMenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.prepTime,
    required this.tags,
    required this.available,
  });

  AdminMenuItem copyWith({
    String? name,
    String? category,
    double? price,
    String? description,
    String? imageUrl,
    String? prepTime,
    String? tags,
    bool? available,
  }) {
    return AdminMenuItem(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      prepTime: prepTime ?? this.prepTime,
      tags: tags ?? this.tags,
      available: available ?? this.available,
    );
  }
}

// ── Initial seed data ──────────────────────────────────────────────────────
List<AdminMenuItem> seedMenuItems() => [
  AdminMenuItem(
    id: 'm01', name: 'Truffle Arancini', category: 'Starters', price: 32,
    description: 'Crispy risotto balls, black truffle, aged parmesan, truffle oil drizzle.',
    imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600&q=70',
    prepTime: '10 min', tags: 'Vegetarian, Contains Gluten', available: true,
  ),
  AdminMenuItem(
    id: 'm02', name: 'Burrata Salad', category: 'Starters', price: 28,
    description: 'Buffalo burrata, heirloom tomatoes, fresh basil, extra virgin olive oil.',
    imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=600&q=70',
    prepTime: '8 min', tags: 'Vegetarian, Gluten-Free', available: true,
  ),
  AdminMenuItem(
    id: 'm03', name: 'Oysters Rockefeller', category: 'Starters', price: 38,
    description: 'Six fresh oysters, wilted spinach, Pernod cream, breadcrumb crust.',
    imageUrl: 'https://images.unsplash.com/photo-1582214191669-e20d55abb63d?w=600&q=70',
    prepTime: '12 min', tags: 'Contains Shellfish', available: true,
  ),
  AdminMenuItem(
    id: 'm04', name: 'Foie Gras Terrine', category: 'Starters', price: 52,
    description: 'House-made terrine, toasted brioche, Sauternes gelée, pickled shallots.',
    imageUrl: 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=600&q=70',
    prepTime: '5 min', tags: 'Contains Gluten', available: false,
  ),
  AdminMenuItem(
    id: 'm05', name: 'Wagyu Beef Tenderloin', category: 'Mains', price: 185,
    description: '300g A5 Wagyu, black truffle jus, pomme purée, seasonal microgreens.',
    imageUrl: 'https://images.unsplash.com/photo-1558030006-450675393462?w=600&q=70',
    prepTime: '25 min', tags: 'Gluten-Free', available: true,
  ),
  AdminMenuItem(
    id: 'm06', name: 'Pan-Seared Halibut', category: 'Mains', price: 75,
    description: 'Saffron beurre blanc, white asparagus, osetra caviar garnish.',
    imageUrl: 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=600&q=70',
    prepTime: '18 min', tags: 'Contains Fish, Gluten-Free', available: true,
  ),
  AdminMenuItem(
    id: 'm07', name: 'Duck Breast Confit', category: 'Mains', price: 68,
    description: 'Cherry & port reduction, celeriac gratin, haricots verts, duck jus.',
    imageUrl: 'https://images.unsplash.com/photo-1547592180-85f173990554?w=600&q=70',
    prepTime: '20 min', tags: 'Gluten-Free', available: true,
  ),
  AdminMenuItem(
    id: 'm08', name: "Chef's Tasting Menu", category: 'Mains', price: 280,
    description: 'Eight bespoke courses crafted daily by the chef, paired with sommelier picks.',
    imageUrl: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=600&q=70',
    prepTime: '90 min', tags: 'Contains Allergens — ask staff', available: true,
  ),
  AdminMenuItem(
    id: 'm09', name: 'Crème Brûlée', category: 'Desserts', price: 18,
    description: 'Classic Madagascan vanilla bean custard, caramelized sugar crust.',
    imageUrl: 'https://images.unsplash.com/photo-1470124182917-cc6e71b22ecc?w=600&q=70',
    prepTime: '5 min', tags: 'Vegetarian, Gluten-Free', available: true,
  ),
  AdminMenuItem(
    id: 'm10', name: 'Dark Chocolate Soufflé', category: 'Desserts', price: 22,
    description: 'Valrhona 72% dark chocolate, crème anglaise, candied orange zest.',
    imageUrl: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=600&q=70',
    prepTime: '20 min', tags: 'Vegetarian, Contains Gluten', available: true,
  ),
  AdminMenuItem(
    id: 'm11', name: 'Mille-Feuille', category: 'Desserts', price: 20,
    description: 'Caramelized puff pastry layers, vanilla diplomat cream, fresh berries.',
    imageUrl: 'https://images.unsplash.com/photo-1571115177098-24ec42ed204d?w=600&q=70',
    prepTime: '5 min', tags: 'Vegetarian', available: false,
  ),
  AdminMenuItem(
    id: 'm12', name: 'Anniversary Cake', category: 'Desserts', price: 65,
    description: 'Custom celebration cake with gold leaf — must be pre-ordered 48h ahead.',
    imageUrl: 'https://images.unsplash.com/photo-1535254973040-607b474cb50d?w=600&q=70',
    prepTime: 'Pre-order', tags: 'Vegetarian, Contains Gluten', available: true,
  ),
  AdminMenuItem(
    id: 'm13', name: 'Sommelier Wine Pairing', category: 'Drinks', price: 85,
    description: 'Five-course curated wine pairing selected from the 2,000-bottle cellar.',
    imageUrl: 'https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=600&q=70',
    prepTime: 'With meal', tags: 'Contains Sulfites', available: true,
  ),
  AdminMenuItem(
    id: 'm14', name: 'Dom Pérignon 2012', category: 'Drinks', price: 340,
    description: 'Prestige cuvée champagne served chilled. Vintage bottle, 750 ml.',
    imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600&q=70',
    prepTime: 'On order', tags: 'Contains Sulfites', available: true,
  ),
  AdminMenuItem(
    id: 'm15', name: 'Mocktail Flight', category: 'Drinks', price: 28,
    description: 'Three seasonal non-alcoholic specialties crafted by the bar team.',
    imageUrl: 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=600&q=70',
    prepTime: '8 min', tags: 'Vegan, Gluten-Free', available: true,
  ),
  AdminMenuItem(
    id: 'm16', name: 'Cognac Selection', category: 'Drinks', price: 120,
    description: 'VSOP Hennessy or Rémy Martin Louis XIII, served in Baccarat crystal.',
    imageUrl: 'https://images.unsplash.com/photo-1569529465841-dfecdab7503b?w=600&q=70',
    prepTime: 'On order', tags: '', available: false,
  ),
];
