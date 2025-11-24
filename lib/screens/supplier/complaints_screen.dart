import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app.dart';
import '../../services/issue_service.dart';
import '../../models/issue.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  String _selectedTab = 'Open';
  List<Issue> _openIssues = [];
  List<Issue> _inProgressIssues = [];
  List<Issue> _resolvedIssues = [];
  bool _loading = true;

  final List<String> _tabs = ['Open', 'In Progress', 'Resolved'];

  @override
  void initState() {
    super.initState();
    _loadComplaints();
  }

  Future<void> _loadComplaints() async {
    setState(() => _loading = true);
    
    try {
      final app = context.read<AppState>();
      final issueService = IssueService(app.http);
      final userLogin = app.userLogin ?? '';
      
      final res = await issueService.listIssues(userLogin);
      if (res.ok && res.data != null) {
        setState(() {
          _openIssues = res.data!.where((issue) => !issue.isResolved).toList();
          _inProgressIssues = []; // TODO: Filter in progress
          _resolvedIssues = res.data!.where((issue) => issue.isResolved).toList();
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  List<Issue> get _currentIssues {
    switch (_selectedTab) {
      case 'Open':
        return _openIssues;
      case 'In Progress':
        return _inProgressIssues;
      case 'Resolved':
        return _resolvedIssues;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Complaints',
          style: TextStyle(
            color: Color(0xFF4A3722),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _tabs.map((tab) {
                final isSelected = tab == _selectedTab;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = tab),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.grey.shade100 : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tab,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? const Color(0xFF768C4A) : Colors.grey,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Complaints list
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _currentIssues.isEmpty
                    ? const Center(child: Text('No complaints found'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _currentIssues.length,
                        itemBuilder: (context, index) {
                          final issue = _currentIssues[index];
                          return _buildComplaintCard(issue);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintCard(Issue issue) {
    final status = issue.isResolved ? 'Resolved' : 'New';
    final statusColor = issue.isResolved 
        ? const Color(0xFF768C4A) 
        : const Color(0xFFDBB86A);

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ID #C${issue.consumerLogin.substring(0, 5).toUpperCase()}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8C6239),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 10,
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            issue.issueTopic,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A3722),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            issue.consumerLogin,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF8C6239),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Today, 9:41 AM', // TODO: Get actual date
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF8C6239),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Escalate',
                  style: TextStyle(color: Color(0xFF4A3722)),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // TODO: Resolve complaint
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF768C4A),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Resolve'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

