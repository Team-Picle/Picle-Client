import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:picle/providers/todo_provider.dart';
import 'package:picle/widgets/default_button.dart';
import 'package:provider/provider.dart';

class TodoItem extends StatefulWidget {
  final int userId;
  final int id;
  final String text;
  final bool isChecked;

  const TodoItem({
    super.key,
    required this.userId,
    required this.id,
    required this.text,
    required this.isChecked,
  });

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  final TextEditingController _controller = TextEditingController();
  late String content;
  late bool isUpdate;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.text;
    content = widget.text;
    isUpdate = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateContent() {
    setState(() {
      isUpdate = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(builder: (context, provider, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            child: Transform.scale(
              scale: 1.2,
              child: Checkbox(
                  semanticLabel: '테스트',
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                  value: widget.isChecked,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.green,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  activeColor: const Color(0xFF54C29B),
                  onChanged: (value) {
                    provider.completeTodo(
                      userId: widget.userId,
                      todoId: widget.id,
                      isCompleted: value,
                    );
                  }),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          if (!isUpdate)
            Expanded(
              child: Text(
                widget.text,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            )
          else
            Expanded(
              child: TextField(
                controller: _controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: '수정할 내용을 입력해주세요.',
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  border: InputBorder.none,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF54C29B), width: 2),
                  ),
                ),
                onTapOutside: (event) {
                  _controller.text = widget.text;
                  FocusManager.instance.primaryFocus?.unfocus();
                  setState(() {
                    isUpdate = false;
                  });
                },
                onChanged: (text) {
                  setState(() {
                    content = text;
                  });
                },
                onEditingComplete: () {
                  setState(() {
                    isUpdate = false;
                  });
                  provider.updateTodo(
                    userId: widget.userId,
                    todoId: widget.id,
                    content: _controller.text,
                  );
                },
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
                showModalBottomSheet(
                  backgroundColor: Colors.white,
                  context: context,
                  builder: (BuildContext context2) => StatefulBuilder(
                    builder: (BuildContext context, setState) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SvgPicture.asset('lib/images/home_indicator.svg'),
                              const SizedBox(height: 15),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  DefaultButton(
                                    onPressed: () {
                                      updateContent();
                                      Navigator.pop(context);
                                    },
                                    buttonText: '수정하기',
                                  ),
                                  const SizedBox(height: 20),
                                  DefaultButton(
                                    onPressed: () async {
                                      await provider.deleteTodo(
                                        userId: widget.userId,
                                        todoId: widget.id,
                                      );
                                      Navigator.pop(context);
                                    },
                                    buttonText: '삭제하기',
                                  ),
                                  const SizedBox(height: 40),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              icon: const Icon(Icons.more_horiz),
            ),
          ),
        ],
      );
    });
  }
}
