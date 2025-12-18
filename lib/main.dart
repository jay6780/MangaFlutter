import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manga/constants/stringconstants.dart';
import 'package:manga/models/Item.dart';
import 'screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ItemAdapter());
  await Hive.openBox(StringConstants.hiveBox);

  runApp(const Home());
}
