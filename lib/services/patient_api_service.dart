import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/patient.dart';

class ApiService {
  // TODO: Catch thrown exceptions wherever calls to these methods are made.
  // TODO: URIs will have to be changed when the API is set up properly, as this
  // currently just points to localhost on the emulator.
  // Maybe get this from Config file.
  Future<List<Patient>> fetchPatients() async {
    final response =
        await http.get(Uri.parse('https://10.0.2.2:7216/api/patients'));

    if (response.statusCode == 200) {
      List<Patient> patients = [];
      for (var element in jsonDecode(response.body)) {
        patients.add(Patient.fromJson(element));
      }
      return patients.reversed.toList();
    } else {
      throw Exception("Failed to load patients.");
    }
  }

  Future<List<int>> fetchIncidents() async {
    final response = await http
        .get(Uri.parse('https://10.0.2.2:7216/api/patients/incidents'));

    if (response.statusCode == 200) {
      List<int> incidents = [];
      for (var element in jsonDecode(response.body)) {
        incidents.add(element);
      }
      return incidents.reversed.toList();
    } else {
      throw Exception("Failed to load incidents.");
    }
  }

  Future<List<Patient>> fetchPatientsByIncident(int incident) async {
    final response = await http.get(Uri.parse(
        'https://10.0.2.2:7216/api/patients/search?incident=$incident'));

    if (response.statusCode == 200) {
      List<Patient> patients = [];
      for (var element in jsonDecode(response.body)) {
        patients.add(Patient.fromJson(element));
      }
      return patients.reversed.toList();
    } else {
      throw Exception("Failed to load patients.");
    }
  }

  Future<Patient> createPatient(PatientForCreationDto patient) async {
    final response = await http.post(
        Uri.parse('https://10.0.2.2:7216/api/patients'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: json.encode(patient.toJson()));
    if (response.statusCode == 201) {
      // 201 Created response parse json.
      return Patient.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to create patient.");
    }
  }

  Future<bool> deletePatient(int id) async {
    final response =
        await http.delete(Uri.parse('https://10.0.2.2:7216/api/patients/$id'));
    if (response.statusCode == 204) {
      // No content
      return true;
    } else {
      throw Exception("Failed to delete patient.");
    }
  }
}
