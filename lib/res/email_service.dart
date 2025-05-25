import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmailService {
  static final String _emailjsServiceId = dotenv.env['EMAILJS_SERVICE_ID']!;
  static final String _emailjsTemplateId = dotenv.env['EMAILJS_TEMPLATE_ID']!;
  static final String _emailjsUserId = dotenv.env['EMAILJS_PUBLIC_KEY']!;
  static const String _emailjsUrl =
      'https://api.emailjs.com/api/v1.0/email/send';

  static Future<void> sendRegistrationEmail({
    required String userEmail,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_emailjsUrl),
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': _emailjsServiceId,
          'template_id': _emailjsTemplateId,
          'user_id': _emailjsUserId,
          'template_params': {
            'email': userEmail,
            'password': password,
          }
        }),
      );

      if (response.statusCode == 200) {
        print('Email sent successfully');
      } else {
        print('Failed to send email: ${response.body}');
        throw Exception('Failed to send email');
      }
    } catch (e) {
      print('Error sending email: $e');
      throw Exception('Error sending email');
    }
  }
}
