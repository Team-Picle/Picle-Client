import 'package:flutter/material.dart';
import 'package:picle/providers/user_provider.dart';
import 'package:picle/screens/login_screen.dart';
import 'package:provider/provider.dart';

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
      ],
      child: const LoginScreen(),
    );
  }
}
