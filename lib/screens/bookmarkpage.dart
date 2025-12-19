import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manga/colors/app_color.dart';
import 'package:manga/models/Item.dart';
import 'package:manga/screens/manga_detail.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:manga/constants/stringconstants.dart';

class Bookmarkpage extends StatefulWidget {
  const Bookmarkpage({super.key});

  @override
  BookmarkpageState createState() => BookmarkpageState();
}

class BookmarkpageState extends State<Bookmarkpage> {
  final Box<dynamic> _hiveBox = Hive.box(StringConstants.hiveBox);

  List<Item> getBookmarksFromHive() {
    final bookmarks = <Item>[];
    final keys = _hiveBox.keys.toList();
    for (var key in keys) {
      final item = _hiveBox.get(key);
      if (item != null && item is Item) {
        bookmarks.add(item);
      }
    }
    return bookmarks.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        title: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: Image.asset(
                        'images/back_white_home.png',
                        width: 35,
                        height: 35,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      tooltip: MaterialLocalizations.of(
                        context,
                      ).openAppDrawerTooltip,
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Bookmark',
                    style: GoogleFonts.robotoCondensed(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 1.0,
            color: AppColors.white,
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _hiveBox.listenable(),
              builder: (context, box, widget) {
                final bookmarks = getBookmarksFromHive();

                if (bookmarks.isEmpty) {
                  return Center(
                    child: Text(
                      'No bookmarks yet',
                      style: GoogleFonts.robotoCondensed(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  );
                }

                return GridView.custom(
                  gridDelegate: SliverWovenGridDelegate.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 3,
                    crossAxisSpacing: 3,
                    pattern: [
                      const WovenGridTile(0.7),
                      const WovenGridTile(
                        7 / 9,
                        crossAxisRatio: 1.0,
                        alignment: AlignmentDirectional.centerEnd,
                      ),
                    ],
                  ),
                  childrenDelegate: SliverChildBuilderDelegate(
                    (context, index) => _buildMangaCard(
                      context,
                      bookmarks[index].imageUrl,
                      bookmarks[index].id.toString(),
                      bookmarks[index].description,
                      bookmarks[index].title,
                    ),
                    childCount: bookmarks.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMangaCard(
    BuildContext context,
    String imageUrl,
    String id,
    String description,
    String title,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MangaDetail(id: id, description: description),
          ),
        );
      },
      child: Card(
        elevation: 50,
        shadowColor: AppColors.onBackground,
        color: AppColors.white,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7.0),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: AppColors.grey!,
                      highlightColor: AppColors.grey!,
                      child: Container(color: AppColors.white),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoCondensed(
                    fontSize: 15.00,
                    color: AppColors.onBackground,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
