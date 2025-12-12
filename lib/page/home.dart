import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manga/providers/notifiers/Genrequerynotifier.dart';
import 'package:manga/page/manga_page.dart';
import '../colors/app_color.dart';
import '../providers/remote_data_source.dart';
import '../Service/api_service.dart';
import '../providers/notifiers/genrenamenotifier.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Free manga';
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Genrequerynotifier()),
        ChangeNotifierProvider(
          create: (_) => Genrenamenotifier(
            remoteDataSource: RemoteDataSource(dio: ApiService().provideDio()),
          )..fetchGenrelist(),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: AppColors.background,
            title: Text(
              appTitle,
              style: GoogleFonts.robotoCondensed(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          body: const GenrePage(),
        ),
      ),
    );
  }
}

class GenrePage extends StatefulWidget {
  const GenrePage({super.key});
  @override
  State<GenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  int _selectedIndex = 0;
  String genrename = "All";
  late Logger logger;

  @override
  void initState() {
    super.initState();
    logger = Logger();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Consumer<Genrenamenotifier>(
        builder: (context, value, child) {
          if (value.uiState == UiState.loading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            );
          } else if (value.uiState == UiState.error) {
            logger.e('error: ', error: value.message.toString());
            return Center(
              child: Text(
                'Error: ${value.message}',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return Container(
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
                      color: Colors.white,
                    ),
                  ),
                ),
                SingleChildScrollView(
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
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.select_color
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Center(
                            child: Text(
                              value.genrenameList[index],
                              style: GoogleFonts.robotoCondensed(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(child: MangaPage()),
              ],
            ),
          );
        },
      ),
    );
  }
}
