import 'package:bau_app/services/patient_api_service.dart';
import 'package:flutter/material.dart';
import 'package:bau_app/locator.dart';

class IncidentDropdownButton extends StatefulWidget {
  final ValueSetter<String> callback;
  final String? persistentHintText;

  const IncidentDropdownButton(
      {super.key, required this.callback, this.persistentHintText});

  @override
  State<IncidentDropdownButton> createState() => _IncidentDropdownButtonState();
}

class _IncidentDropdownButtonState extends State<IncidentDropdownButton> {
  String? dropdownValue;
  late Future<List<String>> futureIncidents;

  @override
  Widget build(BuildContext context) {
    futureIncidents = locator<ApiService>().fetchIncidents();
    return FutureBuilder(
        future: futureIncidents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> dropdownList = snapshot.data!.toList();
            return DropdownButton<String>(
              isExpanded: true,
              //focusColor: Colors.grey,
              icon: const Icon(Icons.arrow_drop_down),
              hint: Text(
                  // If persistent hint text is not null, always show that no matter what is selected.
                  widget.persistentHintText ?? (dropdownValue ?? "Incident")),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                });
                widget.callback(value!);
              },
              items: dropdownList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
              }).toList(),
            );
          } else if (snapshot.hasError) {
            return Text('$snapshot.error');
          }
          return const CircularProgressIndicator();
        });
  }
}
