import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

typedef Future<bool> OnNextPage(int nextPage);

class GridViewPagination extends StatefulWidget {
  final int itemCount;
  final double childAspectRatio;
  final OnNextPage onNextPage;
  final Widget Function(BuildContext context, int position) itemBuilder;
  final Widget Function(BuildContext context) progressBuilder;

  const GridViewPagination({
    required this.itemCount,
    required this.childAspectRatio,
    required this.itemBuilder,
    required this.onNextPage,
    required this.progressBuilder,
    Key? key,
  }) : super(key: key);

  @override
  _GridViewPaginationState createState() => _GridViewPaginationState();
}

class _GridViewPaginationState extends State<GridViewPagination> {
  int currentPage = 1;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification sn) {
        if (!isLoading &&
            sn is ScrollUpdateNotification &&
            sn.metrics.pixels == sn.metrics.maxScrollExtent) {
          setState(() {
            isLoading = true;
          });
          widget.onNextPage(currentPage++).then((bool isLoaded) {
            setState(() {
              isLoading = false;
            });
          });
        }
        return true;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GridView.custom(
              gridDelegate: SliverWovenGridDelegate.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                pattern: [
                  WovenGridTile(1),
                  WovenGridTile(
                    5 / 7,
                    crossAxisRatio: 0.9,
                    alignment: AlignmentDirectional.centerEnd,
                  ),
                ],
              ),
              childrenDelegate: SliverChildBuilderDelegate(
                (context, index) => widget.itemBuilder(context, index),
                childCount: widget.itemCount,
              ),
            ),
          ),
          if (isLoading)
            SizedBox(
              child: SpinKitThreeBounce(color: Colors.white, size: 30.0),
            ),
        ],
      ),
    );
  }
}
