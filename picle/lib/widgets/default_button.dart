import 'package:flutter/material.dart';

final ButtonStyle buttonStyle = ButtonStyle(
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  backgroundColor: MaterialStateProperty.all<Color>(
    const Color(0XFFEDEEF0),
  ),
  foregroundColor: MaterialStateProperty.all<Color>(
    const Color(0xFF333333),
  ),
  minimumSize:
      MaterialStateProperty.all<Size>(const Size(double.maxFinite, 48)),
  overlayColor:
      MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
    // Pressed 상태일 때의 overlay color를 지정합니다.
    if (states.contains(MaterialState.pressed)) {
      return const Color.fromARGB(40, 84, 194, 106);
    }
    // 기본 overlay color를 지정합니다.
    return Colors.transparent;
  }),
  elevation: const MaterialStatePropertyAll(0),
);

class DefaultButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const DefaultButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: Text(
        buttonText,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
