import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manga/providers/Genrequerynotifier.dart';
import 'package:manga/features/manga_page.dart';
import '../colors/app_color.dart';
import '../providers/genrenamenotifier.dart';
import '../providers/mangalistnotifier.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga/providers/refresh_notifier.dart';

class GenrePage extends StatefulWidget {
  const GenrePage({super.key});
  @override
  State<GenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  int _selectedIndex = 0;
  String genrename = "All";
  late Logger logger;
  final ScrollController _scrollController = ScrollController();
  final queryController = TextEditingController();
  String? enteredText = "";
  @override
  void initState() {
    super.initState();
    logger = Logger();
  }

  @override
  void dispose() {
    Provider.of<RefreshNotifier>(context, listen: false).dispose();
    Provider.of<Genrenamenotifier>(context, listen: false).dispose();
    _scrollController.dispose();
    queryController.dispose();
    super.dispose();
  }

  void _handleRefresh() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    setState(() {
      _selectedIndex = 0;
      genrename = "All";
      queryController.clear();
    });
    context.read<Genrequerynotifier>().selectGenre(genrename);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final refreshNotifier = context.watch<RefreshNotifier>();

    if (refreshNotifier.shouldRefresh) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<RefreshNotifier>(context, listen: false).resetRefresh();
        _handleRefresh();
      });
    }
    return Container(
      color: AppColors.background,
      child: Consumer<Genrenamenotifier>(
        builder: (context, value, child) {
          if (value.uiState == UiState.loading) {
            return const Center(
              child: DecoratedBox(
                decoration: BoxDecoration(color: AppColors.background),
              ),
            );
          } else if (value.uiState == UiState.error) {
            logger.e('error: ', error: value.message.toString());
            return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Failed to load data',
                        style: GoogleFonts.robotoCondensed(
                          fontSize: 15.00,
                          color: AppColors.onBackground,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<RefreshNotifier>(
                          context,
                          listen: false,
                        ).triggerRefresh();
                      },
                      child: Text(
                        'Retry',
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
            );
          }
          return Scaffold(
            backgroundColor: AppColors.background,
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        backgroundColor: AppColors.background,
                        automaticallyImplyLeading: false,
                        expandedHeight: 60,
                        floating: false,
                        pinned: false,
                        surfaceTintColor: Colors.transparent,

                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            color: AppColors.background,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.only(
                                      start: 10.0,
                                      end: 10.0,
                                    ),
                                    child: TextField(
                                      controller: queryController,
                                      cursorColor: AppColors.white,
                                      style: TextStyle(color: AppColors.white),
                                      onTapOutside: (PointerDownEvent event) {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Enter manga name',
                                        hintStyle: TextStyle(
                                          color: AppColors.white,
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.white,
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.white,
                                            width: 2.0,
                                          ),
                                        ),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.only(
                                    start: 10.0,
                                    top: 20.0,
                                    end: 10.0,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      String enteredText = queryController.text;
                                      if (enteredText.isEmpty) {
                                        const snackBar = SnackBar(
                                          content: Text(
                                            'Please enter manga name!',
                                          ),
                                          duration: Duration(seconds: 1),
                                        );
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(snackBar);
                                        return;
                                      }

                                      // Update the provider state
                                      Provider.of<Mangalistnotifier>(
                                        context,
                                        listen: false,
                                      ).fetchMangaList(
                                        enteredText.trim(),
                                        1,
                                        true,
                                        true,
                                      );

                                      print("Sidebox tapped! $enteredText");
                                    },
                                    child: Container(
                                      width: 35.00,
                                      height: 35.00,
                                      child: SvgPicture.asset(
                                        'images/send.svg',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
              body: Container(
                color: AppColors.background,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Genre options',
                        style: GoogleFonts.robotoCondensed(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),

                    NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        return false;
                      },
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(value.genrenameList.length, (
                            index,
                          ) {
                            final isSelected = _selectedIndex == index;
                            return GestureDetector(
                              onTap: () {
                                final newGenre = value.genrenameList[index];
                                logger.d("genrename: $newGenre");

                                context.read<Genrequerynotifier>().selectGenre(
                                  newGenre,
                                );

                                setState(() {
                                  genrename = newGenre;
                                  _selectedIndex = index;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.select_color
                                      : AppColors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Center(
                                  child: Text(
                                    value.genrenameList[index],
                                    style: GoogleFonts.robotoCondensed(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? AppColors.white
                                          : AppColors.onBackground,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    Expanded(child: MangaPage()),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
