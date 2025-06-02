// import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:picle/screens/login_screen.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSplashScreen(
//       splash: SvgPicture.asset('lib/images/picle_logo.svg'),
//       nextScreen: const LoginScreen(),
//       splashTransition: SplashTransition.fadeTransition,
//       pageTransitionType: PageTransitionType.fade,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:picle/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:picle/screens/login_screen.dart';
import 'package:picle/app.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleStartUpLogic(); // context 안전하게 사용 가능
    });
  }

  void _moveToApp() {
    if (!mounted) return;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const App()));
  }

  void _moveToLogin() {
    if (!mounted) return;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  Future<void> _handleStartUpLogic() async {
    await Future.delayed(const Duration(seconds: 2)); // 로고 표시 시간

    final prefs = await SharedPreferences.getInstance();
    final savedPlatform = prefs.getString('login_platform');

    if (savedPlatform == 'KAKAO') {
      await _tryKakaoAutoLogin();
    } else if (savedPlatform == 'GOOGLE') {
      await _tryGoogleAutoLogin();
    } else {
      _moveToLogin();
    }
  }

  Future<void> _tryGoogleAutoLogin() async {
    final googleUser = await GoogleSignIn().signInSilently();

    if (googleUser != null) {
      await context.read<UserProvider>().registerUser(
            clientKey: googleUser.id,
            nickname: googleUser.displayName,
            profileImage: googleUser.photoUrl,
            socialPlatform: "GOOGLE",
          );
      _moveToApp();
    } else {
      _moveToLogin();
    }
  }

  Future<void> _tryKakaoAutoLogin() async {
    if (await AuthApi.instance.hasToken()) {
      try {
        await UserApi.instance.accessTokenInfo();
        final user = await UserApi.instance.me();

        await context.read<UserProvider>().registerUser(
              clientKey: user.id.toString(),
              nickname: user.kakaoAccount?.profile?.nickname,
              profileImage: user.kakaoAccount?.profile?.profileImageUrl,
              socialPlatform: "KAKAO",
            );

        _moveToApp();
      } catch (_) {
        _moveToLogin();
      }
    } else {
      _moveToLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset('lib/images/picle_logo.svg'),
      ),
    );
  }
}
