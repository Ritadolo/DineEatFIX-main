import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/models/admin_menu_item.dart';

// ── Category colour map ──────────────────────────────────────────────────────
const _catColors = {
  'Starters': Color(0xFF1565C0),
  'Mains':    Color(0xFF031636),
  'Desserts': Color(0xFFB8860B),
  'Drinks':   Color(0xFF2E7D32),
  'Specials': Color(0xFFBA1A1A),
};
const _catBgs = {
  'Starters': Color(0xFFE3EEFA),
  'Mains':    Color(0xFFE8EAF0),
  'Desserts': Color(0xFFFDF6DC),
  'Drinks':   Color(0xFFE8F5E9),
  'Specials': Color(0xFFFFEBEE),
};

// ── Page ─────────────────────────────────────────────────────────────────────
class AdminFnbPage extends StatefulWidget {
  const AdminFnbPage({super.key});
  @override
  State<AdminFnbPage> createState() => _AdminFnbPageState();
}

class _AdminFnbPageState extends State<AdminFnbPage> {
  late List<AdminMenuItem> _items;
  String _activeCategory = 'All';
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  static const _categories = ['All', 'Starters', 'Mains', 'Desserts', 'Drinks', 'Specials'];

  @override
  void initState() {
    super.initState();
    _items = seedMenuItems();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<AdminMenuItem> get _filtered {
    return _items.where((i) {
      final matchCat = _activeCategory == 'All' || i.category == _activeCategory;
      final q = _searchQuery.toLowerCase();
      final matchSearch = q.isEmpty ||
          i.name.toLowerCase().contains(q) ||
          i.category.toLowerCase().contains(q) ||
          i.description.toLowerCase().contains(q);
      return matchCat && matchSearch;
    }).toList();
  }

  // ── Stats ──────────────────────────────────────────────────────────────────
  int get _totalItems => _items.length;
  int get _availableItems => _items.where((i) => i.available).length;
  int get _unavailableItems => _totalItems - _availableItems;
  double get _avgPrice => _totalItems == 0
      ? 0
      : _items.fold(0.0, (s, i) => s + i.price) / _totalItems;

  // ── Dialogs ────────────────────────────────────────────────────────────────
  void _openItemDialog({AdminMenuItem? item}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _ItemDialog(
        existing: item,
        allCategories: _categories.where((c) => c != 'All').toList(),
        onSave: (updated) {
          setState(() {
            if (item == null) {
              _items.add(updated);
            } else {
              final idx = _items.indexWhere((i) => i.id == updated.id);
              if (idx != -1) _items[idx] = updated;
            }
          });
          _showSnackbar(
            item == null ? '"${updated.name}" added to menu' : '"${updated.name}" updated',
            icon: Icons.check_circle_outline,
          );
        },
      ),
    );
  }

