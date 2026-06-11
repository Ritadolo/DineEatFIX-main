import 'package:flutter/material.dart';
import 'admin_sidebar.dart';
import 'pages/admin_dashboard_page.dart';
import 'pages/admin_table_map_page.dart';
import 'pages/admin_orders_page.dart';
import 'pages/admin_customers_page.dart';
import 'pages/admin_fnb_page.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _currentIndex = 0;

  static const _pages = [
    AdminDashboardPage(),
    AdminTableMapPage(),
    AdminOrdersPage(),
    AdminCustomersPage(),
    AdminFnbPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: Row(
        children: [
          AdminSidebar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
          ),
          Expanded(
            child: _pages[_currentIndex],
          ),
        ],
      ),
    );
  }
}
