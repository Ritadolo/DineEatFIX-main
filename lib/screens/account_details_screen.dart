import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_label.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AccountDetailsScreen> createState() =>
      _AccountDetailsScreenState();
}

class _AccountDetailsScreenState
    extends State<AccountDetailsScreen> {
  bool _twoFactor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(color: AppColors.midnightBlue),
        title: Text('Account Details', style: headline(20)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined,
                color: AppColors.midnightBlue),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildPersonalSection(),
            _buildSecuritySection(),
            const SizedBox(height: 32),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24),
              child: PrimaryButton(
                label: 'Save Changes',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Profile updated successfully',
                        style: GoogleFonts.inter(
                            color: Colors.white),
                      ),
                      backgroundColor:
                          AppColors.midnightBlue,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceVariant,
              border: Border.all(
                  color: AppColors.champagneGold, width: 2),
            ),
            child: const Icon(Icons.person,
                size: 40, color: AppColors.textGray),
          ),
          const SizedBox(height: 12),
          Text('Eleanor Vance', style: headline(22)),
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
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPersonalSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('PERSONAL INFORMATION'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: cardShadow,
            ),
            child: Column(
              children: [
                _infoField('Full Name', 'Eleanor Vance'),
                _divider(),
                _infoField('Email Address',
                    'eleanor@dineandgo.com'),
                _divider(),
                _infoField(
                    'Phone Number', '+1 (555) 123-4567'),
                _divider(),
                _infoField('Date of Birth', '',
                    trailingIcon:
                        Icons.calendar_month_outlined),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSecuritySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('SECURITY'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: cardShadow,
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.password_outlined,
                      color: AppColors.midnightBlue),
                  title: Text('Change Password',
                      style: body(15,
                          color: AppColors.midnightBlue)),
                  trailing: const Icon(Icons.chevron_right,
                      color: AppColors.textGray),
                  onTap: () {},
                ),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.security_outlined,
                        color: AppColors.midnightBlue,
                        size: 22),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text('Two-Factor Authentication',
                              style: body(15,
                                  color:
                                      AppColors.midnightBlue,
                                  fw: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text(
                              'Recommended for security',
                              style: body(12,
                                  color: AppColors.textGray)),
                        ],
                      ),
                    ),
                    Switch(
                      value: _twoFactor,
                      activeColor: AppColors.champagneGold,
                      onChanged: (v) =>
                          setState(() => _twoFactor = v),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoField(String label, String value,
      {IconData? trailingIcon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: body(12,
                        color: AppColors.textGray)),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? '—' : value,
                  style: body(15,
                      color: AppColors.midnightBlue,
                      fw: FontWeight.w500),
                ),
              ],
            ),
          ),
          if (trailingIcon != null)
            Icon(trailingIcon,
                size: 18, color: AppColors.textGray),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(
        height: 1, color: AppColors.surfaceVariant);
  }
}
