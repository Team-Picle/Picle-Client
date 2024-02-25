import 'package:flutter/material.dart';
import 'package:picle/widgets/list/routine_list.dart';
import 'package:picle/widgets/list/todo_list.dart';

class ScheduleList extends StatefulWidget {
  const ScheduleList({super.key});

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      animationDuration: Duration.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFF54C29B),
            labelColor: const Color(0xFF54C29B),
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelColor: const Color(0XFFC8C8C8),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
            isScrollable: false,
            overlayColor: const MaterialStatePropertyAll(
              Colors.transparent,
            ),
            tabs: const [
              Tab(text: 'ROUTINE'),
              Tab(text: 'TODO'),
            ],
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  RoutineList(),
                  TodoList(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
