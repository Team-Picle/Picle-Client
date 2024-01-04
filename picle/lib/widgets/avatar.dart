import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        CircleAvatar(
          backgroundColor: Color(0XFF54C29B),
          radius: 30,
        ),
        SizedBox(
          width: 14,
        ),
        Text(
          'nickname',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}
