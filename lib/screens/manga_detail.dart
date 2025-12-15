import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/web.dart';
import 'package:manga/colors/app_color.dart';
import 'package:manga/features/magadetailpage.dart';

import 'package:manga/providers/detaildatanotifier.dart';
import 'package:manga/service/api_service.dart';
import 'package:manga/service/remote_data_source.dart';
import 'package:provider/provider.dart';

class MangaDetail extends StatefulWidget {
  String? id;
  String? description;
  MangaDetail({super.key, required this.id, required this.description});

  @override
  MangaDetailState createState() => MangaDetailState();
}

class MangaDetailState extends State<MangaDetail> {
  var logger = Logger();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Detaildatanotifier(
            remoteDataSource: RemoteDataSource(dio: ApiService().provideDio()),
          ),
        ),
      ],

      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.background,
        body: MangaDetailPage(id: widget.id, description: widget.description),
      ),
    );
  }
}
