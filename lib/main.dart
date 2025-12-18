import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manga/constants/stringconstants.dart';
import 'screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox(StringConstants.hiveBox);

  runApp(const Home());
}
