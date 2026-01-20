import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ActiveJobsScreen extends StatefulWidget {
  const ActiveJobsScreen({super.key});

  @override
  State<ActiveJobsScreen> createState() => _ActiveJobsScreenState();
}

class _ActiveJobsScreenState extends State<ActiveJobsScreen> {
  String _selectedFilter = 'Today';
  bool _isGridView = false;
  
  final List<Map<String, dynamic>> _allJobs = [
    {
      'id': 'job_001',
      'clientName': 'Sarah Williams',
      'clientPhone': '+27 82 345 6789',
      'clientAvatar': Icons.person,
      'service': 'Kitchen Sink Repair',
      'description': 'The kitchen sink is leaking from the pipe underneath. Water is dripping constantly and needs urgent attention.',
      'date': DateTime.now(),
      'time': '10:00 AM',
      'location': 'Rosebank',
      'fullAddress': '45 Bath Avenue, Rosebank, Johannesburg, 2196',
      'distance': '2.3 km',
      'status': 'Scheduled',
      'amount': 650.00,
    },
    {
      'id': 'job_002',
      'clientName': 'Mike Brown',
      'clientPhone': '+27 71 234 5678',
      'clientAvatar': Icons.person,
      'service': 'Bathroom Plumbing',
      'description': 'Need complete bathroom plumbing installation including toilet, sink, and shower fixtures.',
      'date': DateTime.now(),
      'time': '02:00 PM',
      'location': 'Sandton',
      'fullAddress': '12 Rivonia Road, Sandton, Johannesburg, 2196',
      'distance': '3.5 km',
      'status': 'In Progress',
      'amount': 1200.00,
    },
    {
      'id': 'job_003',
      'clientName': 'Jane Smith',
      'clientPhone': '+27 83 456 7890',
      'clientAvatar': Icons.person,
      'service': 'Emergency Pipe Burst',
      'description': 'Main water pipe has burst in the garden. Water is flooding the yard and needs immediate repair.',
      'date': DateTime.now(),
      'time': '04:30 PM',
      'location': 'Hyde Park',
      'fullAddress': '78 Jan Smuts Avenue, Hyde Park, Johannesburg, 2196',
      'distance': '4.1 km',
      'status': 'Scheduled',
      'amount': 850.00,
    },
    {
      'id': 'job_004',
      'clientName': 'David Lee',
      'clientPhone': '+27 84 567 8901',
      'clientAvatar': Icons.person,
      'service': 'Tap Replacement',
      'description': 'Replace old kitchen and bathroom taps with modern mixer taps.',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'time': '11:00 AM',
      'location': 'Bryanston',
      'fullAddress': '23 Culross Road, Bryanston, Johannesburg, 2021',
      'distance': '5.8 km',
      'status': 'Completed',
      'amount': 480.00,
    },
    {
      'id': 'job_005',
      'clientName': 'Emma Wilson',
      'clientPhone': '+27 72 678 9012',
      'clientAvatar': Icons.person,
      'service': 'Geyser Installation',
      'description': 'Install new 150L geyser in the garage. Old geyser is leaking and needs replacement.',
      'date': DateTime.now().add(const Duration(days: 1)),
      'time': '09:00 AM',
      'location': 'Fourways',
      'fullAddress': '56 William Nicol Drive, Fourways, Johannesburg, 2191',
      'distance': '7.2 km',
      'status': 'Scheduled',
      'amount': 2500.00,
    },
    {
      'id': 'job_006',
      'clientName': 'Peter Johnson',
      'clientPhone': '+27 81 789 0123',
      'clientAvatar': Icons.person,
      'service': 'Drain Cleaning',
      'description': 'Main drain is blocked and causing water backup in the house.',
      'date': DateTime.now().add(const Duration(days: 2)),
      'time': '01:00 PM',
      'location': 'Melrose',
      'fullAddress': '34 Corlett Drive, Melrose, Johannesburg, 2196',
      'distance': '3.9 km',
      'status': 'Scheduled',
      'amount': 350.00,
    },
  ];

  List<Map<String, dynamic>> get _filteredJobs {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    switch (_selectedFilter) {
      case 'Today':
        return _allJobs.where((job) {
          final jobDate = job['date'] as DateTime;
          final jobDay = DateTime(jobDate.year, jobDate.month, jobDate.day);
          return jobDay.isAtSameMomentAs(today);
        }).toList();
      
      case 'This Week':
        return _allJobs.where((job) {
          final jobDate = job['date'] as DateTime;
          return jobDate.isAfter(weekStart.subtract(const Duration(days: 1))) &&
                 jobDate.isBefore(weekEnd.add(const Duration(days: 1)));
        }).toList();
      
      case 'All':
      default:
        return _allJobs;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Active Jobs'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          _buildJobCount(),
          Expanded(
            child: _filteredJobs.isEmpty
                ? _buildEmptyState()
                : (_isGridView ? _buildGridView() : _buildListView()),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        children: [
          _buildFilterChip('All'),
          const SizedBox(width: 8),
          _buildFilterChip('Today'),
          const SizedBox(width: 8),
          _buildFilterChip('This Week'),
        ],
      ),
    );
  }
  
  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
  
  Widget _buildJobCount() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      alignment: Alignment.centerLeft,
      child: Text(
        '${_filteredJobs.length} ${_filteredJobs.length == 1 ? 'job' : 'jobs'}',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No jobs for $_selectedFilter',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Jobs will appear here when available',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _filteredJobs.length,
      itemBuilder: (context, index) {
        return _buildJobCard(_filteredJobs[index]);
      },
    );
  }
  
  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _filteredJobs.length,
      itemBuilder: (context, index) {
        return _buildGridJobCard(_filteredJobs[index]);
      },
    );
  }
  
  Widget _buildJobCard(Map<String, dynamic> job) {
    final statusColor = _getStatusColor(job['status']);
    final jobDate = job['date'] as DateTime;
    final formattedDate = '${jobDate.day} ${_getMonthName(jobDate.month)}';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Icon(job['clientAvatar'], size: 25),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job['clientName'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job['service'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  job['status'],
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                '$formattedDate • ${job['time']}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                '${job['location']} • ${job['distance']}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.attach_money, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                'R ${job['amount'].toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showCallDialog(context, job);
                  },
                  icon: const Icon(Icons.phone, size: 18),
                  label: const Text('Call'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push('/job-details', extra: job);
                  },
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text('Details'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildGridJobCard(Map<String, dynamic> job) {
    final statusColor = _getStatusColor(job['status']);
    final jobDate = job['date'] as DateTime;
    final formattedDate = '${jobDate.day} ${_getMonthName(jobDate.month)}';
    
    return InkWell(
      onTap: () {
        context.push('/job-details', extra: job);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(job['clientAvatar'], size: 20),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    job['status'],
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              job['clientName'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              job['service'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    formattedDate,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    job['location'],
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'R ${job['amount'].toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Scheduled':
        return Colors.blue;
      case 'In Progress':
        return Colors.orange;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
  
  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
  
  void _showCallDialog(BuildContext context, Map<String, dynamic> job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Call ${job['clientName']}?'),
        content: Text(job['clientPhone']),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement actual phone call
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calling ${job['clientPhone']}...'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }
}