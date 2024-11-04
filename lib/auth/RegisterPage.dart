// register_page.dart
import 'package:flutter/material.dart';
import 'package:otwo/widgets/UserProvider.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String phone = '';
  String email = '';
  String password = '';

  void _register(UserProvider userProvider) {
    if (_formKey.currentState!.validate()) {
      userProvider.registerUser(username, phone, email, password).then((_) {
        if (userProvider.errorMessage.isEmpty) {
          Navigator.pushNamed(context, '/emailVerification');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'اسم المستخدم'),
                onChanged: (value) => username = value,
                validator: (value) => value!.isEmpty ? 'الرجاء إدخال اسم المستخدم' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'الهاتف'),
                onChanged: (value) => phone = value,
                validator: (value) => value!.isEmpty ? 'الرجاء إدخال رقم الهاتف' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
                onChanged: (value) => email = value,
                validator: (value) => value!.contains('@') ? null : 'يجب أن يحتوي البريد الإلكتروني على "@"',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'كلمة المرور'),
                obscureText: true,
                onChanged: (value) => password = value,
                validator: (value) => value!.length >= 8 ? null : 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل',
              ),
              if (userProvider.errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    userProvider.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 10),
              userProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () => _register(userProvider),
                      child: const Text("تسجيل"),
                    ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text("هل أنت مسجل بالفعل؟ تسجيل الدخول هنا"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
