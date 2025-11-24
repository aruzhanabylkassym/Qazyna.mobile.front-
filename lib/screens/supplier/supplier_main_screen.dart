import 'package:flutter/material.dart';
import 'home_supplier_screen.dart';
import 'products_screen.dart';
import 'orders_screen.dart';
import 'profile_supplier_screen.dart';

class SupplierMainScreen extends StatefulWidget {
  const SupplierMainScreen({super.key});

  @override
  State<SupplierMainScreen> createState() => _SupplierMainScreenState();
}

class _SupplierMainScreenState extends State<SupplierMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeSupplierScreen(),
    const ProductsScreen(),
    const OrdersScreen(),
    const ProfileSupplierScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF768C4A),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

