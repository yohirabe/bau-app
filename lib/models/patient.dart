class Patient {
  final int id;
  final int incident;
  final int gender;
  final int estimatedAge;
  final int status;
  final List<String> conditions;
  final DateTime created;

  Patient(
      {required this.id,
      required this.incident,
      required this.gender,
      required this.estimatedAge,
      required this.status,
      required this.conditions,
      required this.created});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    json['id'] = id;
    json['incident'] = incident;
    json['status'] = status;
    json['estimatedAge'] = estimatedAge;
    json['gender'] = gender;
    json['conditions'] = conditions;
    json['created'] = created;

    return json;
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      incident: json['incident'],
      status: json['status'],
      estimatedAge: json['estimatedAge'],
      gender: json['gender'],
      conditions: json['conditions'].split(','),
      created: DateTime.tryParse(json['created'])!,
    );
  }
}

class PatientForCreationDto {
  final int incident;
  final int gender;
  final int estimatedAge;
  final int status;
  final List<String> conditions;

  PatientForCreationDto(
      {required this.incident,
      required this.gender,
      required this.estimatedAge,
      required this.status,
      required this.conditions});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    json['incident'] = incident;
    json['status'] = status;
    json['estimatedAge'] = estimatedAge;
    json['gender'] = gender;
    var conditionsBuffer = StringBuffer();
    conditionsBuffer.writeAll(conditions, ",");
    json['conditions'] = conditionsBuffer.toString();

    return json;
  }
}
