import 'package:flutter/material.dart';
import 'package:picle/models/feed_model.dart';
import 'package:picle/providers/feed_provider.dart';
import 'package:picle/widgets/list/all_feed_item.dart';
import 'package:provider/provider.dart';

class AllFeeds extends StatelessWidget {
  const AllFeeds({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(
      builder: (context, provider, child) {
        List<Feed> allFeeds = provider.allFeeds;
        allFeeds = allFeeds.reversed.toList();

        return ListView.builder(
          itemCount: allFeeds.length,
          primary: false,
          itemBuilder: (context, index) {
            Feed feed = allFeeds[index];

            return AllFeedItem(
              imageUrl: feed.verifiedImgUrl,
              date: feed.date,
              nickname: feed.nickname,
              profileImage: feed.profileImage,
            );
          },
        );
      },
    );
  }
}
