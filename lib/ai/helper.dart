import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:ext_storage/ext_storage.dart';

class AIHelper {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static exportCsv() async {
    List<List<dynamic>> rows = [];

    List<dynamic> row = [];
    row.add('');
    row.add("taskName");
    row.add("iconId");
    row.add('');
    rows.add(row);

    List<QueryDocumentSnapshot> asd =
        (await _firestore.collection('users').get()).docs;

    asd.forEach((element) async {
      var asdasd = element.reference.collection('tasks');

      List<QueryDocumentSnapshot> tasks =
          (await asdasd.where('forAi', isEqualTo: true).get()).docs;

      tasks.forEach((element) {
        List<dynamic> row = [];
        row.add('');
        row.add(element.get('title').toString().toLowerCase().trim());
        row.add(element.get('iconId'));
        row.add('');
        rows.add(row);
      });

      print(rows);

      String csv = const ListToCsvConverter().convert(rows);

      String? dir = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS);
      print("dir $dir");
      String file = "$dir";

      File f = File(file + "/fdata.csv");

      f.writeAsString(csv);
    });
  }
}
