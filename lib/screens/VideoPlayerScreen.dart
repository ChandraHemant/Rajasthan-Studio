import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pexels/pexels.dart';
import 'package:studio/utils/AppColors.dart';
import 'package:studio/utils/AppConstant.dart';
import 'package:studio/utils/AppWidget.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;
  final String user;
  const VideoPlayerScreen({Key key, this.url, this.user}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  var videos = [];

  fetchapi() async {
    var client = new PexelsClient(
        '563492ad6f917000010000012c98942edde84d7c906fc84edb48cf38');

    var p = await client.getPhoto(); // get a random video.
    var link = p.get(ImageFormats.small);
    // stdout.write(link);

    var vid = await client.getVideo();
    print(vid.sources[0].id);
    // stdout.write(vid.sources[0].link);
    // await http.get(Uri.parse('https://api.pexels.com/videos/videos/:4076331'),
    //     headers: {
    //       'Authorization':
    //       '563492ad6f917000010000012c98942edde84d7c906fc84edb48cf38'
    //     }).then((value) {
    //   Map result = jsonDecode(value.body);
    //   setState(() {
    //     videos = result['videos'];
    //   });
    //   print(videos[0]);
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchapi();
    // print(widget.url);
  }

  String links;

  @override
  Widget build(BuildContext context) {
    final videoDisplayList = ListView.builder(
        itemCount: videos != null ? videos.length : 0,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerScreen(
                            url: videos[index]['video_files'][1]['link'],
                            user: videos[index]['user']['name']),
                      ));
                },
                child: Row(
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: videos[index]['image'],
                      height: 70,
                      width: 70,
                      fit: BoxFit.fill,
                    ).cornerRadiusWithClipRRect(20).paddingAll(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          text(videos[index]['user']['name'],
                                  textColor: blackColor,
                                  fontSize: textSizeLargeMedium,
                                  fontFamily: fontMedium)
                              .paddingOnly(right: 16),
                          text(videos[index]['duration'].toString() + " Sec",
                                  textColor: PrimaryColor.withOpacity(0.4),
                                  fontSize: textSizeLargeMedium,
                                  fontFamily: fontMedium)
                              .paddingOnly(top: 4, right: 16),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.more_vert,
                      size: 30,
                      color: PrimaryColor.withOpacity(0.4),
                    ).paddingAll(16)
                  ],
                ),
              ),
            ],
          );
        });

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                child: new ClipRect(
                  child: new BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: new Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.25,
                      decoration: new BoxDecoration(
                          color: Colors.black.withOpacity(0.8)),
                      child: new Center(
                        child: links == null
                            ? VideoItems(
                                videoPlayerController:
                                    VideoPlayerController.network(widget.url),
                                looping: false,
                                autoplay: false,
                              )
                            : VideoItems(
                                videoPlayerController:
                                    VideoPlayerController.network(links),
                                looping: false,
                                autoplay: false,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0, left: 28, bottom: 18),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          text("Related Videos",
                                  textColor: blackColor,
                                  fontSize: textSizeLargeMedium,
                                  fontFamily: fontMedium)
                              .paddingOnly(right: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.615,
                  child: videoDisplayList),
            ],
          ),
        ),
      ),
    );
  }
}
