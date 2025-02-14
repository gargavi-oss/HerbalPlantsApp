import 'package:flutter/material.dart';

class ContributeScreen extends StatefulWidget {
  const ContributeScreen({Key? key}) : super(key: key);

  @override
  _ContributeScreenState createState() => _ContributeScreenState();
}

class _ContributeScreenState extends State<ContributeScreen> {
  final _formKey = GlobalKey<FormState>();
  String _plantName = '';
  String _scientificName = '';
  String _benefits = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contribute a Plant'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Plant Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the plant name';
                }
                return null;
              },
              onSaved: (value) => _plantName = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Scientific Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the scientific name';
                }
                return null;
              },
              onSaved: (value) => _scientificName = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Benefits'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the benefits';
                }
                return null;
              },
              onSaved: (value) => _benefits = value!,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: Implement submission to backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plant submitted for review')),
      );
      Navigator.pop(context);
    }
  }
}

