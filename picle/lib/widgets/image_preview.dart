import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePreviewWidget extends StatelessWidget {
  final XFile? image;

  const ImagePreviewWidget({Key? key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: image != null
          ? Image.file(
              File(image!.path),
              fit: BoxFit.cover,
            )
          : const Placeholder(),
    );
  }
}
