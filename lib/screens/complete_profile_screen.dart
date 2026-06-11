import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_label.dart';
import 'home_screen.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  State<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final Set<String> _selectedCuisines = {};
  bool _dietaryEnabled = false;

  static const _cuisines = [
    'French',
    'Japanese',
    'Italian',
    'Steakhouse',
    'Vegan',
    'Seafood',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(color: AppColors.midnightBlue),
        title: Text('DineAndGo', style: headline(18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Complete Your Profile',
                style: headline(28), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Personalize your dining experience.',
              style: body(14, color: AppColors.textGray),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Avatar
            Center(child: _buildAvatar()),
            const SizedBox(height: 28),

            // Full Name
            _fieldLabel('Full Name'),
            const SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Your display name',
                hintStyle: body(14, color: AppColors.textGray),
              ),
            ),
            const SizedBox(height: 16),

            // Bio
            _fieldLabel('Bio'),
            const SizedBox(height: 8),
            TextFormField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Tell us about your dining preferences...',
                hintStyle: body(14, color: AppColors.textGray),
              ),
            ),
            const SizedBox(height: 32),

            // Dining Preferences
            Text('Dining Preferences', style: headline(22)),
            const SizedBox(height: 16),
            const SectionLabel('CUISINES'),
            const SizedBox(height: 12),
            _buildCuisineChips(),
            const Divider(height: 32),

            // Dietary
            _buildDietaryRow(),
            const SizedBox(height: 32),

            PrimaryButton(
              label: 'Start Exploring',
              icon: Icons.arrow_forward,
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (_) => false,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderGray, width: 2),
              color: AppColors.background,
            ),
            child: const Icon(Icons.person_outline,
                size: 48, color: AppColors.textGray),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.champagneGold,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.camera_alt,
                  size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCuisineChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _cuisines.map((c) {
        final selected = _selectedCuisines.contains(c);
        return GestureDetector(
          onTap: () => setState(() {
            if (selected) {
              _selectedCuisines.remove(c);
            } else {
              _selectedCuisines.add(c);
            }
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
            decoration: BoxDecoration(
              color:
                  selected ? AppColors.midnightBlue : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected
                    ? AppColors.midnightBlue
                    : AppColors.borderGray,
              ),
            ),
            child: Text(
              c,
              style: body(13,
                  color: selected ? Colors.white : AppColors.textPrimary,
                  fw: FontWeight.w500),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDietaryRow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dietary Requirements',
                  style:
                      body(15, color: AppColors.textPrimary, fw: FontWeight.bold)),
              const SizedBox(height: 2),
              Text('Enable to specify restrictions',
                  style: body(13, color: AppColors.textGray)),
            ],
          ),
        ),
        Switch(
          value: _dietaryEnabled,
          activeColor: AppColors.champagneGold,
          onChanged: (v) => setState(() => _dietaryEnabled = v),
        ),
      ],
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style:
          body(14, color: AppColors.textSecondary, fw: FontWeight.w600),
    );
  }
}
