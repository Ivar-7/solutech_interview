import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/activity.dart';
import '../../providers/activity_provider.dart';

class ActivityFormScreen extends StatefulWidget {
  final Activity? activity;
  const ActivityFormScreen({super.key, this.activity});

  @override
  State<ActivityFormScreen> createState() => _ActivityFormScreenState();
}

class _ActivityFormScreenState extends State<ActivityFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _descController = TextEditingController(text: widget.activity?.description ?? '');
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    final provider = Provider.of<ActivityProvider>(context, listen: false);
    try {
      if (widget.activity == null) {
        await provider.addActivity(_descController.text.trim());
      } else {
        await provider.updateActivity(widget.activity!.id, _descController.text.trim());
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
        title: Text(widget.activity == null ? 'Add Activity' : 'Edit Activity'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Activity Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.checklist),
                ),
                validator: (value) => value == null || value.trim().isEmpty ? 'Description required' : null,
              ),
              const SizedBox(height: 24),
              _isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(widget.activity == null ? Icons.add : Icons.save),
                        onPressed: _submit,
                        label: Text(widget.activity == null ? 'Add Activity' : 'Update Activity'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
