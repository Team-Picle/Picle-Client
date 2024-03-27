import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImageListItem extends StatefulWidget {
  final String imageUrl;
  final String date;
  final bool isExplore;
  final int likeCount;

  const ImageListItem({
    required this.imageUrl,
    required this.date,
    required this.isExplore,
    Key? key,
    required this.likeCount,
  }) : super(key: key);

  @override
  _ImageListItemState createState() => _ImageListItemState();
}

class _ImageListItemState extends State<ImageListItem> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        if (widget.isExplore)
          Row(
            children: [
              const SizedBox(width: 16),
              SvgPicture.asset(
                'lib/images/profile.svg',
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 12),
              const Text(
                "익명의 눈송이",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        Card(
          color: Colors.white,
          margin: const EdgeInsets.all(13.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              widget.isExplore
                  ? Positioned(
                      left: 8.0,
                      bottom: 3.0,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isLiked = !isLiked;
                          });
                        },
                        icon: Stack(
                          children: [
                            Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : null,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Positioned(
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
              if (!widget.isExplore)
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
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
