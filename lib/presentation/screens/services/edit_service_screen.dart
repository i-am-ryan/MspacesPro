import 'package:flutter/material.dart';

class EditServiceScreen extends StatefulWidget {
  final Map<String, dynamic> service;

  const EditServiceScreen({
    super.key,
    required this.service,
  });

  @override
  State<EditServiceScreen> createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _durationCtrl;

  late String _category;
  late bool _emergencyAvailable;

  @override
  void initState() {
    super.initState();
    _category = (widget.service['category'] ?? 'Plumbing').toString();
    _emergencyAvailable = (widget.service['emergencyAvailable'] ?? true) as bool;

    _nameCtrl = TextEditingController(text: (widget.service['name'] ?? '').toString());
    _descCtrl = TextEditingController(text: (widget.service['description'] ?? '').toString());
    _priceCtrl = TextEditingController(text: (widget.service['price'] ?? '').toString());
    _durationCtrl = TextEditingController(text: (widget.service['duration'] ?? '').toString());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _durationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Service'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _deleteService,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildCard(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _dropdown(),
                  const SizedBox(height: 14),
                  _field(_nameCtrl, 'Service name'),
                  const SizedBox(height: 14),
                  _field(_descCtrl, 'Description', maxLines: 3),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: _field(_priceCtrl, 'Base price (R)', keyboard: TextInputType.number)),
                      const SizedBox(width: 12),
                      Expanded(child: _field(_durationCtrl, 'Duration (mins)', keyboard: TextInputType.number)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber, color: Colors.black),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text('Emergency available?', style: TextStyle(fontWeight: FontWeight.w800)),
                        ),
                        Switch(
                          value: _emergencyAvailable,
                          activeThumbColor: Colors.black,
                          onChanged: (v) => setState(() => _emergencyAvailable = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Update Service'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: const [
          BoxShadow(color: Color(0x0D000000), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }

  Widget _dropdown() {
    return DropdownButtonFormField<String>(
      value: _category,
      items: const [
        DropdownMenuItem(value: 'Plumbing', child: Text('Plumbing')),
        DropdownMenuItem(value: 'Electrical', child: Text('Electrical')),
        DropdownMenuItem(value: 'Painting', child: Text('Painting')),
        DropdownMenuItem(value: 'Appliance Repair', child: Text('Appliance Repair')),
        DropdownMenuItem(value: 'Other', child: Text('Other')),
      ],
      onChanged: (v) => setState(() => _category = v ?? 'Plumbing'),
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label, {
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboard,
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Required';
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    // TODO: Hook into backend/provider state
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Service updated'), backgroundColor: Colors.green),
    );

    Navigator.pop(context);
  }

  void _deleteService() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Service'),
        content: const Text('Are you sure you want to delete this service?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Service deleted'), backgroundColor: Colors.red),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
