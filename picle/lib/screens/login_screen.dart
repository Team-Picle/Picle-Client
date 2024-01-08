import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:picle/app.dart';
import 'package:picle/models/user_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // static const String baseUrl = "http://localhost:8080/social";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Flexible(
            flex: 3,
            child: Center(
              child: SvgPicture.asset('lib/images/picle_logo.svg'),
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    final GoogleSignInAccount? googleUser =
                        await GoogleSignIn().signIn();
                    if (googleUser != null) {
                      UserModel userModel = UserModel(
                        id: googleUser.id,
                        nickname: googleUser.displayName,
                        imageUrl: googleUser.photoUrl,
                        platform: "GOOGLE",
                      );
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const App()));
                    }
                  }, // Image tapped
                  child: Image.asset(
                    'lib/images/login_with_google.png',
                    fit: BoxFit.cover, // Fixes border issues
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    // 카카오톡 설치 여부 확인
                    // 카카오톡이 설치되어 있으면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
                    if (await isKakaoTalkInstalled()) {
                      try {
                        await UserApi.instance.loginWithKakaoTalk();
                        // print('카카오톡으로 로그인 성공');
                      } catch (error) {
                        // print('카카오톡으로 로그인 실패 $error');

                        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
                        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
                        if (error is PlatformException &&
                            error.code == 'CANCELED') {
                          return;
                        }
                        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
                        try {
                          await UserApi.instance.loginWithKakaoAccount();
                          // print('카카오계정으로 로그인 성공');
                        } catch (error) {
                          // print('카카오계정으로 로그인 실패 $error');
                        }
                      }
                    } else {
                      try {
                        await UserApi.instance.loginWithKakaoAccount();
                        // print('카카오계정으로 로그인 성공');
                      } catch (error) {
                        // print('카카오계정으로 로그인 실패 $error');
                      }
                    }

                    try {
                      User user = await UserApi.instance.me();
                      UserModel userModel = UserModel(
                        id: user.id.toString(),
                        nickname: user.kakaoAccount?.profile?.nickname,
                        imageUrl: user.kakaoAccount?.profile?.profileImageUrl,
                        platform: 'KAKAO',
                      );
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const App()));
                      //   print("id: ${userModel.id}"
                      //       "\nnickname: ${userModel.nickname}"
                      //       "\nimageUrl: ${userModel.imageUrl}"
                      //       "\nplatform: ${userModel.platform}");
                    } catch (error) {
                      // print('사용자 정보 요청 실패 $error');
                    }
                  }, // Image tapped
                  child: Image.asset(
                    'lib/images/login_with_kakao.png',
                    fit: BoxFit.cover, // Fixes border issues
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> kakaoLogin() async {
    // 카카오톡 설치 여부 확인
    // 카카오톡이 설치되어 있으면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        // print('카카오톡으로 로그인 성공');
      } catch (error) {
        // print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount();
          // print('카카오계정으로 로그인 성공');
        } catch (error) {
          // print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        // print('카카오계정으로 로그인 성공');
      } catch (error) {
        // print('카카오계정으로 로그인 실패 $error');
      }
    }

    try {
      User user = await UserApi.instance.me();
      UserModel userModel = UserModel(
        id: user.id.toString(),
        nickname: user.kakaoAccount?.profile?.nickname,
        imageUrl: user.kakaoAccount?.profile?.profileImageUrl,
        platform: 'KAKAO',
      );
      //   print("id: ${userModel.id}"
      //       "\nnickname: ${userModel.nickname}"
      //       "\nimageUrl: ${userModel.imageUrl}"
      //       "\nplatform: ${userModel.platform}");
    } catch (error) {
      // print('사용자 정보 요청 실패 $error');
    }
  }
}
