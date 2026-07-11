import 'package:url_launcher/url_launcher.dart';

Future<void> makePhoneCall(String phone) async {
  final uri = Uri.parse('tel:$phone');
  try {
    await launchUrl(uri);
  } catch (_) {}
}

Future<void> openWhatsApp(String phone) async {
  final cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
  final uri = Uri.parse('https://wa.me/$cleaned');
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {}
}
