import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildWidgetBackgroundHeader(),
          _buildWidgetContentProfile(),
          _buildWidgetPhotoProfile(),
        ],
      ),
    );
  }

  Container _buildWidgetPhotoProfile() {
    return Container(
      margin: EdgeInsets.only(
        top: ScreenUtil().setHeight(160),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(256),
            height: ScreenUtil().setHeight(256),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                ScreenUtil().setWidth(48),
              ),
              image: DecorationImage(
                image: AssetImage('assets/images/woman_holding_guitar.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetContentProfile() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        top: ScreenUtil().setHeight(256),
      ),
      decoration: BoxDecoration(
        color: Color(0xFF251F1F),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            ScreenUtil().setWidth(72),
          ),
          topRight: Radius.circular(
            ScreenUtil().setWidth(72),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(128 + 56),
          right: ScreenUtil().setWidth(64),
          left: ScreenUtil().setWidth(64),
        ),
        child: Column(
          children: <Widget>[
            WidgetTextMont(
              'Angelica Mayuko',
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(16),
            ),
            WidgetTextMont(
              'Software Engineer focused on iOS',
              textColor: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(72),
            ),
            _buildWidgetPostsFollowersFollowing(),
            SizedBox(
              height: ScreenUtil().setHeight(32),
            ),
            _buildWidgetButtonFollowAndChat(),
            SizedBox(
              height: ScreenUtil().setHeight(48),
            ),
            _buildWidgetMyPosts(),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetMyPosts() {
    return Row(
      children: <Widget>[
        Expanded(
          child: WidgetTextMont(
            'My Posts',
            fontWeight: FontWeight.bold,
            fontSize: 42,
          ),
        ),
        GestureDetector(
          onTap: () {
            // TODO: do something in here
          },
          child: Icon(
            FontAwesomeIcons.thList,
            color: Colors.grey[800],
            size: 16,
          ),
        ),
        SizedBox(
          width: ScreenUtil().setWidth(48),
        ),
        GestureDetector(
          onTap: () {
            // TODO: do something in hre
          },
          child: Icon(
            FontAwesomeIcons.thLarge,
            color: Colors.grey[100],
            size: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildWidgetButtonFollowAndChat() {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            child: Text(
              'Follow',
              style: TextStyle(
                fontFamily: 'Mont',
                fontWeight: FontWeight.bold,
              ),
            ),
            textColor: Colors.white,
            color: Color(0xFFFC8157),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onPressed: () {
              // TODO: do something in here
            },
          ),
        ),
        SizedBox(
          width: ScreenUtil().setWidth(48),
        ),
        Expanded(
          child: RaisedButton(
            child: Icon(
              Icons.chat,
              color: Colors.white,
              size: 20,
            ),
            color: Color(0xFFFFD4BE),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onPressed: () {
              // TODO: do something in here
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWidgetPostsFollowersFollowing() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            WidgetTextMont(
              '123',
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
            WidgetTextMont(
              'Posts',
              textColor: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            WidgetTextMont(
              '1.2M',
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
            WidgetTextMont(
              'Followers',
              textColor: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            WidgetTextMont(
              '304',
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
            WidgetTextMont(
              'Following',
              textColor: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWidgetBackgroundHeader() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/woman_holding_guitar.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10,
              sigmaY: 10,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.0),
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(48),
              right: ScreenUtil().setWidth(48),
              left: ScreenUtil().setWidth(48),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(
                  Icons.camera,
                  color: Color(0xFF251F1F),
                ),
                Icon(
                  Icons.more_vert,
                  color: Color(0xFF251F1F),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WidgetTextMont extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;

  WidgetTextMont(
    this.text, {
    this.fontSize = 36,
    this.fontWeight = FontWeight.normal,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: ScreenUtil().setSp(fontSize),
        fontWeight: fontWeight,
        fontFamily: 'Mont',
      ),
    );
  }
}
