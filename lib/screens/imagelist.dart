import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manga/colors/app_color.dart';
import 'package:manga/features/imagelistpage.dart';
import 'package:manga/providers/imageurldatanotifer.dart';
import 'package:manga/service/api_service.dart';
import 'package:manga/service/remote_data_source.dart';
import 'package:provider/provider.dart';

class Imagelist extends StatefulWidget {
  String? id;
  String? chapterId;
  Imagelist({super.key, required this.id, required this.chapterId});

  @override
  ImagelistpageState createState() => ImagelistpageState();
}

class ImagelistpageState extends State<Imagelist> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Imageurldatanotifer(
            remoteDataSource: RemoteDataSource(dio: ApiService().provideDio()),
          )..getImageQuery(widget.id.toString(), widget.chapterId.toString()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.background,
          title: SizedBox(
            width: double.infinity,
            height: 80.0,
            child: Stack(
              children: [
                Positioned(
                  left: 0.0,
                  top: 20.0,
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
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Free manga',
                      style: GoogleFonts.robotoCondensed(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Positioned(
                //   right: 0.0,
                //   top: 5.0,
                //   child: Consumer<RefreshNotifier>(
                //     builder: (context, refreshNotifier, child) {
                //       return IconButton(
                //         icon: SvgPicture.asset(
                //           'images/refresh.svg',
                //           width: 35,
                //           height: 35,
                //         ),
                //         onPressed: () {
                //           refreshNotifier.triggerRefresh();
                //         },
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
        body: ImagelistPage(),
      ),
    );
  }
}
