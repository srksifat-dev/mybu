import 'package:url_launcher/url_launcher.dart';

class ContactController {
  static Future<void> call(String number) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: number,
    );
    await launchUrl(launchUri);
  }

  static Future<void> mail(String to) async {
    final Uri email = Uri(
      scheme: 'mailto',
      path: to,
    );
    launchUrl(email);
  }
}
