import 'dart:typed_data';

abstract class ITaskImagesRepository {
  Future<Uint8List> imageById(String id);
  Future<List<String>> get allIds;
}
