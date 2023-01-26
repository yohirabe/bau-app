import 'package:flutter/material.dart';
import 'package:bau_app/models/patient.dart';

var statusColors = {
  1: Colors.red,
  2: Colors.yellow,
  3: Colors.lightGreen,
};

var _genderStrings = {0: "U", 1: "M", 2: "F", 9: "N/A"};

class PatientElement extends StatelessWidget {
  final Patient patient;

  const PatientElement({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    StringBuffer patientStringBuffer = StringBuffer();
    patientStringBuffer.write(
        '${patient.incident} - ${patient.estimatedAge} YO${_genderStrings[patient.gender]}');
    for (String condition in patient.conditions) {
      patientStringBuffer.write(" - $condition");
    }
    return Container(
      padding: const EdgeInsets.all(10),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[300],
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              'Status ${patient.status}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                backgroundColor: statusColors[patient.status],
              ),
            ),
            Text(patientStringBuffer.toString()),
          ],
        ),
      ),
    );
  }
}
