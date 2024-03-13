import 'package:flutter/material.dart';
import 'package:picle/providers/routine_provider.dart';
import 'package:provider/provider.dart';

const imgUrl = '';
const longitude = '';
const latitude = '';

class PreviewItem extends StatefulWidget {
  final int userId;
  final int id;
  final String text;

  const PreviewItem({
    super.key,
    required this.userId,
    required this.id,
    required this.text,
  });

  @override
  State<PreviewItem> createState() => _PreviewItemState();
}

class _PreviewItemState extends State<PreviewItem> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RoutineProvider>(
      builder: (context, provider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              child: IconButton(
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: () async {},
                  icon: const Icon(
                    Icons.add,
                    color: Colors.grey,
                  )),
              // const SizedBox(
              //   width: 10,
              // ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.text,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(
                width: 24,
                child: IconButton(
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    await provider.deleteRoutine(widget.userId, widget.id);
                  },
                  icon: const Icon(Icons.more_horiz),
                ))
          ],
        );
      },
    );
  }
}
