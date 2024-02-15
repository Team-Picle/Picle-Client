import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePreviewWidget extends StatelessWidget {
  final XFile? image;

  const ImagePreviewWidget({Key? key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100, // 원하는 높이로 조절
      width: double.infinity,
      child: image != null
          ? Image.file(
              File(image!.path),
              fit: BoxFit.cover,
            )
          : const Placeholder(), // 대체 UI를 여기에 넣어주세요. 예를 들어 Placeholder 사용
    );
  }
}
