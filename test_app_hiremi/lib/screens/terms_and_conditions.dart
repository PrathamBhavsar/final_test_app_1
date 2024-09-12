import 'package:flutter/material.dart';
import 'package:test_app/constants/app_constants.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text(
              'Terms and Conditions',
              style: AppConstants.fieldTitle,
            ),
            const SizedBox(height: 16.0),
            const Text(
              '1. Introduction\n'
              'Welcome to our app. These terms and conditions govern your use of our app. By using the app, you agree to these terms.\n\n'
              '2. License\n'
              'We grant you a limited, non-exclusive, non-transferable license to use the app for personal, non-commercial use only.\n\n'
              '3. Restrictions\n'
              'You may not: (a) copy, modify, or distribute the app; (b) reverse engineer or attempt to derive the source code; (c) use the app for any unlawful purpose.\n\n'
              '4. Termination\n'
              'We may terminate or suspend your access to the app at any time, without prior notice, for conduct that we believe violates these terms or is harmful to the app.\n\n'
              '5. Limitation of Liability\n'
              'To the fullest extent permitted by law, we shall not be liable for any indirect, incidental, special, consequential, or punitive damages arising out of your use of the app.\n\n'
              '6. Changes to Terms\n'
              'We may update these terms from time to time. We will notify you of any changes by posting the new terms on this page.\n\n'
              '7. Contact Us\n'
              'If you have any questions about these terms, please contact us at support@example.com.\n',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
