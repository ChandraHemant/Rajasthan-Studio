import 'package:flutter/material.dart';

class NotFoundPage extends StatefulWidget {
  const NotFoundPage({Key key}) : super(key: key);

  @override
  _NotFoundPageState createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final RelativeRectTween _relativeRectTween = RelativeRectTween(
    begin: RelativeRect.fromLTRB(24, 24, 24, 200),
    end: RelativeRect.fromLTRB(24, 24, 24, 250),
  );

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PositionedTransition(
            rect: _relativeRectTween.animate(_controller),
            child: Container(
              child: Image.asset('images/page_not_found.png'),
            ),
          ),
          Positioned(
            top: 150,
            bottom: 0,
            left: 24,
            right: 24,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                const Text(
                  '404',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 50,
                      letterSpacing: 2,
                      color: const Color(0xff2f3640),
                      fontFamily: 'Spah',
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Sorry, we couldn\'t find the page!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: const Color(0xff2f3640),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
