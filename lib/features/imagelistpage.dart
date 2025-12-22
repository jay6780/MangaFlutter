import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manga/colors/app_color.dart';
import 'package:manga/providers/imageurldatanotifer.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ImagelistPage extends StatefulWidget {
  ImagelistPage({super.key});
  @override
  ImagelistPageState createState() => ImagelistPageState();
}

class ImagelistPageState extends State<ImagelistPage> {
  final ScrollController _controller = ScrollController();

  // void _scrollRecyclerViewBy(double pixels) {
  //   if (!_controller.hasClients) return;

  //   final currentOffset = _controller.offset;
  //   final newOffset = currentOffset + pixels;

  //   _controller.animateTo(
  //     newOffset.clamp(0.0, _controller.position.maxScrollExtent),
  //     duration: const Duration(milliseconds: 300),
  //     curve: Curves.easeInOut,
  //   );
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            panEnabled: true,
            boundaryMargin: EdgeInsets.all(0),
            minScale: 1.0,
            maxScale: 20.0,
            child: CustomScrollView(
              controller: _controller,
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0),
                      child: CachedNetworkImage(
                        imageUrl: value.imageUrls[index],
                        placeholder: (context, url) => SizedBox(
                          height: 500,
                          child: Shimmer.fromColors(
                            baseColor: AppColors.grey!,
                            highlightColor: AppColors.grey!,
                            child: Container(color: AppColors.white),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.contain,
                        width: MediaQuery.of(context).size.width,
                      ),
                    );
                  }, childCount: value.imageUrls.length),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
