import 'dart:async';
import 'package:bau_app/dashboard/medical_control_button.dart';
import 'package:bau_app/dashboard/patient_element.dart';
import 'package:flutter/material.dart';
import 'package:bau_app/dashboard/incident_dropdown_button.dart';
import 'package:bau_app/locator.dart';
import 'package:bau_app/add_patient_screen/guided_triage/guided_triage.dart';
import 'package:bau_app/models/patient.dart';
import 'package:bau_app/services/validator_extension_methods.dart';
import '../services/patient_api_service.dart';

class GuidedTriageResult {
  final int status;
  final List<String> conditions;
  GuidedTriageResult(this.status, this.conditions);
}

class AddPatientForm extends StatefulWidget {
  const AddPatientForm({super.key});
  @override
  State<AddPatientForm> createState() => _AddPatientFormState();
}

class _AddPatientFormState extends State<AddPatientForm> {
  final _formKey = GlobalKey<FormState>();
  int? _estimatedAge;
  int? _incident;
  final _incidentText = TextEditingController();
  String? _selectedGender;
  final _genderCodes = {"Male": 1, "Female": 2, "Unknown": 0};
  int? _status;
  final _statusText = TextEditingController();
  List<String>? _conditions;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: <Widget>[
        incidentFormFields(),
        genderFormField(),
        ageFormField(),
        statusFormField(context),
        // Guided-Triage button
        ElevatedButton(
          onPressed: () async {
            GuidedTriageResult? result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const GuidedTriageScreen()));
            // result will be null when exiting without completing GT
            if (result != null) {
              _conditions = List.from(result.conditions);
              setState(() {
                _statusText.text = "Status ${result.status}";
                _status = result.status;
              });
            }
          },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(20),
              textStyle: const TextStyle(fontSize: 24),
              shape: const StadiumBorder()),
          child: const Text('GUIDED TRIAGE'),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    shape: const StadiumBorder()),
                onPressed: () {
                  // Validate returns true if the form is valid, false otherwise.
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    PatientForCreationDto patient = PatientForCreationDto(
                        incident: _incident!,
                        gender: _genderCodes[_selectedGender]!,
                        estimatedAge: _estimatedAge!,
                        status: _status!,
                        conditions: _conditions!);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Uploading Patient')),
                    );

                    Future<Patient> futurePatient =
                        locator<ApiService>().createPatient(patient);
                    // TODO: display confirmation that patient was created based on response
                    // TODO: Make refresh on exit consistent
                    // Pop with the additonal argument true, so that the dashboard knows
                    // to refresh its widgets
                    Navigator.pop(context, true);
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ),
        ),
        const MedicalControlButton(),
      ]),
    );
  }

  TextFormField statusFormField(BuildContext context) {
    return TextFormField(
      controller: _statusText,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        errorStyle: TextStyle(
          color: Theme.of(context).errorColor, // or any other color
        ),
      ),
      style: TextStyle(
        backgroundColor: statusColors[_status ?? 3],
        color: Colors.white,
        fontSize: 30,
      ),
      enabled: false,
      onSaved: ((value) {}),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Complete the guided-triage';
        }
        return null;
      },
    );
  }

  TextFormField ageFormField() {
    return TextFormField(
      onSaved: (newValue) => _estimatedAge = int.parse(newValue!),
      validator: (value) {
        if (value == "") return "Enter an estimated age";
        if (value == null || !value.isDigits) {
          return 'Age must be digits only';
        }
        return null;
      },
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(labelText: 'Estimated Age'),
    );
  }

  DropdownButtonFormField<String> genderFormField() {
    return DropdownButtonFormField<String>(
      hint: const Text('Gender'),
      onSaved: (newValue) {
        _selectedGender = newValue;
      },
      items: _genderCodes.keys.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: ((value) {
        _selectedGender = value;
      }),
      validator: (value) {
        if (value == null) {
          return "Select a gender";
        }
        return null;
      },
    );
  }

  Row incidentFormFields() {
    return Row(children: <Widget>[
      Expanded(
        child: TextFormField(
          controller: _incidentText,
          onSaved: (newValue) => _incident = int.parse(newValue!),
          validator: (value) {
            if (value == null || value.isEmpty || !value.isDigits) {
              return 'Enter an incident number';
            }
            return null;
          },
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Incident'),
        ),
      ),
      Expanded(
        child: IncidentDropdownButton(
          persistentHintText: "Select an incident",
          callback: ((value) {
            _incident = value;
            _incidentText.text = value.toString();
          }),
        ),
      )
    ]);
  }
}
