import 'package:flutter/material.dart';

class RoutineTime extends StatelessWidget {
  final String time;
  final Color? color;

  const RoutineTime({
    super.key,
    required this.time,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 34),
        Icon(
          Icons.access_time,
          size: 18.0,
          color: color ?? Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          time.length >= 5 ? time.substring(0, 5) : time,
          style: TextStyle(
            fontSize: 14,
            color: color ?? Colors.black,
          ),
        ),
      ],
    );
  }
}
