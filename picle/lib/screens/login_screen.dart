import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Flexible(
            flex: 3,
            child: Center(
              child: Image.asset('lib/images/picle_logo.png'),
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('lib/images/login_with_google.png'),
                const SizedBox(height: 20),
                Image.asset('lib/images/login_with_kakao.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
