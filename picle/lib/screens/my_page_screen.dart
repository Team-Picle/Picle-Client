import 'package:flutter/material.dart';
import 'package:picle/models/user_challenge_model.dart';
import 'package:picle/providers/user_challenge_provider.dart';
import 'package:picle/providers/user_provider.dart';
import 'package:provider/provider.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  static String name = '개디언즈';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider<UserChallengeProvider>(
            create: (_) => UserChallengeProvider(),
          ),
        ],
        builder: (context, child) {
          context.read<UserChallengeProvider>().fetchUserChallengeList();
          List<UserChallenge> userChallengeList =
              context.watch<UserChallengeProvider>().userChallengeList;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(
                    context.read<UserProvider>().user.profileImage!),
                backgroundColor: const Color(0XFF54C29B),
                radius: 40,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                context.read<UserProvider>().user.nickname!,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(40, 30)),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0XFFEDEEF0),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF333333),
                      ),
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return const Color.fromARGB(40, 84, 194, 106);
                        }

                        return Colors.transparent;
                      }),
                      elevation: const MaterialStatePropertyAll(0),
                    ),
                    child: const Text(
                      '수정',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                indent: 25.5,
                endIndent: 25.5,
              ),
            ],
          );
        },
      ),
    );
  }
}
