import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

Future<String> uploadImage(XFile? imageFile, String imageName) async {
  const cloudName = 'dqhllkoz8';
  const apiKey = '183691545148966';
  const apiSecret = 'm-LCpANScVbTD2mU3Y1fG_wWwaE';
  const uploadPreset = 'np5ceccr';

  final url =
      Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

  try {
    final request = http.MultipartRequest('POST', url);

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imageFile!.path,
        filename: imageName,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    request.headers.addAll({
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}',
    });
    request.fields['upload_preset'] = uploadPreset;

    final response = await request.send();
    if (response.statusCode == 200) {
      // 업로드 성공
      final responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> jsonResponse = json.decode(responseBody);
      return jsonResponse['public_id'].toString();
    } else {
      // 업로드 실패
      print('Failed to upload image. Status code: ${response.statusCode}');
      return '';
    }
  } catch (e) {
    print('Error uploading image: $e');
    return '';
  }
}

class GetImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const GetImage({
    super.key,
    required this.imageUrl,
    this.width = 100,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      placeholder: (context, url) =>
          const CircularProgressIndicator(), // 이미지 로딩 중에 표시될 위젯
      errorWidget: (context, url, error) =>
          const Icon(Icons.error), // 이미지 로딩 중 오류가 발생할 때 표시될 위젯
      fit: BoxFit.cover, // 이미지를 적절한 크기로 맞추기 위해 사용됨
    );
  }
}
