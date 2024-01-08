import 'package:flutter/material.dart';
import 'package:picle/models/default_button_model.dart';
import 'package:picle/widgets/add_modal_widget.dart';

class TempScreen extends StatelessWidget {
  const TempScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () => addBottomModal(
                  context: context,
                  title: '루틴을 입력하세요.',
                  content: '루틴을 인증할 사진을 등록하고'
                      '\n매일 같은 구도로 사진을 촬영해서 인증해보세요!',
                  buttonText: '루틴 등록하기',
                  needImg: true,
                ),
                child: const Text('루틴 추가하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
