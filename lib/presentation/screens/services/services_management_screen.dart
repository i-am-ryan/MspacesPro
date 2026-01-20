import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ServicesManagementScreen extends StatefulWidget {
  const ServicesManagementScreen({super.key});

  @override
  State<ServicesManagementScreen> createState() =>
      _ServicesManagementScreenState();
}

class _ServicesManagementScreenState extends State<ServicesManagementScreen> {
  final List<Map<String, dynamic>> _services = [
    {
      'id': 'srv_001',
      'name': 'Plumbing Repair',
      'category': 'Plumbing',
      'icon': Icons.plumbing,
      'hourlyRate': 450.0,
      'callOutFee': 180.0,
      'minimumCharge': 350.0,
      'isActive': true,
      'isPrimary': true,
    },
    {
      'id': 'srv_002',
      'name': 'Electrical Repair',
      'category': 'Electrical',
      'icon': Icons.electrical_services,
      'hourlyRate': 500.0,
      'callOutFee': 200.0,
      'minimumCharge': 400.0,
      'isActive': true,
      'isPrimary': false,
    },
    {
      'id': 'srv_003',
      'name': 'Geyser Installation',
      'category': 'Plumbing',
      'icon': Icons.water_drop,
      'hourlyRate': 550.0,
      'callOutFee': 200.0,
      'minimumCharge': 400.0,
      'isActive': true,
      'isPrimary': false,
    },
    {
      'id': 'srv_004',
      'name': 'Pipe Repair',
      'category': 'Plumbing',
      'icon': Icons.build,
      'hourlyRate': 400.0,
      'callOutFee': 150.0,
      'minimumCharge': 300.0,
      'isActive': false,
      'isPrimary': false,
    },
  ];

  void _handleBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    // fallback if user navigated here using context.go (no stack)
    context.go('/provider-dashboard');
  }

  void _openAddService() {
    context.push('/add-service');
  }

  void _openEditService(Map<String, dynamic> service) {
    context.push('/edit-service', extra: service);
  }

  void _openEditPricesPicker() {
    final candidates =
        _services.where((s) => (s['isActive'] == true)).toList();

    if (candidates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No active services to edit.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 46,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Icon(Icons.edit, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Select a service to edit prices',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...candidates.map((s) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      foregroundColor: Colors.black,
                      child: Icon(s['icon'] as IconData),
                    ),
                    title: Text(
                      s['name'],
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      'Hourly: R ${s['hourlyRate'].toStringAsFixed(0)} • Call-out: R ${s['callOutFee'].toStringAsFixed(0)}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.pop(ctx);
                      _openEditService(s);
                    },
                  );
                }),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showServiceInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('My Services'),
        content: const Text(
          'Manage your services, set pricing, and toggle availability. '
          'Customers will only see active services on your profile.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Services'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,

        // ✅ FORCE BACK BUTTON
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleBack,
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showServiceInfo,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPrimaryServiceCard(),
            const SizedBox(height: 24),
            _buildServicesList(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        // ✅ OPEN REAL SCREEN
        onPressed: _openAddService,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Service'),
      ),
    );
  }

  Widget _buildPrimaryServiceCard() {
    final primaryService = _services.firstWhere((s) => s['isPrimary']);

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black,
            Color(0xFF424242),
          ],
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  primaryService['icon'],
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Primary Service',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      primaryService['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'ACTIVE',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPriceMini('Hourly', 'R ${primaryService['hourlyRate'].toStringAsFixed(0)}'),
              _buildPriceMini('Call-out', 'R ${primaryService['callOutFee'].toStringAsFixed(0)}'),
              _buildPriceMini('Minimum', 'R ${primaryService['minimumCharge'].toStringAsFixed(0)}'),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton.icon(
              // ✅ OPEN REAL EDIT SCREEN
              onPressed: () => _openEditService(primaryService),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withOpacity(0.18)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.edit, size: 18),
              label: const Text(
                'Edit Primary Service',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPriceMini(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildServicesList() {
    final activeServices =
        _services.where((s) => s['isActive'] && !s['isPrimary']).toList();
    final inactiveServices = _services.where((s) => !s['isActive']).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Active Services',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextButton.icon(
                // ✅ OPEN PRICES EDIT FLOW
                onPressed: _openEditPricesPicker,
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Edit Prices'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...activeServices.map((service) => _buildServiceCard(service)),
          if (inactiveServices.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Text(
              'Inactive Services',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            ...inactiveServices.map((service) => _buildServiceCard(service)),
          ],
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    final isActive = service['isActive'] as bool;

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
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[100],
                foregroundColor: Colors.black,
                child: Icon(service['icon'] as IconData),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['name'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      service['category'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isActive,
                onChanged: (v) {
                  setState(() {
                    service['isActive'] = v;
                  });
                },
                activeColor: Colors.black,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildPricePill(
                    'Hourly', 'R ${service['hourlyRate'].toStringAsFixed(0)}'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPricePill(
                    'Call-out', 'R ${service['callOutFee'].toStringAsFixed(0)}'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPricePill(
                    'Minimum', 'R ${service['minimumCharge'].toStringAsFixed(0)}'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  // ✅ OPEN REAL EDIT SCREEN
                  onPressed: () => _openEditService(service),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text(
                    'Edit',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isActive
                              ? 'Service is active'
                              : 'Service is inactive',
                        ),
                        backgroundColor: isActive ? Colors.green : Colors.orange,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.visibility, size: 18),
                  label: const Text(
                    'Preview',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPricePill(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
