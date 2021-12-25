import 'dart:developer' as developer;

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:studio/models/Models.dart';
import 'package:studio/screens/ListingScreen.dart';
import 'package:studio/utils/AppColors.dart';
import 'package:studio/utils/AppConstant.dart';
import 'package:studio/utils/AppImages.dart';
import 'package:studio/utils/AppStrings.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

Widget text(var text,
    {var fontSize = textSizeLargeMedium,
    textColor = PrimaryColor,
    var fontFamily = fontRegular,
    var isCentered = false,
    var maxLine = 1,
    var latterSpacing = 0.5,
    overflow: Overflow}) {
  return Text(text,
      textAlign: isCentered ? TextAlign.center : TextAlign.start,
      maxLines: maxLine,
      style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          color: textColor,
          height: 1.5,
          letterSpacing: latterSpacing));
}

//-------------------------------------------Button-------------------------------------------------------------------------

SizedBox buttonStyle(var text) {
  return SizedBox(
      width: double.infinity,
      height: 60,
      child: MaterialButton(
        child: Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
        textColor: WhiteColor,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(40.0)),
        color: PrimaryColor,
        onPressed: () => {},
      ));
}

Text subHeadingText(var text) {
  return Text(
    text,
    style: TextStyle(
        fontFamily: fontBold, fontSize: 17.5, color: appTextColorSecondary),
  );
}

changeStatusColor(Color color) async {
  try {
    await FlutterStatusbarcolor.setStatusBarColor(color, animate: true);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(
        useWhiteForeground(color));
  } on Exception catch (e) {
    print(e);
  }
}

showToast(BuildContext aContext, String caption) {
  Scaffold.of(aContext).showSnackBar(
      SnackBar(content: text(caption, textColor: appWhite, isCentered: true)));
}

launchScreen(context, String tag, {Object arguments}) {
  if (arguments == null) {
    Navigator.pushNamed(context, tag);
  } else {
    Navigator.pushNamed(context, tag, arguments: arguments);
  }
}

BoxDecoration boxDecoration(
    {double radius = 2,
    Color color = Colors.transparent,
    Color bgColor = appWhite,
    var showShadow = false}) {
  return BoxDecoration(
    color: bgColor,
    boxShadow: showShadow
        ? [BoxShadow(color: shadowColorGlobal, blurRadius: 5, spreadRadius: 1)]
        : [BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

class VideoItems extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final bool autoplay;

  VideoItems({
    @required this.videoPlayerController,
    this.looping,
    this.autoplay,
    Key key,
  }) : super(key: key);

  @override
  _VideoItemsState createState() => _VideoItemsState();
}

class _VideoItemsState extends State<VideoItems> {
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      autoInitialize: true,
      autoPlay: widget.autoplay,
      looping: widget.looping,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController.dispose();
  }
}

class ThemeList extends StatefulWidget {
  List<ProTheme> list;
  BuildContext mContext;

  ThemeList(this.list, this.mContext);

  @override
  ThemeListState createState() => ThemeListState();
}

class ThemeListState extends State<ThemeList> {
  List<Color> colors = [appCat1, appCat2, appCat3];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return AnimationLimiter(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.list.length,
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: height * 0.5,
              child: GestureDetector(
                onTap: () {
                  if (widget.list[index].sub_kits == null ||
                      widget.list[index].sub_kits.isEmpty) {
                    if (widget.list[index].tag.isNotEmpty) {
                      developer.log('Tag', name: widget.list[index].tag);
                      launchScreen(context, widget.list[index].tag);
                    } else {
                      showToast(widget.mContext, appComingSoon);
                    }
                  } else {
                    launchScreen(context, Listing.tag,
                        arguments: widget.list[index]);
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: width / 6,
                        height: 80,
                        margin: EdgeInsets.only(right: 12),
                        padding: EdgeInsets.all(width / 25),
                        child: Image.asset(icons[index], color: appWhite),
                        decoration: boxDecoration(
                            bgColor: colors[index % colors.length], radius: 4),
                      ),
                      Expanded(
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: <Widget>[
                            Container(
                              width: width,
                              height: 80,
                              padding: EdgeInsets.only(left: 16, right: 16),
                              margin: EdgeInsets.only(right: width / 28),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[],
                                  ).expand(),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 25,
                                    margin: EdgeInsets.only(right: 8),
                                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    decoration:
                                        widget.list[index].type.isNotEmpty
                                            ? boxDecoration(
                                                bgColor: appDarkRed, radius: 4)
                                            : BoxDecoration(),
                                    child: text(widget.list[index].type,
                                        fontSize: textSizeSmall,
                                        textColor: whiteColor),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              child: Icon(Icons.keyboard_arrow_right,
                                  color: appWhite),
                              decoration: BoxDecoration(
                                  color: colors[index % colors.length],
                                  shape: BoxShape.circle),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget appBar(BuildContext context, String title,
    {List<Widget> actions, bool showBack = true}) {
  return AppBar(
    automaticallyImplyLeading: false,
    leading: showBack
        ? IconButton(
            onPressed: () {
              finish(context);
            },
            icon: Icon(Icons.arrow_back),
          )
        : null,
    title: Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: boldTextStyle(size: 20),
              maxLines: 1,
            ),
          ),
        ],
      ),
    ),
    actions: actions,
  );
}
