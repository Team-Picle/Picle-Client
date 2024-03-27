import 'package:flutter/material.dart';
import 'package:picle/models/feed_model.dart';
import 'package:picle/providers/feed_provider.dart';
import 'package:picle/widgets/list/image_list.dart';
import 'package:provider/provider.dart';

// class SocialScreen extends StatefulWidget {
//   const SocialScreen({Key? key}) : super(key: key);

//   @override
//   State<SocialScreen> createState() => _SocialScreenState();
// }

// class _SocialScreenState extends State<SocialScreen>
//     with TickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(
//       length: 2,
//       vsync: this,
//       animationDuration: Duration.zero,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<FeedProvider>(builder: (context, provider, child) {
//       return SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 30,
//             ),
//             TabBar(
//               controller: _tabController,
//               indicatorColor: const Color(0xFF54C29B),
//               labelColor: const Color(0xFF54C29B),
//               labelStyle: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//               unselectedLabelColor: const Color(0XFFC8C8C8),
//               unselectedLabelStyle: const TextStyle(
//                 fontWeight: FontWeight.normal,
//               ),
//               isScrollable: false,
//               overlayColor: MaterialStateProperty.all(
//                 Colors.transparent,
//               ),
//               tabs: const [
//                 Tab(text: 'MY FEED'),
//                 Tab(text: 'EXPLORE'),
//               ],
//             ),
//             const SizedBox(height: 15),
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 30.0),
//               height: MediaQuery.of(context).size.height - 120,
//               child: TabBarView(
//                 controller: _tabController,
//                 physics: const NeverScrollableScrollPhysics(),
//                 children: [
//                   ImageList(
//                     isExplore: false,
//                   ),
//                   ImageList(
//                     isExplore: true,
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       );
//     });
//   }
// }

class SocialScreen extends StatefulWidget {
  const SocialScreen({Key? key}) : super(key: key);

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late List<Feed> myFeeds;
  final bool isExplore = false;
  final likeCounts = [0, 0, 0, 3, 2, 2, 1, 3, 1, 2];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      animationDuration: Duration.zero,
    );
    // Call fetchAllFeeds only once in initState
    context.read<FeedProvider>().fetchAllFeeds();
    myFeeds = context.read<FeedProvider>().allFeeds;
  }

  @override
  Widget build(BuildContext context) {
    if (myFeeds.isEmpty) {
      Feed feed = Feed(
        routineId: 1000,
        profileImage: 'lib/images/profile.svg',
        nickname: '익명의 눈송이',
        verifiedImgUrl: 'https://via.placeholder.com/150',
        date: '2024-03-27',
      );
      myFeeds.add(feed);
    }
    return Scaffold(
      body: SingleChildScrollView(
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
                  ListView.builder(
                    itemCount: myFeeds.length,
                    itemBuilder: (context, index) {
                      final feed = myFeeds[index];
                      final imageUrl = feed.verifiedImgUrl;
                      final date = feed.date;
                      int likeCount = likeCounts[index % 10];
                      return ImageListItem(
                        imageUrl: imageUrl,
                        date: date,
                        isExplore: false,
                        likeCount: likeCount,
                      );
                    },
                  ),
                  ListView.builder(
                    itemCount: myFeeds.length,
                    itemBuilder: (context, index) {
                      final feed = myFeeds[index];
                      final imageUrl = feed.verifiedImgUrl;
                      final date = feed.date;
                      int likeCount = likeCounts[index % 10];
                      return ImageListItem(
                        imageUrl: imageUrl,
                        date: date,
                        isExplore: true,
                        likeCount: likeCount,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
