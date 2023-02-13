import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bau_app/locator.dart';
import 'package:bau_app/services/config_service.dart';

class MedicalControlButton extends StatelessWidget {
  const MedicalControlButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: () async {
          try {
            String phoneNumber = await locator<ConfigService>().readPhone();
            final Uri phone = Uri.parse("tel:+$phoneNumber");
            if (await canLaunchUrl(phone)) await launchUrl(phone);
          } catch (error) {
            throw ("Cannot dial");
          }
        },
        style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
        child: const Text("Call Medical Control"));
  }
}
