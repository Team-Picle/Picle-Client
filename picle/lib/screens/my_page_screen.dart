import 'package:flutter/material.dart';

import 'package:picle/providers/user_provider.dart';
import 'package:picle/screens/login_screen.dart';
import 'package:provider/provider.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 20,
        ),
        CircleAvatar(
          backgroundImage:
              NetworkImage(context.read<UserProvider>().user.profileImage!),
          backgroundColor: const Color(0XFF54C29B),
          radius: 40,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          context.read<UserProvider>().user.nickname!,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await context.read<UserProvider>().logout();

                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size(40, 30)),
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color(0XFFEDEEF0),
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  const Color(0xFF333333),
                ),
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return const Color.fromARGB(40, 84, 194, 106);
                  }

                  return Colors.transparent;
                }),
                elevation: const MaterialStatePropertyAll(0),
              ),
              child: const Text(
                '로그아웃',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        const Divider(
          indent: 25.5,
          endIndent: 25.5,
        ),
      ],
    ));
  }
}
