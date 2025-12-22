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
          // Get as Item object directly
          final item = hiveBox.get(key) as Item?;
          if (item == null) {
            return {
              'key': key,
              'title': '',
              'description': '',
              'id': '',
              'imageUrl': '',
            };
          }
          return {
            'key': key,
            'title': item.title,
            'description': item.description,
            'id': item.id,
            'imageUrl': item.imageUrl,
          };
        })
        .toList()
        .reversed
        .toList();
  }

  Future<void> createItem({required Item item}) async {
    try {
      await hiveBox.add(item);
      afterAction('Bookmark');
    } catch (e) {
      toastInfo(msg: 'Failed to bookmark', status: Status.error);
    }
  }

  Future<void> editItem({required Item item, required int itemKey}) async {
    try {
      hiveBox.put(itemKey, item);
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
  }
}
