import 'package:flutter/material.dart';
import 'package:picle/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(provider.user.profileImage!),
              backgroundColor: const Color(0XFF54C29B),
              radius: 30,
            ),
            const SizedBox(
              width: 14,
            ),
            Text(
              provider.user.nickname!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        );
      },
    );
  }
}
