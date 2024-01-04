import 'package:flutter/material.dart';

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
    return TabBar(
      controller: _tabController,
      indicatorColor: const Color(0xFF54C29B),
      labelColor: const Color(0xFF54C29B),
      labelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelColor: Color(0XFFC8C8C8),
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
    );
  }
}