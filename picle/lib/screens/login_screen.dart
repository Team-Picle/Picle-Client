import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:picle/app.dart';
import 'package:picle/providers/user_provider.dart';
import 'package:picle/shared_preferences.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        return Container(
          color: Colors.white,
          child: Column(
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

                        if (googleUser == null) {
                          return;
                        }

                        try {
                          await provider.registerUser(
                            clientKey: googleUser.id,
                            nickname: googleUser.displayName,
                            profileImage: googleUser.photoUrl,
                            socialPlatform: "GOOGLE",
                          );

                          await saveLoginPlatform("GOOGLE");

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const App()));
                        } catch (error) {
                          print(error);
                        }
                      },
                      child: Image.asset(
                        'lib/images/login_with_google.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        try {
                          await kakaoLogin();

                          User user = await UserApi.instance.me();

                          await provider.registerUser(
                            clientKey: user.id.toString(),
                            nickname: user.kakaoAccount?.profile?.nickname,
                            profileImage:
                                user.kakaoAccount?.profile?.profileImageUrl,
                            socialPlatform: "KAKAO",
                          );

                          await saveLoginPlatform("KAKAO");

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const App()));
                        } catch (error) {
                          print(error);
                        }
                      },
                      child: Image.asset(
                        'lib/images/login_with_kakao.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> kakaoLogin() async {
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
      } catch (error) {
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }

        try {
          await UserApi.instance.loginWithKakaoAccount();
        } catch (error) {
          throw Exception('카카오 로그인 중 에러 발생: $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
      } catch (error) {
        throw Exception('카카오 로그인 중 에러 발생: $error');
      }
    }
  }
}
