import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:picle/models/default_button_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void addBottomModal({
  required BuildContext context,
  required String title,
  required String content,
  required String buttonText,
  required bool needImg,
}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      Widget renderEmpty() {
        return Container();
      }

      Widget renderAddImg() {
        return GestureDetector(
          onTap: () async {
            var picker = ImagePicker();
            var image = await picker.pickImage(source: ImageSource.gallery);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset('lib/images/picture_icon.svg'),
              const SizedBox(width: 12),
              const Text(
                '이미지 등록',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        height: 345,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset('lib/images/home_indicator.svg'),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 27),
            Text(
              content,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 27),
            needImg ? renderAddImg() : renderEmpty(),
            const SizedBox(height: 30),
            ElevatedButton(
              style: buttonStyle,
              onPressed: null,
              child: Text(buttonText),
            ),
          ],
        ),
      );
    },
  );
}
