import 'dart:convert';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:studio/screens/VideoPlayerScreen.dart';
import 'package:studio/utils/AppColors.dart';
import 'package:studio/utils/AppConstant.dart';
import 'package:studio/utils/AppStrings.dart';
import 'package:studio/utils/AppWidget.dart';
import 'package:http/http.dart' as http;

class VideoScreen extends StatefulWidget {
  static String tag = '/VideoScreen';

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final LocalStorage storage = new LocalStorage('localstorage_app');

  var isClicked = false;
  var selectedSongType = 0;
  var videos = [];
  var idVideo;
  int page = 1;

  fetchapi() async {
    await http.get(
        Uri.parse('https://api.pexels.com/videos/popular?per_page=10'),
        headers: {
          'Authorization':
              '563492ad6f917000010000012c98942edde84d7c906fc84edb48cf38'
        }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        videos = result['videos'];
      });
      // print(vidoes[0]);
    });
    getDataFromLocalStorage();
    updateVid();
  }

  loadmore() async {
    setState(() {
      page = page + 1;
    });
    String url = 'https://api.pexels.com/videos/popular?per_page=10&page=' +
        page.toString();
    await http.get(Uri.parse(url), headers: {
      'Authorization':
          '563492ad6f917000010000012c98942edde84d7c906fc84edb48cf38'
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        videos.addAll(result['videos']);
      });
    });
  }

  List vidInfo;

  void addItemsToLocalStorage(var id, var user, var image, var url) {
    var infos = storage.getItem('infoVideo');
    if (infos == null) {
      vidInfo = [
        {'id': id, 'user': user, 'image': image, 'url': url}
      ];
      setState(() {
        infos = vidInfo;
        variable = [id];
      });
    } else {
      int i = 0;
      var temp = false;
      for (i = 0; i < infos.length; i++) {
        if (infos[i]['id'] == id) {
          temp = true;
          break;
        }
      }
      if (!temp) {
        vidInfo = [
          {'id': id, 'user': user, 'image': image, 'url': url}
        ];
        setState(() {
          infos.addAll(vidInfo);
          variable.add(id);
        });
      }
    }
    storage.setItem('infoVideo', infos);

    var info = storage.getItem('infoVideo');
    // storage.deleteItem('info');
    setState(() {
      idVideo = info;
    });
    print(infos);
    // print(idVideo[0]['id']);
  }

  updateVid() {
    if (idVideo != null) {
      for (int i = 0; i < idVideo.length; i++) {
        if (!variable.contains(idVideo[i]['id'])) {
          setState(() {
            variable.add(idVideo[i]['id']);
          });
        }
      }
    }
    print(vidInfo);
  }

  getDataFromLocalStorage() {
    final info = storage.getItem('infoVideo');
    // storage.deleteItem('info');
    // storage.deleteItem('infoVideo');
    // variable.clear();
    setState(() {
      idVideo = info;
    });
    updateVid();
    print(idVideo);
  }

  @override
  void initState() {
    super.initState();
    fetchapi();
  }

  var variable = [];

  @override
  Widget build(BuildContext context) {
    final searchView = Container(
      height: 50,
      child: TextField(
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            filled: true,
            fillColor: whiteColor,
            hintText: lbl_search_Title,
            border: InputBorder.none,
            suffixIcon: Icon(
              Icons.search,
              color: PrimaryColor,
            ).paddingAll(12),
            contentPadding:
                EdgeInsets.only(left: 16.0, bottom: 8.0, top: 8.0, right: 16.0),
          )).cornerRadiusWithClipRRect(20),
      alignment: Alignment.center,
    ).cornerRadiusWithClipRRect(10).paddingAll(16);

    final vidList = Container(
      height: 420,
      child: ListView.builder(
          itemCount: videos.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: Stack(children: [
                    CachedNetworkImage(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width / 1.3,
                      imageUrl: videos[index]['image'],
                      fit: BoxFit.fill,
                    ).cornerRadiusWithClipRRect(20).paddingTop(16),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayerScreen(
                                    url: videos[index]['video_files'][1]
                                        ['link'],
                                    user: videos[index]['user']['name']),
                              ));
                        },
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage("images/play.png"),
                          )),
                        ),
                      ),
                    )
                  ]),
                ),
                Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width / 1.3,
                  color: blackColor.withOpacity(0.7),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.55,
                                child: text(
                                  videos[index]['user']['name'],
                                  textColor: WhiteColor,
                                  fontSize: textSizeNormal,
                                  fontFamily: fontBold,
                                ),
                              ),
                              IconButton(
                                  icon: variable != null
                                      ? (index < videos.length
                                          ? (
                                              //idVideo[index]['id'] == videos[index]['id']
                                              variable.contains(
                                                      videos[index]['id'])
                                                  ? Icon(
                                                      Icons.favorite,
                                                      color: Colors.red,
                                                      size: 35.0,
                                                    )
                                                  : Icon(
                                                      LineAwesomeIcons.heart,
                                                      color: Colors.white,
                                                      size: 35.0,
                                                    ))
                                          : Icon(
                                              LineAwesomeIcons.heart,
                                              color: Colors.white,
                                              size: 35.0,
                                            ))
                                      : Icon(
                                          LineAwesomeIcons.heart,
                                          color: Colors.white,
                                          size: 35.0,
                                        ),
                                  onPressed: () {
                                    addItemsToLocalStorage(
                                        videos[index]['id'],
                                        videos[index]['user']['name'],
                                        videos[index]['image'],
                                        videos[index]['video_files'][1]
                                            ['link']);
                                  }),
                            ],
                          ),

                          /* text(images[index]['photographer_id'].toString(),
                                  textColor: WhiteColor,
                                  fontSize: textSizeMedium,
                                  fontFamily: fontRegular),*/
                        ],
                      ).paddingOnly(left: 16, right: 8, bottom: 16),
                    ],
                  ),
                ).cornerRadiusWithClipRRect(20)
              ],
            ).paddingAll(16);
          }),
    );

    return Scaffold(
      body: Container(
        color: GradientColor2.withOpacity(0.4),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30),
              searchView,
              Padding(
                padding: const EdgeInsets.only(
                    right: 16.0, left: 16, top: 8, bottom: 8),
                child: InkWell(
                  onTap: () {
                    loadmore();
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    color: Colors.black,
                    child: Center(
                      child: Text('+ Add More',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                  ),
                ).cornerRadiusWithClipRRect(25),
              ),
              vidList,
            ],
          ),
        ),
      ),
    );
  }
}
