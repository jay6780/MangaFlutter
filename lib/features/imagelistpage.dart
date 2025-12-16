import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:manga/colors/app_color.dart';
import 'package:manga/providers/imageurldatanotifer.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ImagelistPage extends StatelessWidget {
  ImagelistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<Imageurldatanotifer>(
        builder: (context, value, child) {
          if (value.uiState == UiState.loading) {
            return const Center(
              child: SpinKitThreeBounce(color: AppColors.white, size: 30.0),
            );
          } else if (value.uiState == UiState.error) {
            return Center(
              child: Text(
                'Failed to load image',
                style: GoogleFonts.robotoCondensed(
                  fontSize: 15.00,
                  color: AppColors.white,
                ),
              ),
            );
          }

          return InteractiveViewer(
            panEnabled: true, // Set it to false to prevent panning.
            boundaryMargin: EdgeInsets.all(0),
            minScale: 1.0,
            maxScale: 20.0,
            child: ListView.builder(
              itemCount: value.imageUrls.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                    child: CachedNetworkImage(
                      imageUrl: value.imageUrls[index],
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: AppColors.grey!,
                        highlightColor: AppColors.grey!,
                        child: Container(color: AppColors.white),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
