import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flexible/board/repository/image_repo_mock.dart';

class CachedIcon extends StatefulWidget {
  final String imageID;
  const CachedIcon({
    Key? key,
    required this.imageID,
  }) : super(key: key);

  @override
  _CachedIconState createState() => _CachedIconState();
}

class _CachedIconState extends State<CachedIcon> {
  static Map<String, Image> cachedImages = {};

  Image defaultImage = Image.asset(
    'src/task_icons/noimage.png',
    width: 24,
    height: 24,
    gaplessPlayback: true,
  );

  late Image image;

  loadImg() async {
    image = defaultImage;
    try {
      Uint8List imageData = await RepositoryProvider.of<ImageRepoMock>(context)
          .imageById(widget.imageID);

      image = Image.memory(
        imageData,
        width: 24,
        height: 24,
        gaplessPlayback: true,
      );

      cachedImages[widget.imageID] = image;
      setState(() {});
    } catch (e) {}
  }

  @override
  void initState() {
    if (cachedImages.containsKey(widget.imageID)) {
      image = cachedImages[widget.imageID]!;
    } else {
      loadImg();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return image;
  }
}
