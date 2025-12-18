import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:manga/models/Item.dart';
import 'package:manga/constants/stringconstants.dart';
import 'package:manga/screens/bookmarkpage.dart';

import 'package:manga/utils/toast.dart';

class HiveController {
  final BuildContext context;
  final Function fetchDataFunction;

  HiveController({required this.context, required this.fetchDataFunction});

  final hiveBox = Hive.box(StringConstants.hiveBox);

  // Fetch all items from Hive
  List<Map<String, dynamic>> fetchData() {
    return hiveBox.keys
        .map((key) {
          final item = hiveBox.get(key) as Map<String, dynamic>;
          final itemObject = Item.fromMap(item);
          return {
            'key': key,
            'title': itemObject.title,
            'timestamp': itemObject.timestamp,
            'description': itemObject.description,
            'id': itemObject.id,
            'imageUrl': itemObject.imageUrl,
          };
        })
        .toList()
        .reversed
        .toList();
  }

  Future<void> createItem({required Item item}) async {
    try {
      await hiveBox.add(item.toMap());
      afterAction('Bookmark');
    } catch (e) {
      toastInfo(msg: 'Failed to bookmark', status: Status.error);
    }
  }

  Future<void> editItem({required Item item, required int itemKey}) async {
    try {
      hiveBox.put(itemKey, item.toMap());
      afterAction('edited');
    } catch (e) {
      toastInfo(msg: 'Failed to edit item', status: Status.error);
    }
  }

  Future<void> deleteItem({required int key}) async {
    try {
      await hiveBox.delete(key);
      afterAction('Bookmark deleted');
    } catch (e) {
      toastInfo(msg: 'Failed to delete bookmark', status: Status.error);
    }
  }

  Future<void> clearItems() async {
    try {
      await hiveBox.clear();
      afterAction('cleared');
    } catch (e) {
      toastInfo(msg: 'Failed to clear items', status: Status.error);
    }
  }

  void afterAction(String keyword) {
    toastInfo(msg: '$keyword successfully', status: Status.success);
    fetchDataFunction();
    Navigator.of(context).pop();
  }
}
