import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> sendInviteEmail(String email, String workspaceName) async {
  final url = Uri.parse(
    'https://lefjwsixkkojulrpvgdy.supabase.co/functions/v1/send_invite_email',
  );

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'apikey': 'sb_publishable_rmXp62eXCRGlfX7WXRtjvA_rEkwjXNB',
      'Authorization': 'Bearer sb_secret_mZt2MnPwNIgz5RAZfOGfAg_2zeolALz',
    },
    body: jsonEncode({
      'email': email,
      'workspaceName': workspaceName,
    }),
  );

  if (response.statusCode == 200) {
    log('Email sent successfully!');
  } else {
    log('Failed to send email: ${response.body}');
  }
}
