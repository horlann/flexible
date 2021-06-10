import 'dart:convert';
import 'dart:typed_data';
import 'package:flexible/board/repository/task_image_interface.dart';
import 'package:flutter/services.dart';

class ImageRepoMock extends ITaskImagesRepository {
  @override
  Future<Uint8List> imageById(String id) async {
    return (await rootBundle.load('src/task_icons/$id.png'))
        .buffer
        .asUint8List();
  }

  @override
  Future<List<String>> get allIds async {
    // >> To get paths you need these 2 lines
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = jsonDecode(manifestContent);
    // >> To get paths you need these 2 lines

    final imageNames = manifestMap.keys
        .where((String key) => key.contains('src/task_icons/'))
        .where((String key) => key.contains('.png'))
        .map((e) => e.replaceAll('src/task_icons/', ''))
        .map((e) => e.replaceAll('.png', ''))
        .toList();

    // print(imageNames);

    // Future.delayed(Duration(milliseconds: 2));
    // List<String> list = [
    //   'burger',
    //   'meeting',
    //   'meditation',
    //   'presentation',
    //   'pizza',
    //   'additional'
    // ];
    return imageNames;
  }
}
