import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final GlobalKey<FormState> _formLoginKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formPasswordKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
              children: [
                const Spacer(),
                Form(
                  key: _formLoginKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Enter your login'
                          ),
                        )
                      ],
                    )
                ),
                const SizedBox(height:10),
                Form(
                  key: _formPasswordKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                        ),
                      )
                    ],
                  ),
                ),
                const Text("authorize or register, plz"),
                Row(
                  children: [
                    Text('remember me'),
                    Checkbox(value: false, onChanged: (bool? value) {})
                  ],
                ),
                ElevatedButton(
                    onPressed: () {Navigator.of(context).popAndPushNamed('/home');},
                    child: const Text("Next")
                ),
                const Spacer(),
              ]
          ),
        ),
    );
  }
}