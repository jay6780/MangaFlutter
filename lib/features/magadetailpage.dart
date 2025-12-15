import 'package:flutter/material.dart';
import 'package:manga/colors/app_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:manga/providers/detaildatanotifier.dart';
import 'package:provider/provider.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class MangaDetailPage extends StatefulWidget {
  String? imageUrl;
  String? id;
  String? description;
  MangaDetailPage({
    super.key,
    required this.imageUrl,
    required this.id,
    required this.description,
  });

  @override
  MangaDetailPageState createState() => MangaDetailPageState();
}

class MangaDetailPageState extends State<MangaDetailPage> {
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
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 250,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 5),
                    child: IconButton(
                      icon: Image.asset(
                        'images/back_white_home.png',
                        width: 35,
                        height: 35,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.transparent,
                        shape: CircleBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
