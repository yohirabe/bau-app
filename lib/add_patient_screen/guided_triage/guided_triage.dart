import 'package:bau_app/add_patient_screen/add_patient_form.dart';
import 'package:bau_app/dashboard/patient_element.dart';
import 'package:flutter/material.dart';

class Node {
  // condition is applied to patient if question answered yes
  final String? text;
  final Map<bool, int>? next;
  final Map<bool, String?>? conditions;
  final int? statusDesignation;
  Node(this.text, this.next, this.conditions, this.statusDesignation);
}

var guidedTriageDecisionTree = {
  0: Node("Breathing?", {true: 1, false: 2}, {true: "Breathing", false: null},
      null),
  1: Node("Is There Uncontrolled Bleeding?", {true: 3, false: 4},
      {true: "Severe Bleed", false: null}, null),
  2: Node("(Open airway) Now Breathing?", {true: 1, false: 5},
      {true: "Breathing", false: "CPR In Progress"}, null),
  3: Node("Apply Tourniquet Or Direct Pressure & Elevate", null, null, 1),
  4: Node("Is Patient Mobile?", {true: 6, false: 6},
      {true: "Mobile", false: "Not Mobile"}, null),
  5: Node("(Start CPR)", null, null, 1),
  6: Node("Difficulty Breathing?", {true: 7, false: 8},
      {true: "Difficulty Breathing", false: null}, null),
  7: Node(null, null, null, 2),
  8: Node("Radial Pulse Present?", {true: 9, false: 7},
      {true: "Pulse", false: "No Pulse"}, null),
  9: Node("Obeys Commands", {true: 10, false: 7},
      {true: "Obeys Commands", false: "Does Not Obey Commands"}, null),
  10: Node(null, null, null, 3),
};

class GuidedTriageScreen extends StatefulWidget {
  const GuidedTriageScreen({super.key});

  @override
  State<GuidedTriageScreen> createState() => _GuidedTriageScreenState();
}

class _GuidedTriageScreenState extends State<GuidedTriageScreen> {
  Node currentNode = guidedTriageDecisionTree[0]!; // Root node
  List<String> conditions = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: const Text(
          'Guided Triage',
        ),
      ),
      body: Card(
        color: Colors.grey[300],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        margin: const EdgeInsets.all(20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (currentNode.statusDesignation != null)
                  ? Text(
                      "Status ${currentNode.statusDesignation}",
                      style: TextStyle(
                          backgroundColor:
                              statusColors[currentNode.statusDesignation],
                          fontSize: 30,
                          color: Colors.white),
                    )
                  : Container(),
              Text(
                currentNode.text ?? "",
                style: const TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              currentNode.next != null ? yesNoButtons() : submitButton()
            ]),
      ),
    );
  }

  Center submitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // status designation should never be null here
          GuidedTriageResult result =
              GuidedTriageResult(currentNode.statusDesignation!, conditions);
          Navigator.pop(context, result);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(30),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text("OK", style: TextStyle(fontSize: 24)),
      ),
    );
  }

  Row yesNoButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // These buttons are basically duplicates maybe refactor this.
        yesNoButton(true),
        const SizedBox(width: 30),
        yesNoButton(false),
      ],
    );
  }

  ElevatedButton yesNoButton(bool isYes) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(30),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: isYes ? Colors.blue : Colors.white,
          foregroundColor: isYes ? Colors.white : Colors.blue,
          //side: const BorderSide(color: Colors.green, width: 3),
        ),
        onPressed: () {
          String? condition = currentNode.conditions![isYes];
          if (condition != null) conditions.add(condition);
          setState(() {
            currentNode = guidedTriageDecisionTree[currentNode.next![isYes]]!;
          });
        },
        child: Text(
          isYes ? "YES" : "NO",
          style: const TextStyle(fontSize: 24),
        ));
  }
}
