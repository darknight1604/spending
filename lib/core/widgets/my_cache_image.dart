import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyCacheImage extends StatelessWidget {
  final String imageUrl;
  final Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder;
  const MyCacheImage({
    super.key,
    required this.imageUrl,
    this.imageBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
      imageBuilder: imageBuilder,
    );
  }
}
