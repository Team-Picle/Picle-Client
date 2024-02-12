import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showImageSourceDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return GestureDetector(
        // GestureDetector 추가
        onTap: () {
          Navigator.pop(context); // 다이얼로그 닫기
        },
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: CupertinoAlertDialog(
              title: const Text(
                '이미지 등록',
                style: TextStyle(fontSize: 18),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  CupertinoDialogAction(
                    child: const Text('갤러리에서 선택'),
                    onPressed: () async {
                      Navigator.pop(context);
                      var picker = ImagePicker();
                      var image =
                          await picker.pickImage(source: ImageSource.gallery);
                      // 갤러리에서 사진 선택
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text('카메라 실행'),
                    onPressed: () async {
                      Navigator.pop(context);
                      var picker = ImagePicker();
                      var image =
                          await picker.pickImage(source: ImageSource.camera);
                      // 카메라 실행
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text(
                      '취소',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // 다이얼로그 닫기
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
