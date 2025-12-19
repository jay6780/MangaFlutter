import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manga/colors/app_color.dart';
import 'package:manga/providers/Genrequerynotifier.dart';
import 'package:manga/providers/refresh_notifier.dart';
import 'package:manga/features/gridview_pagination.dart';
import 'package:flutter/material.dart';
import 'package:manga/providers/mangalistnotifier.dart';
import 'package:manga/screens/manga_detail.dart';
import 'package:manga/utils/toast.dart';
import 'package:provider/provider.dart';
import 'package:manga/models/manga_bean.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class MangaPage extends StatefulWidget {
  @override
  MangaPageState createState() => MangaPageState();
}

class MangaPageState extends State<MangaPage> {
  String genrename = "";
  bool isRefresh = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<Mangalistnotifier>(context, listen: false).dispose();
    Provider.of<RefreshNotifier>(context, listen: false).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<RefreshNotifier>().shouldRefresh;
    genrename = context
        .watch<Genrequerynotifier>()
        .selectedGenre
        .toString()
        .trim()
        .toLowerCase();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Mangalistnotifier>(
        context,
        listen: false,
      ).fetchMangaList(genrename, 1, true, false);
    });

    return Consumer<Mangalistnotifier>(
      builder: (context, notifier, child) {
        if (notifier.uiState == UimangaState.loading &&
            notifier.manga.isEmpty) {
          return Center(
            child: SpinKitThreeBounce(color: AppColors.white, size: 30.0),
          );
        } else if (notifier.uiState == UimangaState.error) {
          toastInfo(msg: 'No more', status: Status.error);
          _grid_layout(notifier, context, genrename, false);
        }
        return _grid_layout(notifier, context, genrename, true);
      },
    );
  }
}

Future<void> _RefreshData(BuildContext context) async {
  try {
    await Provider.of<Mangalistnotifier>(
      context,
      listen: false,
    ).fetchMangaList("All", 1, true, false);
  } catch (e) {
    print('Refresh error: $e');
  }
}

Future<bool> _loadPage(
  BuildContext context,
  int page,
  String genrename,
  bool isPaginate,
) async {
  try {
    final notifier = context.read<Mangalistnotifier>();
    if (notifier.searchQuery != null) {
      return false;
    }
    if (isPaginate) {}
    await notifier.fetchMangaList(
      genrename.toLowerCase().isEmpty ? "All" : genrename.toLowerCase(),
      page,
      false,
      false,
    );

    return notifier.hasMore;
  } catch (e) {
    print('Error loading page $page: $e');
    return false;
  }
}

Widget _grid_layout(
  Mangalistnotifier notifier,
  BuildContext context,
  String genrename,
  bool isPaginate,
) {
  return GridViewPagination(
    itemCount: notifier.manga.length,
    childAspectRatio: 1,
    itemBuilder: (context, index) =>
        _buildMangaCard(context, notifier.manga[index]),
    onNextPage: (int nextPage) {
      return _loadPage(context, nextPage, genrename, isPaginate);
    },
    progressBuilder: (context) => Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(AppColors.white),
      ),
    ),
  );
}

Widget _buildMangaCard(BuildContext context, Manga manga) {
  return GestureDetector(
    onTap: () {
      final String id = manga.getId;

      final String description = manga.getDescription?.isEmpty ?? true
          ? ""
          : manga.getDescription;
      // print('Details: , image:, $imageUrl, id: , $id');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MangaDetail(id: id, description: description),
        ),
      );
    },
    child: Card(
      elevation: 50,
      shadowColor: AppColors.onBackground,
      color: AppColors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7.0),
              child: CachedNetworkImage(
                imageUrl: manga.getImage?.isEmpty ?? true
                    ? manga.getImgUrl
                    : manga.getImage!,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: AppColors.grey!,
                  highlightColor: AppColors.grey!,
                  child: Container(color: AppColors.white),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              manga.getTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
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
