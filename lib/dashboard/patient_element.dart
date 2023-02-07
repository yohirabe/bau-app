import 'package:bau_app/services/patient_api_service.dart';
import 'package:flutter/material.dart';
import 'package:bau_app/models/patient.dart';
import 'package:bau_app/locator.dart';

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
    return InkWell(
      onLongPress: () {
        showDeleteDialogue(context, patient);
      },
      child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: const EdgeInsets.all(10),
            height: 90,
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
                  const Text(""),
                  Text(patientStringBuffer.toString()),
                ],
              ),
            ),
          )),
    );
  }
}

Future<void> showDeleteDialogue(context, Patient patient) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user does not have to tap button
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Delete Patient"),
        content: const Text("Are you sure you want to delete this patient?"),
        actions: [
          TextButton(
              onPressed: () {
                locator<ApiService>().deletePatient(patient.id!);
                Navigator.pop(context);
              },
              child: const Text("Yes")),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"))
        ],
      );
    },
  );
}
