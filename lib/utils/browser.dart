import 'package:url_launcher/url_launcher_string.dart';

Future<void> launchInBrowser(String url) async {
  if (!await launchUrlString(url)) {
    throw 'Could not launch $url';
  }
}