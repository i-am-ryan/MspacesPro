import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _transactions = [
    {
      'id': 'TXN001234',
      'date': DateTime(2026, 1, 15, 14, 30),
      'clientName': 'Sarah Williams',
      'clientPhone': '+27 82 345 6789',
      'service': 'Kitchen Sink Repair',
      'jobId': 'JOB_001',
      'amount': 650.00,
      'status': 'Paid',
      'paymentMethod': 'Bank Transfer',
      'bankName': 'FNB',
      'accountNumber': '****5678',
      'reference': 'MSPACES-JOB001',
      'paidOutDate': DateTime(2026, 1, 17),
    },
    {
      'id': 'TXN001235',
      'date': DateTime(2026, 1, 14, 10, 15),
      'clientName': 'John Doe',
      'clientPhone': '+27 71 234 5678',
      'service': 'Bathroom Installation',
      'jobId': 'JOB_002',
      'amount': 1200.00,
      'status': 'Pending',
      'paymentMethod': 'Cash',
      'bankName': null,
      'accountNumber': null,
      'reference': 'MSPACES-JOB002',
      'paidOutDate': null,
    },
    {
      'id': 'TXN001236',
      'date': DateTime(2026, 1, 13, 16, 45),
      'clientName': 'Jane Smith',
      'clientPhone': '+27 83 456 7890',
      'service': 'Emergency Pipe Fix',
      'jobId': 'JOB_003',
      'amount': 850.00,
      'status': 'Paid Out',
      'paymentMethod': 'EFT',
      'bankName': 'Standard Bank',
      'accountNumber': '****1234',
      'reference': 'MSPACES-JOB003',
      'paidOutDate': DateTime(2026, 1, 15),
    },
    {
      'id': 'TXN001237',
      'date': DateTime(2026, 1, 12, 9, 20),
      'clientName': 'Mike Brown',
      'clientPhone': '+27 84 567 8901',
      'service': 'Geyser Installation',
      'jobId': 'JOB_004',
      'amount': 2500.00,
      'status': 'Paid Out',
      'paymentMethod': 'Bank Transfer',
      'bankName': 'Capitec',
      'accountNumber': '****9012',
      'reference': 'MSPACES-JOB004',
      'paidOutDate': DateTime(2026, 1, 14),
    },
  ];

  List<Map<String, dynamic>> get _filteredTransactions {
    if (_selectedFilter == 'All') return _transactions;
    return _transactions.where((t) => t['status'] == _selectedFilter).toList();
  }

  double get _totalAmount {
    return _filteredTransactions.fold(
      0.0,
      (sum, t) => sum + (t['amount'] as double),
    );
  }

  void _handleBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    // fallback if user navigated here using context.go (no stack)
    context.go('/provider-earnings');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,

        // ✅ FORCE BACK BUTTON
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleBack,
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryCard(),
          _buildFilterChips(),
          Expanded(
            child: _filteredTransactions.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _filteredTransactions.length,
                    itemBuilder: (context, index) {
                      return _buildTransactionCard(
                          _filteredTransactions[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.black, Colors.grey[900]!],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Amount',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'R ${_totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_filteredTransactions.length} transactions',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Paid', 'Pending', 'Paid Out'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
                backgroundColor: Colors.grey[100],
                selectedColor: Colors.black,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No ${_selectedFilter.toLowerCase()} transactions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try changing the filter.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final status = transaction['status'] as String;
    final amount = transaction['amount'] as double;
    final date = transaction['date'] as DateTime;

    Color statusColor;
    switch (status) {
      case 'Paid':
        statusColor = Colors.green;
        break;
      case 'Paid Out':
        statusColor = Colors.blue;
        break;
      case 'Pending':
      default:
        statusColor = Colors.orange;
    }

    return InkWell(
      onTap: () {
        context.push(
          '/transaction-details',
          extra: transaction,
        );
      },
      child: Container(
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
              height: 74,
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
                    transaction['service'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    transaction['clientName'],
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${date.day}/${date.month}/${date.year} • ${transaction['id']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'R ${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
