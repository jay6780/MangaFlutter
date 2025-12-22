import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manga/colors/app_color.dart';
import 'package:path_provider/path_provider.dart';
import 'package:manga/screens/bookmarkpage.dart';
import 'dart:io';
import 'dart:math';

class NavBar extends StatefulWidget {
  const NavBar({super.key});
  @override
  State<NavBar> createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  String? readableCacheSize;
  bool? isCleared = false;
  @override
  void initState() {
    super.initState();
    _loadCacheSize();
  }

  Future<void> _loadCacheSize() async {
    Directory tempDir = await getTemporaryDirectory();
    int totalSize = _getSize(tempDir);
    String readableSize = readableFileSize(totalSize);

    setState(() {
      readableCacheSize = readableSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30.0),
                child: Row(
                  children: [
                    ClipOval(
                      child: SvgPicture.asset(
                        width: 100.00,
                        height: 100.00,
                        'images/app_logo.svg',
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5.0),
                      child: Column(
                        children: [
                          Text(
                            'Free manga',
                            style: GoogleFonts.robotoCondensed(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'User interface: Ar-jay Urbina',
                            style: GoogleFonts.robotoCondensed(
                              fontSize: 13.0,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Api owner: Patrick Cosmos',
                            style: GoogleFonts.robotoCondensed(
                              fontSize: 13.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 1.00,
            margin: EdgeInsets.only(top: 10.0),
            color: AppColors.white,
          ),

          GestureDetector(
            onTap: () {
              print("book mark");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Bookmarkpage()),
              );
            },
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 30.0, left: 15.0),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'images/bookmark_white.svg',
                    width: 30,
                    height: 30,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Bookmark',
                      style: GoogleFonts.robotoCondensed(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              showCupertinoDialog(
                useRootNavigator: true,
                context: context,
                builder: (_) => CupertinoAlertDialog(
                  title: Text('Clear cache'),
                  content: Text('Are you sure want to clear?'),
                  actions: <CupertinoDialogAction>[
                    CupertinoDialogAction(
                      onPressed: () => (Navigator.of(context).pop()),
                      isDefaultAction: true,
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.robotoCondensed(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.select_color,
                        ),
                      ),
                    ),
                    CupertinoDialogAction(
                      onPressed: () => (_detelefile(context)),
                      isDestructiveAction: true,
                      child: Text(
                        "Ok",
                        style: GoogleFonts.robotoCondensed(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 30.0, left: 15.0),
              child: Row(
                children: [
                  SvgPicture.asset('images/delete.svg', width: 30, height: 30),
                  Container(
                    margin: EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Cache: $readableCacheSize',
                      style: GoogleFonts.robotoCondensed(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _detelefile(BuildContext context) {
    isCleared = true;
    deleteCache(context);
  }

  static Future<bool> deleteDir(FileSystemEntity dir) async {
    if (dir == null) return false;
    try {
      if (await dir.exists()) {
        if (dir is Directory) {
          final List<FileSystemEntity> children = dir.listSync();

          for (final FileSystemEntity child in children) {
            await deleteDir(child);
          }

          await dir.delete();
          return true;
        } else if (dir is File) {
          await dir.delete();
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error deleting directory: $e');
      return false;
    }
  }

  static Future<void> deleteCache(BuildContext context) async {
    try {
      final cacheDir = await getTemporaryDirectory();
      await deleteDir(cacheDir);
      Navigator.of(context).pop();
    } catch (e) {
      // Handle exception
    }
  }

  //get cache size

  int _getSize(FileSystemEntity file) {
    if (file is File) {
      return file.lengthSync();
    } else if (file is Directory) {
      int sum = 0;
      List<FileSystemEntity> children = file.listSync();
      for (FileSystemEntity child in children) {
        sum += _getSize(child);
        readableFileSize(sum);
      }
      return sum;
    }
    return 0;
  }

  String readableFileSize(int size) {
    if (size <= 0) return "0 Bytes";
    final List<String> units = ["Bytes", "kB", "MB", "GB", "TB"];
    int digitGroups = (size > 0) ? (log(size) ~/ log(1024)) : 0;
    return '${(size / pow(1024, digitGroups)).toStringAsFixed(1)} ${units[digitGroups]}';
  }
}
