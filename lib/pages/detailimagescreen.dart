import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class DetailScreen extends StatelessWidget {
  String url;
  DetailScreen(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: CachedNetworkImage(
              imageUrl: url,
              imageBuilder: (context, imageProvider) =>
                  PhotoView(imageProvider: imageProvider),
              placeholder: (context, url) => Center(
                  child: const CircularProgressIndicator(strokeWidth: 2)),
              errorWidget: (context, url, error) => const Icon(
                Icons.image,
                size: 70,
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
