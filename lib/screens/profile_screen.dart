import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home_screen.dart';
import 'my_bookings_screen.dart';
import 'saved_screen.dart';
import 'account_details_screen.dart';
import 'registration_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    Widget? screen;
    switch (index) {
      case 0:
        screen = const HomeScreen();
        break;
      case 1:
        screen = const MyBookingsScreen();
        break;
      case 2:
        screen = const SavedScreen();
        break;
    }
    if (screen != null) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => screen!), (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Icon(Icons.menu, color: AppColors.midnightBlue),
        title: Text('DineAndGo', style: headline(20)),
        centerTitle: true,
        actions: const [SizedBox(width: 48)],
      ),
      bottomNavigationBar:
          BottomNavBar(currentIndex: 3, onTap: _onNavTap),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 16),
            _buildBookingsSection(),
            const SizedBox(height: 16),
            _buildSettingsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: cardShadow,
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceVariant,
            ),
            child: const Icon(Icons.person,
                size: 40, color: AppColors.textGray),
          ),
          const SizedBox(height: 12),
          Text('Alexander Pierce', style: headline(22)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.workspace_premium,
                  size: 16, color: AppColors.champagneGold),
              const SizedBox(width: 4),
              Text('Gold Member',
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.champagneGold,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: cardShadow,
      ),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: AppColors.champagneGold,
            indicatorWeight: 2,
            labelStyle: GoogleFonts.inter(
                fontSize: 14, fontWeight: FontWeight.bold),
            unselectedLabelStyle: GoogleFonts.inter(fontSize: 14),
            labelColor: AppColors.midnightBlue,
            unselectedLabelColor: AppColors.textGray,
            tabs: const [
              Tab(text: 'Upcoming'),
              Tab(text: 'History'),
            ],
          ),
          SizedBox(
            height: 190,
            child: TabBarView(
              controller: _tabController,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _miniBookingCard(),
                ),
                Center(
                  child: Text('No history',
                      style: body(13,
                          color: AppColors.textGray)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniBookingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Le Bernardin',
                    style: body(16,
                        color: AppColors.midnightBlue,
                        fw: FontWeight.bold)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.confirmed.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle,
                        size: 12,
                        color: AppColors.confirmed),
                    const SizedBox(width: 4),
                    Text('Confirmed',
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.confirmed,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('French Seafood • 1.2 mi',
              style: body(12, color: AppColors.textGray)),
          const SizedBox(height: 8),
          _miniDetail('Date', 'Oct 24, 2023'),
          _miniDetail('Time', '19:30'),
          _miniDetail('Guests', '2'),
        ],
      ),
    );
  }

  Widget _miniDetail(String label, String val) {
    return Row(
      children: [
        Text('$label: ',
            style: body(12, color: AppColors.textGray)),
        Text(val,
            style: body(12,
                color: AppColors.midnightBlue,
                fw: FontWeight.w600)),
      ],
    );
  }

  Widget _buildSettingsList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: cardShadow,
      ),
      // Material wrapper fixes ListTile ink/background visibility warning
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: Column(
        children: [
          _settingsTile(
            icon: Icons.person_outline,
            title: 'Account Details',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      const AccountDetailsScreen()),
            ),
          ),
          _divider(),
          _settingsTile(
            icon: Icons.credit_card,
            title: 'Payment Methods',
            onTap: () {},
          ),
          _divider(),
          _settingsTile(
            icon: Icons.support_agent,
            title: 'Concierge/Help',
            onTap: () {},
          ),
          const Divider(
              height: 1, color: AppColors.surfaceVariant),
          _settingsTile(
            icon: Icons.logout,
            title: 'Log Out',
            titleColor: AppColors.error,
            iconColor: AppColors.error,
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      const RegistrationScreen()),
              (_) => false,
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    Color iconColor = AppColors.midnightBlue,
    Color titleColor = AppColors.midnightBlue,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor, size: 22),
      title: Text(title,
          style: GoogleFonts.inter(
              fontSize: 15,
              color: titleColor)),
      trailing: Icon(Icons.chevron_right,
          color: titleColor == AppColors.error
              ? AppColors.error
              : AppColors.textGray),
      onTap: onTap,
    );
  }

  Widget _divider() {
    return const Divider(
        height: 1,
        indent: 56,
        color: AppColors.surfaceVariant);
  }
}
