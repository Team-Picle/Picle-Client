import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:picle/notification.dart';
import 'package:picle/screens/splash_screen.dart';

void main() async {
  await initializeDateFormatting();
  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: '801dc4cda8fc9ecbbf58c83ab229179b',
    javaScriptAppKey: 'a992cef1da01df7485dfef6422b819b9',
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initNotification(context);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PICLE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: Colors.white,
          accentColor: const Color(0xFF54C29B),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Colors.black,
          ),
        ),
        cardColor: const Color(0xFFEDEEF0),
      ),
      home: const SplashScreen(),
    );
  }
}
