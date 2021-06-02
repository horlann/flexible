import 'dart:typed_data';
import 'package:flexible/board/repository/task_image_interface.dart';
import 'package:flutter/services.dart';

class ImageRepoMock extends ITaskImagesRepository {
  @override
  Future<Uint8List> imageById(String id) async {
    if (id == 'additional') {
      return (await rootBundle.load('src/icons/additional.png'))
          .buffer
          .asUint8List();
    }

    if (id == 'morning') {
      return (await rootBundle.load('src/icons/morning.png'))
          .buffer
          .asUint8List();
    }
    if (id == 'goodnight') {
      return (await rootBundle.load('src/icons/goodnight.png'))
          .buffer
          .asUint8List();
    }
    if (id == 'pizza') {
      return (await rootBundle.load('src/icons/pizza.png'))
          .buffer
          .asUint8List();
    }
    if (id == 'presentation') {
      return (await rootBundle.load('src/icons/presentation.png'))
          .buffer
          .asUint8List();
    }
    if (id == 'meditation') {
      return (await rootBundle.load('src/icons/meditation.png'))
          .buffer
          .asUint8List();
    }
    if (id == 'meeting') {
      return (await rootBundle.load('src/icons/meeting.png'))
          .buffer
          .asUint8List();
    }
    if (id == 'burger') {
      return (await rootBundle.load('src/icons/burger.png'))
          .buffer
          .asUint8List();
    }

    return (await rootBundle.load('src/icons/additional.png'))
        .buffer
        .asUint8List();
  }

  @override
  Future<List<String>> get allIds async {
    Future.delayed(Duration(milliseconds: 2));
    List<String> list = [
      'burger',
      'meeting',
      'meditation',
      'presentation',
      'pizza',
      'additional'
    ];
    return list;
  }
}
