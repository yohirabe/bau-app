class Patient {
  // Patients created by the app have a null id, for this is assigned by the API.
  final String? id;
  final String incident;
  final int gender;
  final int estimatedAge;
  final int status;
  final List<String> conditions;

  Patient(
      {required this.id,
      required this.incident,
      required this.gender,
      required this.estimatedAge,
      required this.status,
      required this.conditions});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    json['id'] = id;
    json['incident'] = incident;
    json['status'] = status;
    json['age'] = estimatedAge;
    json['gender'] = gender;
    json['conditions'] = conditions;

    return json;
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    List<String> conditions = [];
    for (String element in json['conditions'] ?? []) {
      conditions.add(element);
    }
    return Patient(
      id: json['id'],
      incident: json['incident'],
      status: json['status'],
      estimatedAge: json['age'],
      gender: json['gender'],
      conditions: conditions,
    );
  }
}
