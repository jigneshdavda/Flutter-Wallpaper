import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class WallpaperDetail extends StatefulWidget {
  String imageURL;

  WallpaperDetail({Key key, @required this.imageURL}) : super(key: key);

  @override
  _WallpaperDetailState createState() => _WallpaperDetailState();
}

class _WallpaperDetailState extends State<WallpaperDetail> {
  String _wallpaperFile = 'Loading';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> setWallpaperFromURL(wallpaperImageURL) async {
    setState(() {
      _wallpaperFile = "Processing";
    });
    String result;
    var file = await DefaultCacheManager().getSingleFile(wallpaperImageURL);
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await WallpaperManager.setWallpaperFromFile(
          file.path, WallpaperManager.HOME_SCREEN);
    } on PlatformException {
      result = 'Failed to get wallpaper.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _wallpaperFile = result;
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(
          content: Text(_wallpaperFile),
          action: SnackBarAction(label: 'Ok', onPressed: (){
            _scaffoldKey.currentState.hideCurrentSnackBar();
          }),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 1,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              _scaffoldKey.currentState.showSnackBar(
                new SnackBar(
                  content: Text(_wallpaperFile),
                ),
              );
              setWallpaperFromURL(widget.imageURL);
            },
            child: Text(
              'SET WALLPAPER',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage(widget.imageURL),
          initialScale: PhotoViewComputedScale.covered,
          minScale: PhotoViewComputedScale.covered,
        ),
      ),
    );
  }
}
