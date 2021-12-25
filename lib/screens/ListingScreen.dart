import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:studio/models/Models.dart';
import 'package:studio/utils/AppColors.dart';
import 'package:studio/utils/AppConstant.dart';
import 'package:studio/utils/AppImages.dart';
import 'package:studio/utils/AppWidget.dart';
import 'VideoPlayerScreen.dart';

class ListingScreen extends StatefulWidget {
  @override
  _ListingScreenState createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen>
    with SingleTickerProviderStateMixin {
  final LocalStorage storage = new LocalStorage('localstorage_app');
  TabController _tabController;

  List images = [];
  List videos = [];
  int page = 1;

  void getitemFromLocalStorage() {
    final infoImg = storage.getItem('infoImage');
    final infoVid = storage.getItem('infoVideo');
    // return info;
    setState(() {
      images = infoImg;
      videos = infoVid;
    });
    // print(images);
    // print(videos);
  }

  void initState() {
    super.initState();
    getitemFromLocalStorage();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(Colors.transparent);

    final imgList = ListView.builder(
        itemCount: images == null ? 0 : images.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                height: 420,
                width: MediaQuery.of(context).size.width - 24,
                child: CachedNetworkImage(
                  imageUrl: images[index]['url'],
                  fit: BoxFit.fill,
                ).cornerRadiusWithClipRRect(20).paddingTop(16),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: WhiteColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    text(
                      images[index]['user'],
                      textColor: blackColor,
                      fontSize: textSizeNormal,
                      fontFamily: fontBold,
                    ),
                  ],
                ).paddingAll(16),
              ).cornerRadiusWithClipRRect(20)
            ],
          ).paddingOnly(top: 8, bottom: 8, left: 24, right: 24);
        });

    final vidList = ListView.builder(
        itemCount: videos == null ? 0 : videos.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                height: 420,
                width: MediaQuery.of(context).size.width - 24,
                child: Stack(children: [
                  CachedNetworkImage(
                    height: 420,
                    width: MediaQuery.of(context).size.width - 24,
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
                                  url: videos[index]['url'],
                                  user: videos[index]['user']),
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
                width: MediaQuery.of(context).size.width,
                color: WhiteColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    text(
                      videos[index]['user'],
                      textColor: blackColor,
                      fontSize: textSizeNormal,
                      fontFamily: fontBold,
                    ),
                  ],
                ).paddingAll(16),
              ).cornerRadiusWithClipRRect(20)
            ],
          ).paddingAll(16);
        });

    return SafeArea(
      child: Scaffold(
        appBar: TabBar(
          controller: _tabController,
          // give the indicator a decoration (color and border radius)
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(
              25.0,
            ),
            color: Colors.blueGrey,
          ),
          labelColor: Colors.white,
          labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
          unselectedLabelColor: Colors.black,
          tabs: [
            // first tab [you can add an icon using the icon property]
            Tab(
              text: 'Image List',
            ),
            Tab(
              text: 'Video List',
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: [
                // first tab bar view widget
                Center(child: imgList),

                // second tab bar view widget
                Center(
                  child: vidList,
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}

class Listing extends StatefulWidget {
  static String tag = "/Listing";

  @override
  ListingState createState() => ListingState();
}

class ListingState extends State<Listing> {
  var width;
  var height;
  var selectedTab = 0;
  List<ProTheme> list = List<ProTheme>();
  List<Color> colors = [appCat1, appCat2, appCat3];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // changeStatusColor(appWhite);
    ProTheme arguments = ModalRoute.of(context).settings.arguments;
    list = arguments.sub_kits;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: appBar(
        context,
        arguments.title_name ?? arguments.name,
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(16),
              child: arguments.show_cover
                  ? Image.asset(app_bg_cover_image, height: height / 4)
                  : null,
            ),
            ThemeList(list, context)
          ],
        ),
      ),
    );
  }
}
