import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app.dart';
import '../../services/link_service.dart';
import '../../models/link.dart';

class LinkRequestsScreen extends StatefulWidget {
  const LinkRequestsScreen({super.key});

  @override
  State<LinkRequestsScreen> createState() => _LinkRequestsScreenState();
}

class _LinkRequestsScreenState extends State<LinkRequestsScreen> {
  String _selectedTab = 'Pending';
  List<Link> _pendingLinks = [];
  List<Link> _historyLinks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLinks();
  }

  Future<void> _loadLinks() async {
    setState(() => _loading = true);
    
    try {
      final app = context.read<AppState>();
      final linkService = LinkService(app.http);
      final userLogin = app.userLogin ?? '';
      
      final res = await linkService.listLinks(userLogin);
      if (res.ok && res.data != null) {
        setState(() {
          _pendingLinks = res.data!.where((link) => link.linkStatus == 'pending').toList();
          _historyLinks = res.data!.where((link) => link.linkStatus != 'pending').toList();
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _approveLink(String consumerLogin) async {
    // TODO: Implement approve link API call
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link approved')),
    );
    _loadLinks();
  }

  Future<void> _rejectLink(String consumerLogin) async {
    // TODO: Implement reject link API call
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link rejected')),
    );
    _loadLinks();
  }

  @override
  Widget build(BuildContext context) {
    final currentLinks = _selectedTab == 'Pending' ? _pendingLinks : _historyLinks;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A3722)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Link Requests',
              style: TextStyle(
                color: Color(0xFF4A3722),
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF8C6239),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_pendingLinks.length}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: _buildTab('Pending (${_pendingLinks.length})', _selectedTab == 'Pending'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTab('History', _selectedTab == 'History'),
                ),
              ],
            ),
          ),
          // Links list
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : currentLinks.isEmpty
                    ? const Center(child: Text('No links found'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: currentLinks.length,
                        itemBuilder: (context, index) {
                          final link = currentLinks[index];
                          return _buildLinkCard(link);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = label.split(' ')[0]),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: Colors.grey.shade300) : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? const Color(0xFF768C4A) : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildLinkCard(Link link) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFDBB86A),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    link.consumerLogin[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      link.consumerLogin,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A3722),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Business Type',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8C6239),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8C6239),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Received: ${DateTime.now().toString().split(' ')[0]}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8C6239),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_selectedTab == 'Pending') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _rejectLink(link.consumerLogin),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _approveLink(link.consumerLogin),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF768C4A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Approve'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

