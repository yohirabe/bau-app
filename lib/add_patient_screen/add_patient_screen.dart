import 'package:flutter/material.dart';
import 'add_patient_form.dart';

class AddPatientScreen extends StatefulWidget {
  final Function refreshDashboard;
  const AddPatientScreen({super.key, required this.refreshDashboard});

  @override
  State<AddPatientScreen> createState() => AddPatientScreenState();
}

class AddPatientScreenState extends State<AddPatientScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: const Text('Add New Patient'),
      ),
      body: AddPatientForm(
        refreshDashboard: widget.refreshDashboard,
      ),
    );
  }
}
