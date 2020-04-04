import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

enum TypeOperation {
  upload,
  download,
  delete,
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final String keyMyPosts = 'keyMyPosts';
  final List<String> myPosts = [];
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  SharedPreferences sharedPreferences;
  TypeOperation typeOperation = TypeOperation.download;
  bool isLoading = true;
  bool isSuccess = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      sharedPreferences = await SharedPreferences.getInstance();
      if (sharedPreferences.containsKey(keyMyPosts)) {
        myPosts.addAll(sharedPreferences.getStringList(keyMyPosts));
        setState(() {
          isLoading = false;
          typeOperation = null;
        });
      } else {
        setState(() {
          isLoading = false;
          typeOperation = null;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      key: scaffoldState,
      body: Stack(
        children: <Widget>[
          _buildWidgetBackgroundHeader(),
          _buildWidgetContentProfile(),
          _buildWidgetPhotoProfile(),
          _buildWidgetLoading(),
        ],
      ),
    );
  }

  Container _buildWidgetLoading() {
    if (isLoading && typeOperation == TypeOperation.upload || typeOperation == TypeOperation.delete) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[900].withOpacity(0.8),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Container();
    }
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
            height: ScreenUtil().setWidth(256),
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
          top: ScreenUtil().setWidth(128 + 56),
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
            _buildWidgetHeaderMyPosts(),
            Expanded(
              child: _buildWidgetMyPosts(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetMyPosts() {
    if (isLoading && typeOperation == TypeOperation.download) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (myPosts.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          WidgetTextMont(
            'No post available',
            fontWeight: FontWeight.bold,
            fontSize: 56,
            textColor: Colors.grey[600],
          ),
          SizedBox(
            height: ScreenUtil().setHeight(24),
          ),
          WidgetTextMont(
            'When you share photos and videos, they\'ll appear in here',
            textAlign: TextAlign.center,
            textColor: Colors.grey[700],
          ),
        ],
      );
    } else {
      return GridView.count(
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(48),
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        crossAxisCount: 3,
        children: myPosts.map(
          (item) {
            return ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: item,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Image.asset(
                    'assets/images/img_placeholder.png',
                    fit: BoxFit.cover,
                  );
                },
                errorWidget: (context, url, error) {
                  return Image.asset(
                    'assets/images/img_not_found.jpg',
                    fit: BoxFit.cover,
                  );
                },
              ),
            );
          },
        ).toList(),
        crossAxisSpacing: ScreenUtil().setWidth(48),
        mainAxisSpacing: ScreenUtil().setHeight(48),
      );
    }
  }

  Widget _buildWidgetHeaderMyPosts() {
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
              /* Nothing to do in here */
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
              /* Nothing to do in here */
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
                GestureDetector(
                  onTap: () async {
                    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
                    if (image == null) {
                      return;
                    }
                    List<String> splitPath = image.path.split('/');
                    String filename = splitPath[splitPath.length - 1];
                    StorageReference ref = firebaseStorage.ref().child('images').child(filename);
                    StorageUploadTask uploadTask = ref.putFile(image);
                    StreamSubscription streamSubscription = uploadTask.events.listen((event) async {
                      var eventType = event.type;
                      if (eventType == StorageTaskEventType.progress) {
                        setState(() {
                          typeOperation = TypeOperation.upload;
                          isLoading = true;
                        });
                      } else if (eventType == StorageTaskEventType.failure) {
                        scaffoldState.currentState.showSnackBar(SnackBar(
                          content: Text('Photo failed to upload'),
                        ));
                        setState(() {
                          isLoading = false;
                          isSuccess = false;
                          typeOperation = null;
                        });
                      } else if (eventType == StorageTaskEventType.success) {
                        var downloadUrl = await event.snapshot.ref.getDownloadURL();
                        myPosts.add(downloadUrl);
                        sharedPreferences.setStringList(keyMyPosts, myPosts);
                        scaffoldState.currentState.showSnackBar(SnackBar(
                          content: Text('Photo uploaded successfully'),
                        ));
                        setState(() {
                          isLoading = false;
                          isSuccess = true;
                          typeOperation = null;
                        });
                      }
                    });
                    await uploadTask.onComplete;
                    streamSubscription.cancel();
                  },
                  child: Icon(
                    Icons.camera,
                    color: Color(0xFF251F1F),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                      typeOperation = TypeOperation.delete;
                    });
                    myPosts.forEach((element) async {
                      StorageReference ref = await firebaseStorage.getReferenceFromUrl(element);
                      await ref.delete();
                    });
                    myPosts.clear();
                    await sharedPreferences.clear();
                    setState(() {
                      isLoading = false;
                      typeOperation = null;
                    });
                  },
                  child: Icon(
                    Icons.delete,
                    color: Color(0xFF251F1F),
                  ),
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
  final TextAlign textAlign;

  WidgetTextMont(
    this.text, {
    this.fontSize = 36,
    this.fontWeight = FontWeight.normal,
    this.textColor = Colors.white,
    this.textAlign = TextAlign.left,
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
      textAlign: textAlign,
    );
  }
}
