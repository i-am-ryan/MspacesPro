import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProviderCalendarScreen extends StatefulWidget {
  const ProviderCalendarScreen({super.key});

  @override
  State<ProviderCalendarScreen> createState() => _ProviderCalendarScreenState();
}

class _ProviderCalendarScreenState extends State<ProviderCalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  String _viewMode = 'Month'; // Month, Week, Day
  
  final Map<DateTime, List<Map<String, dynamic>>> _schedule = {
    DateTime(2026, 1, 17): [
      {
        'time': '10:00 AM',
        'clientName': 'Sarah Williams',
        'service': 'Kitchen Sink Repair',
        'location': 'Rosebank',
        'status': 'Upcoming',
      },
      {
        'time': '02:00 PM',
        'clientName': 'Mike Brown',
        'service': 'Bathroom Plumbing',
        'location': 'Sandton',
        'status': 'In Progress',
      },
      {
        'time': '04:30 PM',
        'clientName': 'Jane Smith',
        'service': 'Emergency Fix',
        'location': 'Hyde Park',
        'status': 'Upcoming',
      },
    ],
    DateTime(2026, 1, 18): [
      {
        'time': '09:00 AM',
        'clientName': 'Tom Brown',
        'service': 'Toilet Repair',
        'location': 'Johannesburg CBD',
        'status': 'Upcoming',
      },
      {
        'time': '11:30 AM',
        'clientName': 'Lisa Green',
        'service': 'Pipe Installation',
        'location': 'Midrand',
        'status': 'Upcoming',
      },
    ],
    DateTime(2026, 1, 20): [
      {
        'time': '10:00 AM',
        'clientName': 'John Doe',
        'service': 'Water Heater Service',
        'location': 'Pretoria',
        'status': 'Upcoming',
      },
    ],
  };

  List<Map<String, dynamic>> get _selectedDateJobs {
    final dateKey = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    return _schedule[dateKey] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Calendar'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'add_block') {
                _showAddBlockTimeDialog();
              } else if (value == 'availability') {
                // TODO: Navigate to availability settings
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'add_block',
                child: Row(
                  children: [
                    Icon(Icons.block, color: Colors.black),
                    SizedBox(width: 12),
                    Text('Add Block Time'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'availability',
                child: Row(
                  children: [
                    Icon(Icons.settings, color: Colors.black),
                    SizedBox(width: 12),
                    Text('Availability Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildViewModeSelector(),
          _buildCalendar(),
          _buildLegend(),
          Expanded(
            child: _buildJobsList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildViewModeSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _buildViewModeChip('Month'),
          const SizedBox(width: 8),
          _buildViewModeChip('Week'),
          const SizedBox(width: 8),
          _buildViewModeChip('Day'),
          const Spacer(),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedDate = DateTime.now();
              });
            },
            icon: const Icon(Icons.today),
            style: IconButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildViewModeChip(String mode) {
    final isSelected = _viewMode == mode;
    return InkWell(
      onTap: () {
        setState(() {
          _viewMode = mode;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          mode,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
  
  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime(
                      _selectedDate.year,
                      _selectedDate.month - 1,
                      _selectedDate.day,
                    );
                  });
                },
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                '${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime(
                      _selectedDate.year,
                      _selectedDate.month + 1,
                      _selectedDate.day,
                    );
                  });
                },
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCalendarGrid(),
        ],
      ),
    );
  }
  
  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final lastDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday;
    
    return Column(
      children: [
        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
              .map((day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 12),
        // Calendar days
        ...List.generate(6, (weekIndex) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (dayIndex) {
                final dayNumber = weekIndex * 7 + dayIndex + 1 - (firstWeekday - 1);
                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return const Expanded(child: SizedBox());
                }
                
                final date = DateTime(_selectedDate.year, _selectedDate.month, dayNumber);
                final hasJobs = _schedule.containsKey(date);
                final isSelected = date.day == _selectedDate.day &&
                    date.month == _selectedDate.month &&
                    date.year == _selectedDate.year;
                final isToday = date.day == DateTime.now().day &&
                    date.month == DateTime.now().month &&
                    date.year == DateTime.now().year;
                
                return Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black
                            : (isToday ? Colors.blue[50] : null),
                        borderRadius: BorderRadius.circular(8),
                        border: isToday && !isSelected
                            ? Border.all(color: Colors.blue, width: 2)
                            : null,
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              '$dayNumber',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : (isToday ? Colors.blue : Colors.black),
                              ),
                            ),
                          ),
                          if (hasJobs && !isSelected)
                            Positioned(
                              bottom: 4,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ],
    );
  }
  
  Widget _buildLegend() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLegendItem('Scheduled', Colors.blue),
          _buildLegendItem('Available', Colors.green),
          _buildLegendItem('Blocked', Colors.red),
        ],
      ),
    );
  }
  
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
  
  Widget _buildJobsList() {
    if (_selectedDateJobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_available, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'No jobs scheduled',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You have a free day!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Text(
            '${_selectedDateJobs.length} jobs on ${_selectedDate.day} ${_getMonthName(_selectedDate.month)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _selectedDateJobs.length,
            itemBuilder: (context, index) {
              return _buildJobCard(_selectedDateJobs[index]);
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildJobCard(Map<String, dynamic> job) {
    final statusColor = job['status'] == 'Upcoming' ? Colors.blue : Colors.orange;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 80,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job['time'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  job['service'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${job['clientName']} • ${job['location']}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              job['status'],
              style: TextStyle(
                color: statusColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showAddBlockTimeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Block Time'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Reason',
                hintText: 'e.g., Personal appointment',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Date and time pickers would go here
            const Text('Date and time selection coming soon'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Block time added'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
  
  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}