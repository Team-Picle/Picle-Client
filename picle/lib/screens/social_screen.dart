import 'package:flutter/material.dart';
import 'package:picle/widgets/list/image_list.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({Key? key}) : super(key: key);

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen>
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
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
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
            overlayColor: MaterialStateProperty.all(
              Colors.transparent,
            ),
            tabs: const [
              Tab(text: 'MY FEED'),
              Tab(text: 'EXPLORE'),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30.0),
            height: MediaQuery.of(context).size.height - 120,
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ImageList(
                  isExplore: false,
                ),
                ImageList(
                  isExplore: true,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
