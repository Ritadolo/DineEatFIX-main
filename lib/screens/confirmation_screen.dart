import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../widgets/primary_button.dart';
import 'booking_ticket_screen.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({Key? key}) : super(key: key);

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  int _selectedPayment = 0;

  static const _paymentMethods = [
    {'icon': Icons.credit_card, 'label': 'Credit Card', 'sub': '•••• 4242'},
    {'icon': Icons.account_balance_wallet, 'label': 'Digital Wallet', 'sub': ''},
    {'icon': Icons.account_balance, 'label': 'Bank Transfer', 'sub': ''},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(color: AppColors.midnightBlue),
        title: Text('Checkout',
            style: headline(20)),
        centerTitle: true,
        actions: const [SizedBox(width: 48)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildReservationCard(),
            const SizedBox(height: 24),
            _buildOrderSummaryCard(),
            const SizedBox(height: 24),
            _buildPaymentCard(),
            const SizedBox(height: 24),
            _buildTotalRow(),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'PAY & CONFIRM BOOKING',
              leadingIcon: Icons.lock_outline,
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => const BookingTicketScreen()),
                (_) => false,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildReservationCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reservation Details', style: headline(18)),
          const Divider(height: 24),
          _detailRow('Restaurant', "L'Orangerie"),
          _detailRow('Date', 'Oct 24, 2023'),
          _detailRow('Time', '19:30'),
          _detailRow('Guests', '2 People'),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary', style: headline(18)),
          const Divider(height: 24),
          _orderItemRow('Wagyu Beef Tenderloin × 1', '\$85.00'),
          const Divider(height: 16),
          _orderItemRow('Sommelier Wine Pairing × 1', '\$85.00'),
          const Divider(height: 16),
          _detailRow('Subtotal', '\$470.00'),
          _detailRow('Taxes & Fees', '\$42.30'),
        ],
      ),
    );
  }

  Widget _buildPaymentCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment Method', style: headline(18)),
          const SizedBox(height: 16),
          ..._paymentMethods.asMap().entries.map((e) {
            final idx = e.key;
            final m = e.value;
            final sel = idx == _selectedPayment;
            return GestureDetector(
              onTap: () => setState(() => _selectedPayment = idx),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: sel
                      ? AppColors.midnightBlue.withOpacity(0.05)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: sel
                        ? AppColors.champagneGold
                        : AppColors.borderGray,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(m['icon'] as IconData,
                        color: AppColors.midnightBlue, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(m['label'] as String,
                          style: body(14,
                              color: AppColors.midnightBlue,
                              fw: FontWeight.w500)),
                    ),
                    if ((m['sub'] as String).isNotEmpty)
                      Text(m['sub'] as String,
                          style: body(13,
                              color: AppColors.textGray)),
                    const SizedBox(width: 8),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: sel
                            ? AppColors.champagneGold
                            : Colors.transparent,
                        border: Border.all(
                          color: sel
                              ? AppColors.champagneGold
                              : AppColors.borderGray,
                          width: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTotalRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text('Total Amount',
              style: body(16,
                  color: AppColors.midnightBlue,
                  fw: FontWeight.w600)),
          const Spacer(),
          Text('\$512.30',
              style: headline(26,
                  color: AppColors.champagneGold)),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: cardShadow,
      ),
      child: child,
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(label,
              style: body(14, color: AppColors.textGray)),
          const Spacer(),
          Text(value,
              style: body(15,
                  color: AppColors.midnightBlue,
                  fw: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _orderItemRow(String name, String price) {
    return Row(
      children: [
        Expanded(
            child: Text(name,
                style: body(14,
                    color: AppColors.textPrimary))),
        Text(price,
            style: body(14,
                color: AppColors.midnightBlue,
                fw: FontWeight.w600)),
      ],
    );
  }
}
