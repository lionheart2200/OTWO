import 'package:flutter/material.dart';
import 'package:otwo/widgets/EmailVerificationProvider.dart';
import 'package:provider/provider.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailVerificationProvider = Provider.of<EmailVerificationProvider>(context);

    // Call checkEmailVerified on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      emailVerificationProvider.checkEmailVerified(context);
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Email Verification")),
      body: Center(
        child: emailVerificationProvider.isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("A verification link has been sent to your email."),
                  const Text("Please check your email and click the link to verify."),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => emailVerificationProvider.checkEmailVerified(context),
                    child: const Text("I have verified my email"),
                  ),
                ],
              ),
      ),
    );
  }
}
