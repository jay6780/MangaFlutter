import 'package:flutter/material.dart';

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
      child: CustomScrollView(
        slivers: <Widget>[
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
              crossAxisCount: 2,
              childAspectRatio: widget.childAspectRatio,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => widget.itemBuilder(context, index),
              childCount: widget.itemCount,
            ),
          ),
          if (isLoading)
            SliverToBoxAdapter(child: widget.progressBuilder(context)),
        ],
      ),
    );
  }
}
