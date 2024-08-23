library galleryimage;

import 'package:flutter/material.dart';

import './gallery_image_view_wrapper.dart';
import './util.dart';
import 'gallery_item_model.dart';
import 'gallery_item_thumbnail.dart';

class GalleryImage extends StatefulWidget {
  final List<String> imageUrls;
  final void Function(int)? onPageChanged;
  final Map<String, String>? httpHeaders;
  final String? titleGallery;
  final int numOfShowImages;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final EdgeInsetsGeometry padding;
  final Color? colorOfNumberWidget;
  final Color galleryBackgroundColor;
  final TextStyle? textStyleOfNumberWidget;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final double minScale;
  final double maxScale;
  final double imageRadius;
  final bool reverse;
  final bool showListInGalley;
  final bool showAppBar;
  final List<Widget>? appBarActions;
  final bool closeWhenSwipeUp;
  final bool closeWhenSwipeDown;

  final bool showTitleImage;
  final double? titleImageWidth;
  final double? titleImageHeight;
  final bool showFullScreen;
  final int initialIndex;

  final double gridHorizontalSpacing;
  final double gridVerticalSpacing;
  final int gridColumns;
  final BorderRadius thumbnailBorderRadius;

  const GalleryImage({
    super.key,
    required this.imageUrls,
    this.onPageChanged,
    this.httpHeaders,
    this.titleGallery,
    this.childAspectRatio = 1,
    this.crossAxisCount = 3,
    this.mainAxisSpacing = 5,
    this.crossAxisSpacing = 5,
    this.numOfShowImages = 3,
    this.colorOfNumberWidget,
    this.textStyleOfNumberWidget,
    this.padding = EdgeInsets.zero,
    this.loadingWidget,
    this.errorWidget,
    this.galleryBackgroundColor = Colors.black,
    this.minScale = .5,
    this.maxScale = 10,
    this.imageRadius = 8,
    this.reverse = false,
    this.showListInGalley = true,
    this.showAppBar = true,
    this.appBarActions,
    this.closeWhenSwipeUp = false,
    this.closeWhenSwipeDown = false,
    this.showTitleImage = false,
    this.titleImageWidth,
    this.titleImageHeight,
    this.gridHorizontalSpacing = 5,
    this.gridVerticalSpacing = 5,
    this.gridColumns = 3,
    this.thumbnailBorderRadius = const BorderRadius.all(Radius.circular(8)),
    this.showFullScreen = false,
    this.initialIndex = 0,
  }) : assert(numOfShowImages <= imageUrls.length);
  @override
  State<GalleryImage> createState() => _GalleryImageState();
}

class _GalleryImageState extends State<GalleryImage> {
  List<GalleryItemModel> galleryItems = <GalleryItemModel>[];

  @override
  void initState() {
    _buildItemsList(widget.imageUrls, widget.httpHeaders);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GalleryImage oldWidget) {
    _buildItemsList(widget.imageUrls, widget.httpHeaders);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return galleryItems.isEmpty
        ? const EmptyWidget()
        : (widget.showFullScreen
            ? GalleryImageViewWrapper(
                titleGallery: widget.titleGallery,
                galleryItems: galleryItems,
                backgroundColor: widget.galleryBackgroundColor,
                initialIndex: widget.initialIndex,
                onPageChanged: widget.onPageChanged,
                loadingWidget: widget.loadingWidget,
                errorWidget: widget.errorWidget,
                maxScale: widget.maxScale,
                minScale: widget.minScale,
                reverse: widget.reverse,
                showListInGalley: widget.showListInGalley,
                showAppBar: widget.showAppBar,
                appBarActions: widget.appBarActions,
                closeWhenSwipeUp: widget.closeWhenSwipeUp,
                closeWhenSwipeDown: widget.closeWhenSwipeDown,
                radius: widget.imageRadius,
              )
            : GridView.builder(
                primary: false,
                itemCount: galleryItems.length > 3
                    ? widget.numOfShowImages
                    : galleryItems.length,
                padding: widget.padding,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: widget.childAspectRatio,
                  crossAxisCount: widget.crossAxisCount,
                  mainAxisSpacing: widget.mainAxisSpacing,
                  crossAxisSpacing: widget.crossAxisSpacing,
                ),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return _isLastItem(index)
                      ? _buildImageNumbers(index)
                      : GalleryItemThumbnail(
                          galleryItem: galleryItems[index],
                          onTap: () {
                            _openImageFullScreen(index);
                          },
                          loadingWidget: widget.loadingWidget,
                          errorWidget: widget.errorWidget,
                          radius: widget.imageRadius,
                        );
                }));
  }

// build image with number for other images
  Widget _buildImageNumbers(int index) {
    return GestureDetector(
      onTap: () {
        _openImageFullScreen(index);
      },
      child: Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.expand,
        children: <Widget>[
          GalleryItemThumbnail(
            galleryItem: galleryItems[index],
            loadingWidget: widget.loadingWidget,
            errorWidget: widget.errorWidget,
            onTap: null,
            radius: widget.imageRadius,
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(widget.imageRadius)),
            child: ColoredBox(
              color: widget.colorOfNumberWidget ?? Colors.black.withOpacity(.7),
              child: Center(
                child: Text(
                  "+${galleryItems.length - index}",
                  style: widget.textStyleOfNumberWidget ??
                      const TextStyle(color: Colors.white, fontSize: 40),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// Check if item is last image in grid to view image or number
  bool _isLastItem(int index) {
    return index < galleryItems.length - 1 &&
        index == widget.numOfShowImages - 1;
  }

// to open gallery image in full screen
  Future<void> _openImageFullScreen(int indexOfImage) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryImageViewWrapper(
          titleGallery: widget.titleGallery,
          galleryItems: galleryItems,
          backgroundColor: widget.galleryBackgroundColor,
          initialIndex: indexOfImage,
          onPageChanged: widget.onPageChanged,
          loadingWidget: widget.loadingWidget,
          errorWidget: widget.errorWidget,
          maxScale: widget.maxScale,
          minScale: widget.minScale,
          reverse: widget.reverse,
          showListInGalley: widget.showListInGalley,
          showAppBar: widget.showAppBar,
          appBarActions: widget.appBarActions,
          closeWhenSwipeUp: widget.closeWhenSwipeUp,
          closeWhenSwipeDown: widget.closeWhenSwipeDown,
          radius: widget.imageRadius,
        ),
      ),
    );
  }

// clear and build list
  void _buildItemsList(List<String> items, Map<String, String>? httpHeaders) {
    galleryItems.clear();
    for (var item in items) {
      galleryItems.add(
        GalleryItemModel(
            id: item,
            imageUrl: item,
            httpHeaders: httpHeaders,
            index: items.indexOf(item)),
      );
    }
  }
}
