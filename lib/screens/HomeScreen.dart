import 'dart:convert';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:studio/models/Models.dart';
import 'package:studio/utils/AppColors.dart';
import 'package:studio/utils/AppConstant.dart';
import 'package:studio/utils/AppStrings.dart';
import 'package:studio/utils/AppWidget.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  static String tag = '/HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalStorage storage = new LocalStorage('localstorage_app');

  var isClicked = false;

  var selectedSongType = 0;
  var images = [];
  var ids;
  int page = 1;

  fetchapi() async {
    await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=10'),
        headers: {
          'Authorization':
              '563492ad6f917000010000012c98942edde84d7c906fc84edb48cf38'
        }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images = result['photos'];
      });
      // print(images[0]);
    });
    getDataFromLocalStorage();
    updateId();
  }

  loadmore() async {
    setState(() {
      page = page + 1;
    });
    String url =
        'https://api.pexels.com/v1/curated?per_page=10&page=' + page.toString();
    await http.get(Uri.parse(url), headers: {
      'Authorization':
          '563492ad6f917000010000012c98942edde84d7c906fc84edb48cf38'
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result['photos']);
      });
    });
  }

  List picInfo;

  void addItemsToLocalStorage(var id, var user, var url) {
    var infos = storage.getItem('infoImage');
    var idList = [];
    if (infos == null) {
      picInfo = [
        {'id': id, 'user': user, 'url': url}
      ];
      setState(() {
        infos = picInfo;
        idList = [id];
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
        picInfo = [
          {'id': id, 'user': user, 'url': url}
        ];
        setState(() {
          infos.addAll(picInfo);
          idList.add(id);
        });
      }
    }
    storage.setItem('infoImage', infos);
    updateId();
    var info = storage.getItem('infoImage');
    // storage.deleteItem('infoImage');
    setState(() {
      ids = info;
    });
    print(infos);
    // print(ids[0]['id']);
  }

  updateId() {
    if (ids != null) {
      for (int i = 0; i < ids.length; i++) {
        if (!idList.contains(ids[i]['id'])) {
          setState(() {
            idList.add(ids[i]['id']);
          });
        }
      }
    }

    print(idList);
  }

  getDataFromLocalStorage() {
    final info = storage.getItem('infoImage');
    // storage.deleteItem('infoImage');
    // idList.clear();
    setState(() {
      ids = info;
    });
    updateId();
    print(ids);
  }

  var idList = [];

  @override
  void initState() {
    super.initState();
    fetchapi();
  }

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

    final imgList = Container(
      height: 420,
      child: ListView.builder(
          itemCount: images.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            //
            return Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: CachedNetworkImage(
                    imageUrl: images[index]['src']['large2x'],
                    fit: BoxFit.fill,
                  ).cornerRadiusWithClipRRect(20).paddingTop(16),
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
                                  images[index]['photographer'],
                                  textColor: WhiteColor,
                                  fontSize: textSizeNormal,
                                  fontFamily: fontBold,
                                ),
                              ),
                              IconButton(
                                  icon: idList != null
                                      ? (index < images.length
                                          ? (
                                              // variable[index] == images[index]['id']
                                              idList.contains(
                                                      images[index]['id'])
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
                                        images[index]['id'],
                                        images[index]['photographer'],
                                        images[index]['src']['large2x']);
                                  }),
                            ],
                          ),
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
              imgList,
            ],
          ),
        ),
      ),
    );
  }
}
