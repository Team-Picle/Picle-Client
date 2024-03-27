import 'package:flutter/material.dart';
import 'package:picle/models/feed_model.dart';
import 'package:picle/providers/feed_provider.dart';
import 'package:picle/widgets/list/my_feed_item.dart';
import 'package:provider/provider.dart';

final likeCounts = [0, 0, 0, 3, 2, 2, 1, 3, 1, 2];

class MyFeeds extends StatelessWidget {
  const MyFeeds({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(
      builder: (context, provider, child) {
        List<Feed> myFeeds = provider.myFeeds;

        return ListView.builder(
          itemCount: myFeeds.length,
          primary: false,
          itemBuilder: (context, index) {
            Feed feed = myFeeds[index];

            return MyFeedItem(
              imageUrl: feed.verifiedImgUrl,
              date: feed.date,
              profileImage: feed.profileImage,
              likeCount: likeCounts[index % 10],
            );
          },
        );
      },
    );
  }
}
