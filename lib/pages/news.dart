import 'package:flutter/material.dart';
import 'package:niia_mis_app/widgets/nav-drawer.dart';
import 'package:niia_mis_app/network_utils/post.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:niia_mis_app/widgets/size_config.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
// adminName and adminKey is needed only for admin level APIs
  String url = "https://niia.gov.ng/wp-json/wp/v2/posts?_embed";
  static final String NEWS_PLACEHOLDER_IMAGE_ASSET_URL =
      'assets/images/niiabanner.jpg';

  bool isLoading = false;
  List<Post> posts;

  @override
  void initState() {
    _fetchPosts();

    super.initState();
  }

  Future _fetchPosts() async {
    final response = await http.get(this.url);

    if (response.statusCode == 200) {
      posts = (json.decode(response.body) as List).map((data) {
        return Post.fromJSON(data);
      }).toList();
      print(posts);

      return posts;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            SizeConfig().init(constraints, orientation);
            return Scaffold(
              drawer: NavDrawer(),
              appBar: AppBar(
                title: Text('HEADLINE NEWS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 4 * SizeConfig.textMultiplier,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                    )),
                centerTitle: true,
                backgroundColor: Colors.blue[800],
                iconTheme: new IconThemeData(color: Colors.white),
              ),
              body: FutureBuilder(
                future: _fetchPosts(),
                initialData: [],
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print(snapshot.connectionState);
                  print(snapshot.data);
                  if (snapshot.hasData) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text("Waiting...");
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                      case ConnectionState.done:
                        if (snapshot.data == null) {
                          return Container(
                              child: Center(child: Text("Waiting...")));
                        }

                        return ListView.builder(
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              assert(index != null);
                              print(snapshot.data[index].sourceimage);
                              return Column(
                                children: [
                                  Container(
                                      child: GestureDetector(
                                    onTap: () {
                                      print('working');
                                      _launchURL(snapshot.data[index].link);
                                    },
                                    child: Column(
                                      children: [
                                        snapshot.data[index].sourceimage == null
                                            ? Image.asset(
                                                NEWS_PLACEHOLDER_IMAGE_ASSET_URL)
                                            : Image.network(snapshot
                                                .data[index].sourceimage),
                                      ],
                                    ),
                                  )),
                                  SizedBox(
                                    height: 2.14 * SizeConfig.heightMultiplier,
                                  ),
                                  Container(
                                      child: GestureDetector(
                                    onTap: () {
                                      print('working');
                                      _launchURL(snapshot.data[index].link);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(snapshot.data[index].title,
                                          style: TextStyle(
                                            color: Colors.blue[300],
                                            fontSize: 3.43 *
                                                SizeConfig.textMultiplier,
                                            fontFamily: 'Bebas Nue',
                                            fontWeight: FontWeight.w700,
                                          )),
                                    ),
                                  )),
                                  SizedBox(
                                    height: 2.14 * SizeConfig.heightMultiplier,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(snapshot.data[index].excerpt,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize:
                                              2.71 * SizeConfig.textMultiplier,
                                          fontFamily: 'Bebas Nue',
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ),
                                ],
                              );
                            });
                      default:
                        break;
                    }
                  } else if (snapshot.hasError) {
                    return Padding(
                        padding: EdgeInsets.fromLTRB(130.0, 0, 150.0, 0),
                        child: Text(
                          'Membership',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 2.57 * SizeConfig.textMultiplier,
                            fontFamily: 'Typographica',
                            fontWeight: FontWeight.w700,
                          ),
                        ));
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
