import 'package:cached_network_image/cached_network_image.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:mazad/core/api_utils.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/data/models/user_home_model.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoGallery extends StatefulWidget {
  final List<Images> images;

  const PhotoGallery({Key key, this.images}) : super(key: key);
  @override
  _PhotoGalleryState createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  List<String> _imageUrls;
  List<PhotoViewGalleryPageOptions> imageViewList;
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    _imageUrls = widget.images == null
        ? []
        : List.generate(
            widget.images.length, (index) => widget.images[index].image);
    _imageUrls = _imageUrls.where((image) => image != null).toList();
    if (_imageUrls.isEmpty) _imageUrls = List.generate(3, (_) => null);//else _imageUrls.removeAt(0);
    imageViewList = List.generate(_imageUrls.length, (index) {
      return PhotoViewGalleryPageOptions(
          imageProvider:
              NetworkImage('${APIs.imageBaseUrl}${_imageUrls[index]}'),
          controller: photoViewCtrler);
    });

    super.initState();
  }

  PageController imageCtrler;
  PhotoViewController photoViewCtrler = PhotoViewController();

  @override
  Widget build(BuildContext context) {
    imageCtrler = PageController(initialPage: currentIndex);
    final size = MediaQuery.of(context).size;
    return Container(
      width: 1000,
      // height: 300,
      child: _imageUrls.isEmpty
          ? Container()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                    onTap: () =>
                        // showDialog(
                        //       context: context,
                        //       builder: (context) => Dialog(
                        //         backgroundColor: Colors.black.withOpacity(0.2),
                        //         child: ,
                        //       ),
                        //     ),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PhotoViewGallery(
                              pageOptions: imageViewList,
                              pageController: imageCtrler,
                            ),
                          ),
                        ),
                    child: buildImage(_imageUrls[currentIndex], false, true)),
                Container(
                  // width: 1000,
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: List.generate(
                      _imageUrls.length,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              currentIndex = index;
                              // imageCtrler.animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.easeInCubic);
                              // photoViewCtrler.initial = PhotoViewControllerValue(position: null, scale: null, rotation: null, rotationFocusPoint: null)
                              // photoViewCtrler.``
                            });
                          },
                          child: buildImage(
                              _imageUrls[index], currentIndex == index),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Widget buildImage(String imageUrl, bool isSelected,
      [bool isTitleImage = false]) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: isTitleImage ? size.width : size.width / 3.7,
          color: isSelected ? Colors.amber : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: ColorsD.main,
                height: size.height / 4,
                width: size.width * 0.5,
                child: imageUrl == null
                    ? noImageWidget()
                    : CachedNetworkImage(
                        imageUrl: '${APIs.imageBaseUrl}$imageUrl',
                        height: size.height / 4,
                        width: size.width * 0.5,
                        imageBuilder: (context, imageB) => Container(
                          height: size.height / 4,
                          width: size.width * 0.5,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageB, fit: BoxFit.cover)),
                        ),
                        placeholder: (context, imageStr) =>
                            imageStr.toString().contains('null')
                                ? noImageWidget()
                                : WaitingWidget(color: Colors.white,),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget noImageWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.warning,
            color: Colors.white,
          ),
          Txt('لا توجد صورة',
              style: TxtStyle()
                ..textColor(Colors.white)
                ..textAlign.center())
        ],
      ),
    );
  }
}
