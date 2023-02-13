import 'package:flutter/material.dart';
import 'package:bau_app/locator.dart';
import 'package:bau_app/services/config_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneTextController = TextEditingController();
  String? initialPhoneValue;

  @override
  void initState() {
    super.initState();
    setInitialPhoneValue();
  }

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
          title: const Text("Settings"),
        ),
        body: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Medical Control Phone Number'),
              controller: phoneTextController,
              onSaved: (value) => locator<ConfigService>().writePhone(value!),
              validator: (value) => (value == null || value == "")
                  ? "Enter medical control phone number"
                  : null,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Saved Settings')));
                  }
                },
                child: const Text("Save"))
          ]),
        ));
  }

  Future<void> setInitialPhoneValue() async {
    String? value = await locator<ConfigService>().readPhone();
    setState(() {
      phoneTextController.text = value;
    });
  }
}
