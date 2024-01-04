import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;

  const Button({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        side: MaterialStateProperty.all<BorderSide>(
          const BorderSide(
            color: Color(0XFFEDEEF0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color(0XFFEDEEF0),
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          Colors.black,
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(vertical: 15),
        ),
        minimumSize: MaterialStateProperty.all<Size>(const Size.fromHeight(0)),
        overlayColor:
            const MaterialStatePropertyAll(Color.fromARGB(40, 84, 194, 106)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
