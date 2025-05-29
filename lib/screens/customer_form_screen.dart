import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solutech_interview/models/customer.dart';
import 'package:solutech_interview/providers/customer_provider.dart';

class CustomerFormScreen extends StatefulWidget {
  final Customer? customer;
  const CustomerFormScreen({super.key, this.customer});

  @override
  State<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    final provider = Provider.of<CustomerProvider>(context, listen: false);
    try {
      if (widget.customer == null) {
        await provider.addCustomer(_nameController.text.trim());
      } else {
        await provider.updateCustomer(widget.customer!.id, _nameController.text.trim());
      }
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer == null ? 'Add Customer' : 'Edit Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Customer Name'),
                validator: (value) => value == null || value.trim().isEmpty ? 'Name required' : null,
              ),
              const SizedBox(height: 24),
              _isSubmitting
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: Text(widget.customer == null ? 'Add' : 'Update'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
