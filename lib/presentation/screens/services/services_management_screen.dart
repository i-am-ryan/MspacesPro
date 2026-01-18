import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ServicesManagementScreen extends StatefulWidget {
  const ServicesManagementScreen({super.key});

  @override
  State<ServicesManagementScreen> createState() => _ServicesManagementScreenState();
}

class _ServicesManagementScreenState extends State<ServicesManagementScreen> {
  final List<Map<String, dynamic>> _services = [
    {
      'id': 'srv_001',
      'name': 'Plumbing Repair',
      'category': 'Plumbing',
      'icon': Icons.plumbing,
      'hourlyRate': 450.0,
      'callOutFee': 150.0,
      'minimumCharge': 300.0,
      'isActive': true,
      'isPrimary': true,
    },
    {
      'id': 'srv_002',
      'name': 'Emergency Plumbing',
      'category': 'Plumbing',
      'icon': Icons.emergency,
      'hourlyRate': 900.0,
      'callOutFee': 300.0,
      'minimumCharge': 600.0,
      'isActive': true,
      'isPrimary': false,
    },
    {
      'id': 'srv_003',
      'name': 'Installation',
      'category': 'Plumbing',
      'icon': Icons.construction,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Services'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showServiceInfo();
            },
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
        onPressed: () {
          _showAddServiceDialog();
        },
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  primaryService['icon'],
                  size: 28,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'PRIMARY SERVICE',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      primaryService['name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildPriceInfo(
                  'Hourly Rate',
                  'R${primaryService['hourlyRate'].toStringAsFixed(0)}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPriceInfo(
                  'Call-out',
                  'R${primaryService['callOutFee'].toStringAsFixed(0)}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildPriceInfo(String label, String value) {
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
    final activeServices = _services.where((s) => s['isActive'] && !s['isPrimary']).toList();
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
                onPressed: () {
                  // TODO: Navigate to pricing management
                },
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Edit Prices'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...activeServices.map((service) => _buildServiceCard(service)).toList(),
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
            ...inactiveServices.map((service) => _buildServiceCard(service)).toList(),
          ],
        ],
      ),
    );
  }
  
  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: service['isActive'] ? Colors.grey[200]! : Colors.grey[300]!,
        ),
        boxShadow: [
          if (service['isActive'])
            const BoxShadow(
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: service['isActive'] ? Colors.black.withOpacity(0.05) : Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  service['icon'],
                  size: 24,
                  color: service['isActive'] ? Colors.black : Colors.grey,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: service['isActive'] ? Colors.black : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service['category'],
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: service['isActive'],
                onChanged: (value) {
                  setState(() {
                    service['isActive'] = value;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value ? 'Service activated' : 'Service deactivated',
                      ),
                      backgroundColor: value ? Colors.green : Colors.grey,
                    ),
                  );
                },
                activeColor: Colors.green,
              ),
            ],
          ),
          if (service['isActive']) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hourly Rate',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'R${service['hourlyRate'].toStringAsFixed(0)}/hr',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Call-out Fee',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'R${service['callOutFee'].toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Minimum',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'R${service['minimumCharge'].toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
                      _showEditServiceDialog(service);
                    },
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Edit'),
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
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showDeleteServiceDialog(service);
                    },
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
  
  void _showServiceInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Service Management'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Your primary service appears prominently to clients'),
            SizedBox(height: 8),
            Text('• Active services are visible in search results'),
            SizedBox(height: 8),
            Text('• Inactive services are hidden but can be reactivated'),
            SizedBox(height: 8),
            Text('• Update your pricing anytime'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
  
  void _showAddServiceDialog() {
    final nameController = TextEditingController();
    final hourlyRateController = TextEditingController();
    final callOutFeeController = TextEditingController();
    final minimumChargeController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Service'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Service Name',
                  hintText: 'e.g., Drain Cleaning',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: hourlyRateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Hourly Rate (R)',
                  hintText: '450',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: callOutFeeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Call-out Fee (R)',
                  hintText: '150',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: minimumChargeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Minimum Charge (R)',
                  hintText: '300',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  hourlyRateController.text.isNotEmpty) {
                setState(() {
                  _services.add({
                    'id': 'srv_new_${DateTime.now().millisecondsSinceEpoch}',
                    'name': nameController.text,
                    'category': 'Plumbing',
                    'icon': Icons.build,
                    'hourlyRate': double.parse(hourlyRateController.text),
                    'callOutFee': double.parse(callOutFeeController.text),
                    'minimumCharge': double.parse(minimumChargeController.text),
                    'isActive': true,
                    'isPrimary': false,
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Service added successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add Service'),
          ),
        ],
      ),
    );
    
    // Dispose controllers when dialog closes
    nameController.dispose();
    hourlyRateController.dispose();
    callOutFeeController.dispose();
    minimumChargeController.dispose();
  }
  
  void _showEditServiceDialog(Map<String, dynamic> service) {
    final nameController = TextEditingController(text: service['name']);
    final hourlyRateController = TextEditingController(text: service['hourlyRate'].toStringAsFixed(0));
    final callOutFeeController = TextEditingController(text: service['callOutFee'].toStringAsFixed(0));
    final minimumChargeController = TextEditingController(text: service['minimumCharge'].toStringAsFixed(0));
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Service'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Service Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: hourlyRateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Hourly Rate (R)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: callOutFeeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Call-out Fee (R)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: minimumChargeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Minimum Charge (R)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                service['name'] = nameController.text;
                service['hourlyRate'] = double.parse(hourlyRateController.text);
                service['callOutFee'] = double.parse(callOutFeeController.text);
                service['minimumCharge'] = double.parse(minimumChargeController.text);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Service updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
    
    // Dispose controllers when dialog closes
    nameController.dispose();
    hourlyRateController.dispose();
    callOutFeeController.dispose();
    minimumChargeController.dispose();
  }
  
  void _showDeleteServiceDialog(Map<String, dynamic> service) {
    if (service['isPrimary']) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cannot Delete'),
          content: const Text('You cannot delete your primary service. Please set another service as primary first.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Service'),
        content: Text('Are you sure you want to delete "${service['name']}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _services.removeWhere((s) => s['id'] == service['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Service deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}