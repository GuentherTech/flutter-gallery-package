import 'package:flutter/material.dart';
import 'package:galleryimage/app_cached_network_image.dart';

import 'gallery_item_model.dart';

// to view image in full screen
class GalleryImageViewWrapper extends StatefulWidget {
  final Color? backgroundColor;
  final int? initialIndex;
  final void Function(int)? onPageChanged;
  final List<GalleryItemModel> galleryItems;
  final String? titleGallery;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final double minScale;
  final double maxScale;
  final double radius;
  final bool reverse;
  final bool showListInGalley;
  final bool showAppBar;
  final List<Widget>? appBarActions;
  final bool closeWhenSwipeUp;
  final bool closeWhenSwipeDown;

  const GalleryImageViewWrapper({
    super.key,
    required this.titleGallery,
    required this.backgroundColor,
    required this.initialIndex,
    required this.onPageChanged,
    required this.galleryItems,
    required this.loadingWidget,
    required this.errorWidget,
    required this.minScale,
    required this.maxScale,
    required this.radius,
    required this.reverse,
    required this.showListInGalley,
    required this.showAppBar,
    required this.appBarActions,
    required this.closeWhenSwipeUp,
    required this.closeWhenSwipeDown,
  });

  @override
  State<StatefulWidget> createState() {
    return _GalleryImageViewWrapperState();
  }
}

class _GalleryImageViewWrapperState extends State<GalleryImageViewWrapper> {
  late final PageController _controller =
      PageController(initialPage: widget.initialIndex ?? 0);
  int _currentPage = 0;

  @override
  void initState() {
    _currentPage = widget.initialIndex ?? 0;
    widget.onPageChanged?.call(_currentPage);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(widget.titleGallery ?? "Gallery"),
              actions: widget.appBarActions,
            )
          : null,
      backgroundColor: widget.backgroundColor,
      body: SafeArea(
        child: Container(
          constraints:
              BoxConstraints.expand(height: MediaQuery.of(context).size.height),
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onVerticalDragEnd: (details) {
                    if (widget.closeWhenSwipeUp &&
                        details.primaryVelocity! < 0) {
                      //'up'
                      Navigator.of(context).pop();
                    }
                    if (widget.closeWhenSwipeDown &&
                        details.primaryVelocity! > 0) {
                      // 'down'
                      Navigator.of(context).pop();
                    }
                  },
                  child: PageView.builder(
                    reverse: widget.reverse,
                    controller: _controller,
                    itemCount: widget.galleryItems.length,
                    itemBuilder: (context, index) =>
                        _buildImage(widget.galleryItems[index]),
                    onPageChanged: (index) {
                      widget.onPageChanged?.call(index);
                      setState(() {
                        _currentPage = index;
                      });
                    },
                  ),
                ),
              ),
              if (widget.showListInGalley)
                SizedBox(
                  height: 80,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: widget.galleryItems
                          .map((e) => _buildLitImage(e))
                          .toList(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

// build image with zooming
  Widget _buildImage(GalleryItemModel item) {
    return Hero(
      tag: item.id,
      child: InteractiveViewer(
        minScale: widget.minScale,
        maxScale: widget.maxScale,
        child: Center(
          child: AppCachedNetworkImage(
            imageUrl: item.imageUrl,
            httpHeaders: item.httpHeaders,
            loadingWidget: widget.loadingWidget,
            errorWidget: widget.errorWidget,
            radius: widget.radius,
          ),
        ),
      ),
    );
  }

// build image with zooming
  Widget _buildLitImage(GalleryItemModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _controller.jumpToPage(item.index);
          });
        },
        child: AppCachedNetworkImage(
          height: _currentPage == item.index ? 70 : 60,
          width: _currentPage == item.index ? 70 : 60,
          fit: BoxFit.cover,
          imageUrl: item.imageUrl,
          httpHeaders: item.httpHeaders,
          errorWidget: widget.errorWidget,
          radius: widget.radius,
          loadingWidget: widget.loadingWidget,
        ),
      ),
    );
  }
}
