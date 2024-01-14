import 'package:flutter/material.dart';
import 'package:picle/widgets/add_modal_widget.dart';

class Button extends StatelessWidget {
  final String text;

  const Button({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      // 파라미터로 보내..~
      onPressed: () => addBottomModal(
        context: context,
        title: '루틴을 입력하세요.',
        content: '루틴을 인증할 사진을 등록하고'
            '\n매일 같은 구도로 사진을 촬영해서 인증해보세요!',
        buttonText: '루틴 등록하기',
        needImg: true,
      ),
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
