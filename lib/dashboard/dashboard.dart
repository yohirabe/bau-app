import 'package:bau_app/dashboard/medical_control_button.dart';
import 'package:bau_app/services/patient_api_service.dart';
import 'package:bau_app/settings_screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:bau_app/dashboard/incident_dropdown_button.dart';
import 'package:bau_app/dashboard/patient_element.dart';
import 'package:bau_app/add_patient_screen/add_patient.dart';
import 'package:bau_app/models/patient.dart';
import 'package:bau_app/locator.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int? incident;
  late Future<List<Patient>> futurePatients;

  @override
  void initState() {
    super.initState();
    futurePatients = locator<ApiService>().fetchPatients();
  }

  @override
  Widget build(BuildContext context) {
    incident != null
        ? futurePatients =
            locator<ApiService>().fetchPatientsByIncident(incident!)
        : {};
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
        ),
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: IncidentDropdownButton(
              callback: (value) {
                setState(() {
                  incident = value;
                });
              },
            ),
          ),
          patientList(),
          Container(
            margin: const EdgeInsets.all(30),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20.0),
                  shape: const StadiumBorder()),
              onPressed: () async {
                final bool? shouldRefresh = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddPatientScreen()),
                );
                if (shouldRefresh ?? false) {
                  setState(() {});
                }
              },
              child: const Text(
                'Add New Patient',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          const MedicalControlButton(),
        ],
      ),
    );
  }

  FutureBuilder<List<Patient>> patientList() {
    return FutureBuilder(
      future: futurePatients,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Expanded(
            child: RefreshIndicator(
              onRefresh: () => Future.delayed(const Duration(seconds: 1), () {
                setState(() {});
              }),
              child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return PatientElement(
                      patient: snapshot.data![index],
                    );
                  }),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('$snapshot.error');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
