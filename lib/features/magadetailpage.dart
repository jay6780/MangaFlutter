import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:manga/colors/app_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:manga/models/Item.dart';
import 'package:manga/screens/imagelist.dart';
import 'package:manga/models/detail_bean.dart';
import 'package:manga/providers/detaildatanotifier.dart';
import 'package:manga/utils/hivecontroller.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MangaDetailPage extends StatefulWidget {
  final String? id;
  final String? description;
  MangaDetailPage({super.key, required this.id, required this.description});

  @override
  MangaDetailPageState createState() => MangaDetailPageState();
}

class MangaDetailPageState extends State<MangaDetailPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  String? image;
  String? title;
  String? status;
  String? mangaDesc;
  String? bookmarkId;
  bool isBookmarked = false;
  List<Chapters> chapterList = [];
  List<String> genres = [];
  bool isVisible = false;
  String? genre;
  var logger = Logger();
  late HiveController _hiveController;

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _hiveController = HiveController(
      context: context,
      fetchDataFunction: _loadBookmarks,
    );

    _loadBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Detaildatanotifier>(
        context,
        listen: false,
      ).getDetailData(widget.id.toString());
    });

    return Consumer<Detaildatanotifier>(
      builder: (context, value, child) {
        if (value.uiState == UiState.loading) {
          return const Center(
            child: SpinKitThreeBounce(color: AppColors.white, size: 30.0),
          );
        } else if (value.uiState == UiState.error) {
          return Center(child: Text(value.message.toString()));
        }

        for (DetailBean detailBean in value.detailbeanList) {
          image = detailBean.getImageUrl;
          title = detailBean.getTitle;
          status = detailBean.getStatus;
          chapterList.addAll(detailBean.chapters);
          genres.addAll(detailBean.getGenres);
        }
        chapterList.sort((a, b) {
          final aNum = int.tryParse(a.getChapterId.split('-').first) ?? 0;
          final bNum = int.tryParse(b.getChapterId.split('-').first) ?? 0;
          return aNum.compareTo(bNum);
        });

        genre = genres.join(', ');
        mangaDesc = widget.description;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      backgroundColor: AppColors.background,
                      automaticallyImplyLeading: false,
                      expandedHeight: 240.0,
                      floating: false,
                      pinned: false,
                      surfaceTintColor: Colors.transparent,
                      actions: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 5.0),
                          child: IconButton(
                            alignment: Alignment.center,
                            icon: SvgPicture.asset(
                              isBookmarked
                                  ? 'images/bookmarked.svg'
                                  : 'images/unmarked.svg',
                              width: 35,
                              height: 35,
                            ),
                            onPressed: () async {
                              if (isBookmarked) {
                                await _deleteBookmark();
                              } else {
                                await _createBookmark();
                              }
                            },
                          ),
                        ),
                      ],
                      leading: Container(
                        margin: EdgeInsets.only(left: 5.0),
                        child: IconButton(
                          icon: Image.asset(
                            'images/back_white_home.png',
                            width: 35,
                            height: 35,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        background: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: CachedNetworkImage(
                            imageUrl: image ?? '',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: AppColors.grey!,
                              highlightColor: AppColors.grey!,
                              child: Container(color: AppColors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ];
                },
            body: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: TabBar(
                    controller: tabController,
                    labelColor: AppColors.select_color,
                    unselectedLabelColor: Colors.white70,
                    indicatorColor: AppColors.select_color,
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(text: "Synopsis"),
                      Tab(text: "Chapters"),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      ListView(
                        padding: EdgeInsets.only(left: 12.0, right: 12.0),
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              'Title: $title',
                              style: GoogleFonts.robotoCondensed(
                                fontSize: 15.00,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              'Status: $status',
                              style: GoogleFonts.robotoCondensed(
                                fontSize: 15.00,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              'Genres: $genre',
                              style: GoogleFonts.robotoCondensed(
                                fontSize: 15.00,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              'Description: $mangaDesc',
                              style: GoogleFonts.robotoCondensed(
                                fontSize: 15.00,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ListView.builder(
                        itemCount: chapterList.length,
                        itemBuilder: (context, index) {
                          final String chapterId =
                              chapterList[index].getChapterId;
                          final String views = chapterList[index].getViews;
                          final String uploaded =
                              chapterList[index].getUploaded;
                          final String timestamp =
                              chapterList[index].getTimestamp;

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Imagelist(
                                    id: widget.id,
                                    chapterId: chapterId,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 5.0,
                                    top: 5.0,
                                  ),
                                  child: Text(
                                    'Chapter: $chapterId',
                                    style: GoogleFonts.robotoCondensed(
                                      fontSize: 15.00,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 5.0,
                                    top: 5.0,
                                  ),
                                  child: Text(
                                    'Views: $views',
                                    style: GoogleFonts.robotoCondensed(
                                      fontSize: 15.00,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 5.0,
                                    top: 5.0,
                                  ),
                                  child: Text(
                                    'Uploaded: $uploaded',
                                    style: GoogleFonts.robotoCondensed(
                                      fontSize: 15.00,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 5.0,
                                    top: 5.0,
                                  ),
                                  child: Text(
                                    'Timestamp: $timestamp',
                                    style: GoogleFonts.robotoCondensed(
                                      fontSize: 15.00,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: AppColors.white,
                                  thickness: 1,
                                  height: 2,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isMangaBookmarked(String mangaId) {
    final items = _hiveController.fetchData();
    return items.any((item) => item['id'] == mangaId);
  }

  int? _getBookmarkKey(String mangaId) {
    final items = _hiveController.fetchData();
    for (var item in items) {
      if (item['id'] == mangaId) {
        return item['key'];
      }
    }
    return null;
  }

  Future<void> _loadBookmarks() async {
    setState(() {
      isBookmarked = _isMangaBookmarked(widget.id ?? '');
    });
  }

  Future<void> _createBookmark() async {
    if (widget.id == null || title == null || image == null) return;

    final item = Item(
      title: title!,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      description: mangaDesc ?? '',
      id: widget.id!,
      imageUrl: image!,
    );

    await _hiveController.createItem(item: item);

    setState(() {
      isBookmarked = true;
    });
  }

  Future<void> _deleteBookmark() async {
    final key = _getBookmarkKey(widget.id ?? '');
    if (key != null) {
      await _hiveController.deleteItem(key: key);

      setState(() {
        isBookmarked = false;
      });
    }
  }
}
