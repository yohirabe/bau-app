import 'package:bau_app/services/patient_api_service.dart';
import 'package:flutter/material.dart';
import 'package:bau_app/locator.dart';

class IncidentDropdownButton extends StatefulWidget {
  final ValueSetter<int> callback;
  final String? persistentHintText;

  const IncidentDropdownButton(
      {super.key, required this.callback, this.persistentHintText});

  @override
  State<IncidentDropdownButton> createState() => _IncidentDropdownButtonState();
}

class _IncidentDropdownButtonState extends State<IncidentDropdownButton> {
  int? dropdownValue;
  late Future<List<int>> futureIncidents;

  @override
  Widget build(BuildContext context) {
    futureIncidents = locator<ApiService>().fetchIncidents();
    return FutureBuilder(
        future: futureIncidents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<int> dropdownList = snapshot.data!.toList();

            return DropdownButton<int>(
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              hint: Text(
                  // If persistent hint text is not null, always show that no matter what is selected.
                  widget.persistentHintText ??
                      (dropdownValue ?? "Incident").toString()),
              onChanged: (int? value) {
                int selectedIncident = value!;
                setState(() {
                  dropdownValue = selectedIncident;
                });
                widget.callback(selectedIncident);
              },
              items: dropdownList.map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                    value: value, child: Text(value.toString()));
              }).toList(),
            );
          } else if (snapshot.hasError) {
            // Disabled
            return DropdownButton(
              items: null,
              onChanged: null,
              isExpanded: true,
            );
          }
          return const CircularProgressIndicator();
        });
  }
}
