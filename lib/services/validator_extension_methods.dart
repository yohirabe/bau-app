extension ExtString on String {
  bool get isDigits {
    final incidentRegExp = RegExp(r"^[0-9]+$");
    return incidentRegExp.hasMatch(this);
  }
}
