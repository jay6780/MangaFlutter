import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:manga/colors/app_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:manga/models/Item.dart';
import 'package:manga/providers/ascnotifier.dart';
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
  bool isBookmarked = false;
  bool isVisible = true;

  List<Chapters> chapterList = [];
  List<String> genres = [];
  String? genre;
  var logger = Logger();
  late HiveController _hiveController;

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 2);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Detaildatanotifier>(
        context,
        listen: false,
      ).getDetailData(widget.id.toString());
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
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

  void fetchData(DetailBean detailBean) {
    image = detailBean.getImageUrl;
    title = detailBean.getTitle;
    status = detailBean.getStatus;
    mangaDesc = widget.description;

    genres.clear();
    chapterList.clear();

    genres.addAll(detailBean.getGenres);
    chapterList.addAll(detailBean.chapters);

    genre = genres.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    bool isAsc = false;

    isAsc = context.watch<Ascnotifier>().shouldRefresh;
    // print('isAsc: $isAsc');
    return Consumer<Detaildatanotifier>(
      builder: (context, value, child) {
        if (value.uiState == UiState.loading) {
          return const Center(
            child: SpinKitThreeBounce(color: AppColors.white, size: 30.0),
          );
        } else if (value.uiState == UiState.error) {
          return Center(
            child: Text(
              value.message.toString(),
              style: GoogleFonts.robotoCondensed(
                fontSize: 20.00,
                color: AppColors.white,
              ),
            ),
          );
        }

        if (value.detailbeanList.isNotEmpty) {
          fetchData(value.detailbeanList.first);
        }

        if (isAsc) {
          chapterList.sort((a, b) {
            final aNum = int.tryParse(a.getChapterId.split('-').first) ?? 0;
            final bNum = int.tryParse(b.getChapterId.split('-').first) ?? 0;
            return aNum.compareTo(bNum);
          });
        } else {
          chapterList.sort((b, a) {
            final aNum = int.tryParse(b.getChapterId.split('-').first) ?? 0;
            final bNum = int.tryParse(a.getChapterId.split('-').first) ?? 0;
            return bNum.compareTo(aNum);
          });
        }

        chapterList.length < 5 ? isVisible = false : isVisible = true;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      backgroundColor: AppColors.background,
                      automaticallyImplyLeading: false,
                      expandedHeight: 300.0,
                      floating: false,
                      pinned: false,
                      surfaceTintColor: Colors.transparent,
                      actions: <Widget>[
                        IconButton(
                          icon: SvgPicture.asset(
                            isBookmarked
                                ? 'images/bookmarked.svg'
                                : 'images/unmarked.svg',
                            width: 35,
                            height: 35,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.transparent,
                            shape: CircleBorder(),
                          ),
                          onPressed: () async {
                            if (isBookmarked) {
                              await _deleteBookmark();
                            } else {
                              await _createBookmark();
                            }
                          },
                        ),
                      ],
                      leading: IconButton(
                        icon: Image.asset(
                          'images/back_white_home.png',
                          width: 35,
                          height: 35,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.transparent,
                          shape: CircleBorder(),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
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
                                fontSize: 13.00,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              'Genres: $genre',
                              style: GoogleFonts.robotoCondensed(
                                fontSize: 13.00,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              'Description: $mangaDesc',
                              style: GoogleFonts.robotoCondensed(
                                fontSize: 13.00,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Container(
                              margin: EdgeInsets.only(top: 20.0, bottom: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Visibility(
                                    visible: isVisible,
                                    child: GestureDetector(
                                      onTap: () async {
                                        desc();
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 15.0),
                                        child: Text(
                                          'Descending',
                                          style: GoogleFonts.robotoCondensed(
                                            fontSize: 16.00,
                                            color: isAsc
                                                ? AppColors.white
                                                : AppColors.select_color,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: isVisible,
                                    child: GestureDetector(
                                      onTap: () async {
                                        asc();
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(left: 15.0),
                                        child: Text(
                                          'Ascending',
                                          style: GoogleFonts.robotoCondensed(
                                            fontSize: 16.00,
                                            color: !isAsc
                                                ? AppColors.white
                                                : AppColors.select_color,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
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
                            }, childCount: chapterList.length),
                          ),
                        ],
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
    try {
      final items = _hiveController.fetchData();

      if (mounted) {
        setState(() {
          isBookmarked = _isMangaBookmarked(widget.id ?? '');
        });
      }
    } catch (e) {
      print('Error loading bookmarks: $e');
    }
  }

  Future<void> asc() async {
    Provider.of<Ascnotifier>(context, listen: false).isAsc();
  }

  Future<void> desc() async {
    Provider.of<Ascnotifier>(context, listen: false).isDesc();
  }

  Future<void> _createBookmark() async {
    if (widget.id == null || title == null || image == null) return;

    final item = Item(
      title: title!,
      description: mangaDesc ?? '',
      id: widget.id!,
      imageUrl: image!,
    );

    await _hiveController.createItem(item: item);

    if (mounted) {
      setState(() {
        isBookmarked = true;
      });
    }
  }

  Future<void> _deleteBookmark() async {
    final key = _getBookmarkKey(widget.id ?? '');
    if (key != null) {
      await _hiveController.deleteItem(key: key);

      if (mounted) {
        setState(() {
          isBookmarked = false;
        });
      }
    }
  }
}
