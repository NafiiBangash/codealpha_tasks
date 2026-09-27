import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/activity.dart';

/// Manual entry form for logging a workout / activity.
/// Pops with `true` when a save succeeds, so the dashboard knows to refresh.
class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();

  ActivityType _type = ActivityType.running;
  DateTime _date = DateTime.now();
  final _durationController = TextEditingController(text: '30');
  final _caloriesController = TextEditingController(text: '200');
  final _stepsController = TextEditingController(text: '0');
  final _notesController = TextEditingController();

  bool _saving = false;

  @override
  void dispose() {
    _durationController.dispose();
    _caloriesController.dispose();
    _stepsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _date = DateTime(
            picked.year, picked.month, picked.day, _date.hour, _date.minute);
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final activity = Activity(
      type: _type,
      date: _date,
      durationMinutes: int.parse(_durationController.text),
      caloriesBurned: int.parse(_caloriesController.text),
      steps: int.tryParse(_stepsController.text) ?? 0,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    await DatabaseHelper.instance.insertActivity(activity);

    if (mounted) Navigator.of(context).pop(true);
  }

  String? _requiredNumber(String? value, {bool allowZero = false}) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final n = int.tryParse(value);
    if (n == null) return 'Enter a whole number';
    if (!allowZero && n <= 0) return 'Must be greater than 0';
    if (n < 0) return 'Must be 0 or more';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Activity')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Activity type',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ActivityType.values.map((type) {
                final selected = type == _type;
                return ChoiceChip(
                  label: Text(type.label),
                  selected: selected,
                  onSelected: (_) => setState(() => _type = type),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date'),
              subtitle: Text(
                  '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Duration (minutes)',
                border: OutlineInputBorder(),
              ),
              validator: _requiredNumber,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _caloriesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Calories burned',
                border: OutlineInputBorder(),
              ),
              validator: _requiredNumber,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _stepsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Steps (optional)',
                border: OutlineInputBorder(),
              ),
              validator: (v) => _requiredNumber(v, allowZero: true),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Save Activity'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
