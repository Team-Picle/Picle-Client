import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:picle/providers/routine_provider.dart';
import 'package:picle/widgets/default_button.dart';
import 'package:provider/provider.dart';

void routineModifyModal({
  required context,
  required onDelete,
  required onUpdate,
}) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    builder: (BuildContext context2) {
      return Consumer<RoutineProvider>(
        builder: (context, provider, child) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset('lib/images/home_indicator.svg'),
                const SizedBox(height: 15),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DefaultButton(
                        onPressed: () async {
                          onUpdate();
                        },
                        buttonText: '수정하기'),
                    const SizedBox(height: 20),
                    DefaultButton(onPressed: () {}, buttonText: '종료하기'),
                    const SizedBox(height: 40),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
