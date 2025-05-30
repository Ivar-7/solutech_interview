import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solutech_interview/models/visit.dart';
import 'package:solutech_interview/providers/visit_provider.dart';
import 'package:solutech_interview/providers/activity_provider.dart';
import 'package:solutech_interview/providers/customer_provider.dart'; // Add this import

class VisitFormScreen extends StatefulWidget {
  final Visit? visit;
  const VisitFormScreen({super.key, this.visit});

  @override
  State<VisitFormScreen> createState() => _VisitFormScreenState();
}

class _VisitFormScreenState extends State<VisitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _locationController;
  late TextEditingController _notesController;
  DateTime? _visitDate;
  String _status = 'Pending';
  List<int> _selectedActivities = [];
  bool _isSubmitting = false;
  int? _selectedCustomerId; // Add this variable

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController(text: widget.visit?.location ?? '');
    _notesController = TextEditingController(text: widget.visit?.notes ?? '');
    _visitDate = widget.visit?.visitDate ?? DateTime.now();
    _status = widget.visit?.status ?? 'Pending';
    _selectedActivities = widget.visit?.activitiesDone ?? [];
    _selectedCustomerId = widget.visit?.customerId; // Initialize with existing visit's customer ID

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ActivityProvider>(context, listen: false).loadActivities();
      Provider.of<CustomerProvider>(context, listen: false).loadCustomers(); // Load customers
    });
  }

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate customer is selected
    if (_selectedCustomerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a customer')),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    final provider = Provider.of<VisitProvider>(context, listen: false);
    try {
      final visit = Visit(
        id: widget.visit?.id ?? 0,
        customerId: _selectedCustomerId!,
        visitDate: _visitDate!,
        status: _status,
        location: _locationController.text.trim(),
        notes: _notesController.text.trim(),
        activitiesDone: _selectedActivities,
        createdAt: widget.visit?.createdAt ?? DateTime.now(),
      );
      if (widget.visit == null) {
        await provider.addVisit(visit);
      } else {
        await provider.updateVisit(visit);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      // Show user-friendly error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save visit. Please try again.')),
      );
      // Print debug info
      debugPrint('Error in VisitFormScreen _submit: $e');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activities = Provider.of<ActivityProvider>(context).activities;
    final customers = Provider.of<CustomerProvider>(context).customers;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.visit == null ? 'Add Visit' : 'Edit Visit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('Visit Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),

              // Add Customer Dropdown
              DropdownButtonFormField<int>(
                value: _selectedCustomerId,
                hint: const Text('Select Customer'),
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Customer',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: customers.map((customer) {
                  return DropdownMenuItem<int>(
                    value: customer.id,
                    child: Text(customer.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCustomerId = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a customer' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value == null || value.trim().isEmpty ? 'Location required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Notes',
                  prefixIcon: const Icon(Icons.notes),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                items: ['Pending', 'Completed', 'Cancelled']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setState(() => _status = val ?? 'Pending'),
                decoration: const InputDecoration(labelText: 'Status', prefixIcon: Icon(Icons.info_outline)),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Visit Date: ${_visitDate?.toLocal().toString().split(' ')[0]}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _visitDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _visitDate = picked);
                },
              ),
              const SizedBox(height: 24),
              const Text('Activities Completed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: activities.map((a) {
                  final selected = _selectedActivities.contains(a.id);
                  return FilterChip(
                    label: Text(a.description),
                    selected: selected,
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          _selectedActivities.add(a.id);
                        } else {
                          _selectedActivities.remove(a.id);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              _isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(widget.visit == null ? Icons.add : Icons.save),
                        onPressed: _submit,
                        label: Text(widget.visit == null ? 'Add Visit' : 'Update Visit'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
