import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manga/providers/notifiers/Genrequerynotifier.dart';
import 'package:manga/widgets/gridview_pagination.dart';
import '../providers/remote_data_source.dart';
import 'package:flutter/material.dart';
import 'package:manga/providers/notifiers/mangalistnotifier.dart';
import 'package:provider/provider.dart';
import '../Service/api_service.dart';
import 'package:manga/Beans/manga_bean.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class MangaPage extends StatefulWidget {
  @override
  MangaPageState createState() => MangaPageState();
}

class MangaPageState extends State<MangaPage> {
  String genrename = "";

  @override
  void dispose() {
    Provider.of<Genrequerynotifier>(context, listen: false);
    Provider.of<Mangalistnotifier>(context, listen: false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    genrename = context
        .watch<Genrequerynotifier>()
        .selectedGenre
        .toString()
        .trim()
        .toLowerCase();

    return MultiProvider(
      key: Key(genrename),
      providers: [
        ChangeNotifierProvider(create: (context) => Genrequerynotifier()),
        ChangeNotifierProvider(
          create: (_) =>
              Mangalistnotifier(
                remoteDataSource: RemoteDataSource(
                  dio: ApiService().provideDio(),
                ),
              )..fetchMangaList(
                genrename.toLowerCase().isEmpty
                    ? "All"
                    : genrename.toLowerCase(),
                1,
                true,
                false,
              ),
        ),
      ],
      child: Consumer<Mangalistnotifier>(
        builder: (context, notifier, child) {
          if (notifier.uiState == UimangaState.loading &&
              notifier.manga.isEmpty) {
            return Center(
              child: SpinKitThreeBounce(color: Colors.white, size: 30.0),
            );
          } else if (notifier.uiState == UimangaState.error &&
              notifier.manga.isEmpty) {
            Provider.of<Mangalistnotifier>(context, listen: false);
            return Center(
              child: Text(
                'Error loading data',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            return GridViewPagination(
              itemCount: notifier.manga.length,
              childAspectRatio: 1,
              itemBuilder: (context, index) =>
                  _buildMangaCard(context, notifier.manga[index]),
              onNextPage: (int nextPage) {
                return _loadPage(context, nextPage, genrename);
              },
              progressBuilder: (context) => Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

Future<bool> _loadPage(BuildContext context, int page, String genrename) async {
  try {
    final notifier = context.read<Mangalistnotifier>();
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

Widget _buildMangaCard(BuildContext context, Manga manga) {
  return Card(
    elevation: 50,
    shadowColor: Colors.black,
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7.0),
            child: CachedNetworkImage(
              imageUrl: manga.getImage.isEmpty
                  ? manga.getImgUrl
                  : manga.getImage,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(color: Colors.white),
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
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
