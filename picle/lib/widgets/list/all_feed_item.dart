import 'package:flutter/material.dart';

class AllFeedItem extends StatefulWidget {
  final String imageUrl;
  final String date;
  final String nickname;
  final String profileImage;

  const AllFeedItem({
    required this.imageUrl,
    required this.date,
    required this.nickname,
    required this.profileImage,
    Key? key,
  }) : super(key: key);

  @override
  State<AllFeedItem> createState() => _AllFeedItemState();
}

class _AllFeedItemState extends State<AllFeedItem> {
  bool isLiked = false;

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
          // margin: const EdgeInsets.all(10.0),
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
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.white,
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
