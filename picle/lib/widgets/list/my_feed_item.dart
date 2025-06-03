import 'package:flutter/material.dart';

class MyFeedItem extends StatefulWidget {
  final String imageUrl;
  final String? date;
  final int likeCount;

  const MyFeedItem({
    required this.imageUrl,
    required this.date,
    required this.likeCount,
    Key? key,
  }) : super(key: key);

  @override
  State<MyFeedItem> createState() => _MyFeedItemState();
}

class _MyFeedItemState extends State<MyFeedItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
    );
  }
}
