import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// This does not work on emulators
class MedicalControlButton extends StatelessWidget {
  const MedicalControlButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: () async {
          // TODO: get real phone number from a config file
          final Uri phone = Uri.parse("tel:+1234567890");

          try {
            if (await canLaunchUrl(phone)) await launchUrl(phone);
          } catch (error) {
            throw ("Cannot dial");
          }
        },
        style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
        child: const Text("Call Medical Control"));
  }
}
