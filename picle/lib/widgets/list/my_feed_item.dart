import 'package:flutter/material.dart';

class MyFeedItem extends StatefulWidget {
  final String imageUrl;
  final String date;
  final String profileImage;
  final int likeCount;

  const MyFeedItem({
    required this.imageUrl,
    required this.date,
    required this.profileImage,
    Key? key,
    required this.likeCount,
  }) : super(key: key);

  @override
  State<MyFeedItem> createState() => _MyFeedItemState();
}

class _MyFeedItemState extends State<MyFeedItem> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Card(
            color: Colors.white,
            // margin: const EdgeInsets.all(13.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      // width: 150,
                      height: 362,
                    ),
                  ],
                ),
                Positioned(
                  left: 8.0,
                  bottom: 3.0,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Stack(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 50.0,
                  bottom: 16.0,
                  child: Text(
                    '${widget.likeCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
                Positioned(
                  right: 15.0,
                  bottom: 20.0,
                  child: Text(
                    'Date: ${widget.date}',
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
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
      ),
    );
  }
}
