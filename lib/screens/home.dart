import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manga/providers/Genrequerynotifier.dart';

import '../colors/app_color.dart';
import '../service/remote_data_source.dart';
import '../service/api_service.dart';
import '../providers/genrenamenotifier.dart';
import '../providers/mangalistnotifier.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/refresh_notifier.dart';
import 'package:manga/features/genre_page.dart';
import 'package:manga/features/nav_bar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Free manga';

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Mangalistnotifier(
            remoteDataSource: RemoteDataSource(dio: ApiService().provideDio()),
          ),
        ),
        ChangeNotifierProvider(create: (context) => RefreshNotifier()),
        ChangeNotifierProvider(create: (context) => Genrequerynotifier()),
        ChangeNotifierProvider(
          create: (context) => Genrenamenotifier(
            remoteDataSource: RemoteDataSource(dio: ApiService().provideDio()),
          )..fetchGenrelist(),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          drawer: const NavBar(),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.background,
            title: SizedBox(
              width: double.infinity,
              height: 50.0,
              child: Stack(
                children: [
                  Positioned(
                    left: 0.0,
                    top: 5.0,
                    child: Builder(
                      builder: (BuildContext context) {
                        return IconButton(
                          icon: SvgPicture.asset(
                            'images/menu.svg',
                            width: 35,
                            height: 35,
                          ),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          tooltip: MaterialLocalizations.of(
                            context,
                          ).openAppDrawerTooltip,
                        );
                      },
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Text(
                        appTitle,
                        style: GoogleFonts.robotoCondensed(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    top: 5.0,
                    child: Consumer<RefreshNotifier>(
                      builder: (context, refreshNotifier, child) {
                        return IconButton(
                          icon: SvgPicture.asset(
                            'images/refresh.svg',
                            width: 35,
                            height: 35,
                          ),
                          onPressed: () {
                            refreshNotifier.triggerRefresh();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: const GenrePage(),
        ),
      ),
    );
  }
}
