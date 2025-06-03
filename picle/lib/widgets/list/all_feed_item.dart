import 'package:flutter/material.dart';
import 'package:picle/providers/feed_provider.dart';
import 'package:picle/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AllFeedItem extends StatefulWidget {
  final int routineId;
  final String imageUrl;
  final String nickname;
  final String profileImage;
  final bool isLike;

  const AllFeedItem({
    required this.routineId,
    required this.imageUrl,
    required this.nickname,
    required this.profileImage,
    required this.isLike,
    Key? key,
  }) : super(key: key);

  @override
  State<AllFeedItem> createState() => _AllFeedItemState();
}

class _AllFeedItemState extends State<AllFeedItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.profileImage),
              backgroundColor: const Color(0XFF54C29B),
              radius: 20,
            ),
            const SizedBox(width: 12),
            Text(
              widget.nickname,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        Card(
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    height: 362,
                  ),
                ],
              ),
              Positioned(
                left: 8.0,
                bottom: 3.0,
                child: IconButton(
                  onPressed: () {
                    final int userId = context.read<UserProvider>().userId;

                    if (widget.isLike) {
                      context
                          .read<FeedProvider>()
                          .unlike(userId: userId, routineId: widget.routineId);
                    } else {
                      context
                          .read<FeedProvider>()
                          .like(userId: userId, routineId: widget.routineId);
                    }
                  },
                  icon: Icon(
                    widget.isLike ? Icons.favorite : Icons.favorite_border,
                    color: widget.isLike ? Colors.red : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
