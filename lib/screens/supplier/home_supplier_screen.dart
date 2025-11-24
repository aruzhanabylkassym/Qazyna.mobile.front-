import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app.dart';
import '../../services/link_service.dart';
import '../../services/order_service.dart';
import '../../services/issue_service.dart';
import 'link_requests_screen.dart';
import 'analytics_screen.dart';
import 'products_screen.dart';
import 'orders_screen.dart';
import 'chat_supplier_screen.dart';
import 'complaints_screen.dart';
import '../profile_screen.dart';

class HomeSupplierScreen extends StatefulWidget {
  const HomeSupplierScreen({super.key});

  @override
  State<HomeSupplierScreen> createState() => _HomeSupplierScreenState();
}

class _HomeSupplierScreenState extends State<HomeSupplierScreen> {
  int _ordersToday = 0;
  int _pendingLinks = 0;
  int _openComplaints = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _loading = true);
    
    try {
      final app = context.read<AppState>();
      final linkService = LinkService(app.http);
      final orderService = OrderService(app.http);
      final issueService = IssueService(app.http);
      final userLogin = app.userLogin ?? '';
      
      // Load pending links
      final linksRes = await linkService.listLinks(userLogin);
      if (linksRes.ok && linksRes.data != null) {
        _pendingLinks = linksRes.data!
            .where((link) => link.linkStatus == 'pending')
            .length;
      }
      
      // Load orders
      final ordersRes = await orderService.listOrders(userLogin);
      if (ordersRes.ok && ordersRes.data != null) {
        final today = DateTime.now();
        _ordersToday = ordersRes.data!
            .where((order) {
              // TODO: Filter by today's date
              return true;
            })
            .length;
      }
      
      // Load complaints
      final issuesRes = await issueService.listIssues(userLogin);
      if (issuesRes.ok && issuesRes.data != null) {
        _openComplaints = issuesRes.data!
            .where((issue) => !issue.isResolved)
            .length;
      }
    } catch (e) {
      // Handle error
    }
    
    setState(() => _loading = false);
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfileScreen()),
                      ),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.shade100,
                        ),
                        child: const Icon(Icons.person, color: Colors.blue),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hello,',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8C6239),
                            ),
                          ),
                          const Text(
                            'Alex',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A3722),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, color: Color(0xFF4A3722)),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              // Summary Statistics
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard('Orders Today', '$_ordersToday', Colors.blue),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard('Pending Links', '$_pendingLinks', const Color(0xFF768C4A)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard('Complaints Open', '$_openComplaints', const Color(0xFFDBB86A)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Quick Shortcuts
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Shortcuts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A3722),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildShortcutItem(
                      icon: Icons.grid_view,
                      label: 'Catalog',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProductsScreen()),
                      ),
                    ),
                    _buildShortcutItem(
                      icon: Icons.receipt_long,
                      label: 'Orders',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OrdersScreen()),
                      ),
                    ),
                    _buildShortcutItem(
                      icon: Icons.chat_bubble_outline,
                      label: 'Chat',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ChatSupplierScreen()),
                      ),
                    ),
                    _buildShortcutItem(
                      icon: Icons.report_problem_outlined,
                      label: 'Complaints',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ComplaintsScreen()),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Additional Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildActionCard(
                        'Link Requests',
                        'Manage incoming requests',
                        Icons.link,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LinkRequestsScreen()),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionCard(
                        'Analytics',
                        'View revenue & stats',
                        Icons.analytics,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF8C6239),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF768C4A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A3722),
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF8C6239)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF768C4A), size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A3722),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF8C6239),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

