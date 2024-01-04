import 'package:flutter/material.dart';

class ListItem extends StatefulWidget {
  final String text;
  final bool isChecked;

  const ListItem({
    super.key,
    required this.text,
    required this.isChecked,
  });

  @override
  State<ListItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<ListItem> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Transform.scale(
          scale: 1.3,
          child: Checkbox(
              semanticLabel: '테스트',
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity,
              ),
              value: _isChecked,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.green,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              activeColor: const Color(0xFF54C29B),
              onChanged: (value) {
                setState(() {
                  _isChecked = value!;
                });
              }),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            widget.text,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        IconButton(
          visualDensity: const VisualDensity(
            horizontal: VisualDensity.minimumDensity,
            vertical: VisualDensity.minimumDensity,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {},
          icon: const Icon(Icons.more_horiz),
        )
      ],
    );
  }
}