  void _deleteItem(AdminMenuItem item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Delete Item',
            style: GoogleFonts.playfairDisplay(
                fontSize: 18, fontWeight: FontWeight.w700,
                color: const Color(0xFFBA1A1A))),
        content: RichText(
          text: TextSpan(
            style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF44474E)),
            children: [
              const TextSpan(text: 'Are you sure you want to delete '),
              TextSpan(text: '"${item.name}"',
                  style: const TextStyle(fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1C1C))),
              const TextSpan(text: '? This cannot be undone.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF75777F))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _items.removeWhere((i) => i.id == item.id));
              _showSnackbar('"${item.name}" deleted',
                  icon: Icons.delete_outline, isError: true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBA1A1A),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Delete', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(String msg,
      {IconData icon = Icons.check_circle_outline, bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(msg, style: GoogleFonts.inter(fontSize: 13)),
        ]),
        backgroundColor: isError ? const Color(0xFFBA1A1A) : const Color(0xFF031636),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopBar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsRow(),
                const SizedBox(height: 20),
                _buildCategoryFilter(),
                const SizedBox(height: 16),
                _buildGridHeader(),
                const SizedBox(height: 12),
                Expanded(child: _buildGrid()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Top bar ────────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Container(
      height: 64,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Text('Food & Beverage',
              style: GoogleFonts.playfairDisplay(
                  fontSize: 22, fontWeight: FontWeight.w700,
                  color: const Color(0xFF031636))),
          const Spacer(),
          // Search field
          SizedBox(
            width: 240,
            height: 38,
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _searchQuery = v),
              style: GoogleFonts.inter(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Search items...',
                hintStyle: GoogleFonts.inter(
                    fontSize: 13, color: const Color(0xFF9E9E9E)),
                prefixIcon: const Icon(Icons.search,
                    size: 18, color: Color(0xFF9E9E9E)),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Add Item button
          ElevatedButton.icon(
            onPressed: () => _openItemDialog(),
            icon: const Icon(Icons.add, size: 16),
            label: Text('Add Item',
                style: GoogleFonts.inter(
                    fontSize: 13, fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats row ──────────────────────────────────────────────────────────────
  Widget _buildStatsRow() {
    return Row(
      children: [
        _statCard('Total Items', '$_totalItems',
            Icons.restaurant_menu_outlined, const Color(0xFF031636)),
        const SizedBox(width: 14),
        _statCard('Available', '$_availableItems',
            Icons.check_circle_outline, const Color(0xFF2E7D32)),
        const SizedBox(width: 14),
        _statCard('Unavailable', '$_unavailableItems',
            Icons.cancel_outlined, const Color(0xFFBA1A1A)),
        const SizedBox(width: 14),
        _statCard('Avg. Price', '\$${_avgPrice.toStringAsFixed(0)}',
            Icons.attach_money, const Color(0xFFD4AF37)),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF031636))),
                Text(label,
                    style: GoogleFonts.inter(
                        fontSize: 11, color: const Color(0xFF75777F))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Category filter ────────────────────────────────────────────────────────
  Widget _buildCategoryFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((cat) {
          final count = cat == 'All'
              ? _items.length
              : _items.where((i) => i.category == cat).length;
          final isActive = cat == _activeCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _activeCategory = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF031636)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive
                        ? const Color(0xFF031636)
                        : const Color(0xFFDDDDDD),
                  ),
                  boxShadow: isActive
                      ? [BoxShadow(
                          color: const Color(0xFF031636).withOpacity(0.2),
                          blurRadius: 6, offset: const Offset(0, 2))]
                      : null,
                ),
                child: Text('$cat  ($count)',
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isActive
                            ? Colors.white
                            : const Color(0xFF44474E))),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Grid header ────────────────────────────────────────────────────────────
  Widget _buildGridHeader() {
    final count = _filtered.length;
    return Row(
      children: [
        Text(
          '$count item${count != 1 ? 's' : ''}'
          '${_activeCategory != 'All' ? ' in $_activeCategory' : ''}',
          style: GoogleFonts.inter(
              fontSize: 13, color: const Color(0xFF75777F)),
        ),
      ],
    );
  }

  // ── Grid ───────────────────────────────────────────────────────────────────
  Widget _buildGrid() {
    final list = _filtered;
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu_outlined,
                size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text('No items found',
                style: GoogleFonts.inter(
                    fontSize: 15, color: const Color(0xFF75777F))),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => _openItemDialog(),
              icon: const Icon(Icons.add, size: 16,
                  color: Color(0xFFD4AF37)),
              label: Text('Add new item',
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFD4AF37))),
            ),
          ],
        ),
      );
    }
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280,
        mainAxisExtent: 340,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: list.length,
      itemBuilder: (_, i) => _ItemCard(
        item: list[i],
        onEdit: () => _openItemDialog(item: list[i]),
        onDelete: () => _deleteItem(list[i]),
        onToggleAvail: () {
          setState(() => list[i].available = !list[i].available);
        },
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  Item Card Widget
// ══════════════════════════════════════════════════════════════════════════════
class _ItemCard extends StatelessWidget {
  final AdminMenuItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleAvail;

  const _ItemCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleAvail,
  });

  @override
  Widget build(BuildContext context) {
    final catColor = _catColors[item.category] ?? const Color(0xFF031636);
    final catBg = _catBgs[item.category] ?? const Color(0xFFE8EAF0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image ──────────────────────────────────────────────────────────
          Stack(
            children: [
              item.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      width: double.infinity,
                      height: 148,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        height: 148,
                        color: const Color(0xFFF0F2F5),
                        child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                      errorWidget: (_, __, ___) => _imgPlaceholder(),
                    )
                  : _imgPlaceholder(),
              // Unavailable overlay
              if (!item.available)
                Container(
                  height: 148,
                  color: Colors.black.withOpacity(0.45),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFBA1A1A),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('UNAVAILABLE',
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1)),
                    ),
                  ),
                ),
            ],
          ),
          // ── Body ──────────────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(item.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF031636))),
                      ),
                      const SizedBox(width: 6),
                      Text('\$${item.price.toStringAsFixed(0)}',
                          style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF031636))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: catBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(item.category.toUpperCase(),
                            style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.6,
                                color: catColor)),
                      ),
                      if (item.prepTime.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Icon(Icons.timer_outlined,
                            size: 11, color: const Color(0xFF9E9E9E)),
                        const SizedBox(width: 3),
                        Text(item.prepTime,
                            style: GoogleFonts.inter(
                                fontSize: 11,
                                color: const Color(0xFF9E9E9E))),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF75777F),
                          height: 1.4)),
                ],
              ),
            ),
          ),
          // ── Footer ────────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
            ),
            child: Row(
              children: [
                // Availability toggle
                GestureDetector(
                  onTap: onToggleAvail,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 36,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: item.available
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFBDBDBD),
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      alignment: item.available
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: 16,
                        height: 16,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.available ? 'Available' : 'Unavailable',
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: item.available
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFF9E9E9E)),
                  ),
                ),
                // Edit button
                _cardBtn(
                  Icons.edit_outlined, 'Edit',
                  const Color(0xFF031636),
                  const Color(0xFFE8EAF0),
                  onEdit,
                ),
                const SizedBox(width: 6),
                // Delete button
                _cardBtn(
                  Icons.delete_outline, null,
                  const Color(0xFFBA1A1A),
                  const Color(0xFFFFEBEE),
                  onDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imgPlaceholder() => Container(
        height: 148,
        color: const Color(0xFFF0F2F5),
        child: const Center(
          child: Icon(Icons.restaurant_menu_outlined,
              size: 40, color: Color(0xFFBDBDBD)),
        ),
      );

  Widget _cardBtn(IconData icon, String? label, Color color, Color bg,
      VoidCallback onTap) {
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: label != null ? 8 : 6, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 13, color: color),
              if (label != null) ...[
                const SizedBox(width: 4),
                Text(label,
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: color)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  Add / Edit Dialog
// ══════════════════════════════════════════════════════════════════════════════
class _ItemDialog extends StatefulWidget {
  final AdminMenuItem? existing;
  final List<String> allCategories;
  final void Function(AdminMenuItem) onSave;

  const _ItemDialog({
    required this.existing,
    required this.allCategories,
    required this.onSave,
  });

  @override
  State<_ItemDialog> createState() => _ItemDialogState();
}

class _ItemDialogState extends State<_ItemDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _price;
  late final TextEditingController _prepTime;
  late final TextEditingController _desc;
  late final TextEditingController _tags;
  late final TextEditingController _imgUrl;
  late String _category;
  late bool _available;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _price = TextEditingController(
        text: e != null ? e.price.toStringAsFixed(0) : '');
    _prepTime = TextEditingController(text: e?.prepTime ?? '');
    _desc = TextEditingController(text: e?.description ?? '');
    _tags = TextEditingController(text: e?.tags ?? '');
    _imgUrl = TextEditingController(text: e?.imageUrl ?? '');
    _category = e?.category ?? widget.allCategories.first;
    _available = e?.available ?? true;
  }

  @override
  void dispose() {
    for (final c in [_name, _price, _prepTime, _desc, _tags, _imgUrl]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final isNew = widget.existing == null;
    final item = AdminMenuItem(
      id: isNew
          ? 'u${DateTime.now().millisecondsSinceEpoch}'
          : widget.existing!.id,
      name: _name.text.trim(),
      category: _category,
      price: double.tryParse(_price.text.trim()) ?? 0,
      description: _desc.text.trim(),
      imageUrl: _imgUrl.text.trim(),
      prepTime: _prepTime.text.trim(),
      tags: _tags.text.trim(),
      available: _available,
    );
    Navigator.pop(context);
    widget.onSave(item);
  }

  // ── Styles ─────────────────────────────────────────────────────────────────
  InputDecoration _dec(String hint, {String? prefix}) => InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF9E9E9E)),
        prefixText: prefix,
        prefixStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF75777F)),
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF031636), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFBA1A1A)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        isDense: true,
      );

  Widget _fieldLabel(String text, {bool required = false}) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(children: [
          Text(text,
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF44474E))),
          if (required)
            Text(' *',
                style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFBA1A1A))),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final isNew = widget.existing == null;
    final previewUrl = _imgUrl.text.trim();

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(24),
      child: SizedBox(
        width: 660,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 20),
              decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Color(0xFFEEEEEE))),
              ),
              child: Row(
                children: [
                  Text(isNew ? 'Add New Item' : 'Edit Item',
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF031636))),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFEEEEEE),
                      foregroundColor: const Color(0xFF44474E),
                      padding: const EdgeInsets.all(6),
                    ),
                  ),
                ],
              ),
            ),
            // ── Form body ───────────────────────────────────────────────────
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left column — image
                          SizedBox(
                            width: 180,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _fieldLabel('Photo'),
                                // Preview
                                StatefulBuilder(
                                  builder: (ctx, setSt) => Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: previewUrl.isNotEmpty
                                              ? CachedNetworkImage(
                                                  imageUrl: previewUrl,
                                                  width: 180,
                                                  height: 130,
                                                  fit: BoxFit.cover,
                                                  errorWidget:
                                                      (_, __, ___) =>
                                                          _placeholderBox(),
                                                )
                                              : _placeholderBox(),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _imgUrl,
                                        style: GoogleFonts.inter(fontSize: 12),
                                        decoration: _dec(
                                            'Paste image URL (https://...)'),
                                        onChanged: (_) => setState(() {}),
                                      ),
                                      const SizedBox(height: 4),
                                      Text('Use any Unsplash URL',
                                          style: GoogleFonts.inter(
                                              fontSize: 10,
                                              color:
                                                  const Color(0xFF9E9E9E))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          // Right column — fields
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name
                                _fieldLabel('Item Name', required: true),
                                TextFormField(
                                  controller: _name,
                                  style: GoogleFonts.inter(fontSize: 13),
                                  decoration: _dec('e.g. Truffle Arancini'),
                                  validator: (v) => (v == null || v.trim().isEmpty)
                                      ? 'Name is required'
                                      : null,
                                ),
                                const SizedBox(height: 14),
                                // Category + Price row
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _fieldLabel('Category',
                                              required: true),
                                          DropdownButtonFormField<String>(
                                            initialValue: _category,
                                            onChanged: (v) => setState(
                                                () => _category = v!),
                                            items: widget.allCategories
                                                .map((c) => DropdownMenuItem(
                                                      value: c,
                                                      child: Text(c,
                                                          style: GoogleFonts
                                                              .inter(
                                                                  fontSize:
                                                                      13)),
                                                    ))
                                                .toList(),
                                            style: GoogleFonts.inter(
                                                fontSize: 13,
                                                color:
                                                    const Color(0xFF1A1C1C)),
                                            decoration: _dec(''),
                                            dropdownColor: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _fieldLabel('Price (USD)',
                                              required: true),
                                          TextFormField(
                                            controller: _price,
                                            style: GoogleFonts.inter(
                                                fontSize: 13),
                                            keyboardType:
                                                const TextInputType
                                                    .numberWithOptions(
                                                    decimal: true),
                                            decoration: _dec('0',
                                                prefix: '\$ '),
                                            validator: (v) {
                                              final d =
                                                  double.tryParse(v ?? '');
                                              if (d == null || d < 0) {
                                                return 'Enter valid price';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                // Prep time
                                _fieldLabel('Prep Time'),
                                TextFormField(
                                  controller: _prepTime,
                                  style: GoogleFonts.inter(fontSize: 13),
                                  decoration: _dec('e.g. 15 min'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Description
                      _fieldLabel('Description'),
                      TextFormField(
                        controller: _desc,
                        style: GoogleFonts.inter(fontSize: 13),
                        maxLines: 3,
                        decoration: _dec(
                            'Describe the dish — ingredients, cooking style…'),
                      ),
                      const SizedBox(height: 14),
                      // Tags
                      _fieldLabel('Allergens / Dietary Tags'),
                      TextFormField(
                        controller: _tags,
                        style: GoogleFonts.inter(fontSize: 13),
                        decoration: _dec(
                            'e.g. Gluten-Free, Vegan, Contains Nuts'),
                      ),
                      const SizedBox(height: 4),
                      Text('Comma-separated tags',
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              color: const Color(0xFF9E9E9E))),
                      const SizedBox(height: 16),
                      // Availability toggle
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7F7),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: const Color(0xFFDDDDDD)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text('Available on Menu',
                                      style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              const Color(0xFF1A1C1C))),
                                  const SizedBox(height: 2),
                                  Text(
                                      'Guests can see and pre-order this item',
                                      style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color:
                                              const Color(0xFF75777F))),
                                ],
                              ),
                            ),
                            Switch(
                              value: _available,
                              onChanged: (v) =>
                                  setState(() => _available = v),
                              activeThumbColor: Colors.white,
                              activeTrackColor: const Color(0xFF2E7D32),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // ── Footer ──────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 20),
              decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(color: Color(0xFFEEEEEE))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF44474E),
                      side: const BorderSide(color: Color(0xFFDDDDDD)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 11),
                    ),
                    child: Text('Cancel',
                        style: GoogleFonts.inter(
                            fontSize: 13, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF031636),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 11),
                    ),
                    child: Text(
                        isNew ? 'Add Item' : 'Save Changes',
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderBox() => Container(
        width: 180,
        height: 130,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F2F5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: const Color(0xFFDDDDDD), style: BorderStyle.solid),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined,
                size: 28, color: Color(0xFFBDBDBD)),
            SizedBox(height: 6),
            Text('No image',
                style: TextStyle(
                    fontSize: 11, color: Color(0xFFBDBDBD))),
          ],
        ),
      );
}
