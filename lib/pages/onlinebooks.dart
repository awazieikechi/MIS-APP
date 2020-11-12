import 'package:flutter/material.dart';
import 'package:niia_mis_app/widgets/nav-drawer.dart';
import 'package:niia_mis_app/network_utils/books.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:niia_mis_app/widgets/size_config.dart';

class OnlineBooks extends StatefulWidget {
  @override
  _OnlineBooksState createState() => _OnlineBooksState();
}

class _OnlineBooksState extends State<OnlineBooks> {
  static final String NEWS_PLACEHOLDER_IMAGE_ASSET_URL =
      'assets/images/niiabanner.jpg';

  var uri = Uri.https('books.niia.gov.ng', '/wp-json/wc/v3/products', {
    'consumer_key': 'ck_e816e401182ca6052f2cf12dafab2b14d484b8f8',
    'consumer_secret': 'cs_871c4bb0b4c14e0273ac5f4d2ca1db80bc6a62eb'
  });

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  @override
  void initState() {
    getBooks();

    super.initState();
  }

  getBooks() async {
    final result = await http.get(uri, headers: _setHeaders());
    print(result.statusCode);
    if (result.statusCode == 200) {
      List<Book> books = (json.decode(result.body) as List).map((data) {
        return Book.fromJson(data);
      }).toList();

      print(books);

      return books;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'BOOKS',
              style: TextStyle(
                color: Colors.blue[900],
                fontSize: 4 * SizeConfig.textMultiplier,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Check out our Books',
              style: TextStyle(
                color: Colors.black,
                fontSize: 2.29 * SizeConfig.textMultiplier,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(color: Colors.blue[300]),
      ),
      body: Stack(children: [
        Container(
          //10 for example
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/bookbackground.jpg'),
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(
                Colors.blue[900].withOpacity(1.0), BlendMode.multiply),
          )),
        ),
        Container(
          child: FutureBuilder(
            future: getBooks(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print(snapshot.connectionState);
              print(snapshot.data);
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text("Waiting...");
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          assert(index != null);
                          print(snapshot.data[index].images[0].src);
                          return Container(
                              child: GestureDetector(
                            onTap: () {
                              print('working');
                              _launchURL(snapshot.data[index].permalink);
                            },
                            child: Row(
                              children: [
                                /*  */
                                Container(
                                    width: 25 * SizeConfig.widthMultiplier,
                                    padding: new EdgeInsets.only(
                                        left:
                                            1.3 * SizeConfig.heightMultiplier),
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        snapshot.data[index].images[0].src ==
                                                null
                                            ? Image.asset(
                                                NEWS_PLACEHOLDER_IMAGE_ASSET_URL)
                                            : Image.network(snapshot
                                                .data[index].images[0].src),
                                        SizedBox(
                                          height: 2.14 *
                                              SizeConfig.heightMultiplier,
                                        ),
                                      ],
                                    )),
                                Expanded(
                                  child: Container(
                                    padding: new EdgeInsets.only(left: 18.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(snapshot.data[index].name,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 3.43 *
                                                  SizeConfig.textMultiplier,
                                              fontFamily: 'Bebas Nue',
                                              fontWeight: FontWeight.w700,
                                            )),
                                        Text('Books',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 2.5 *
                                                  SizeConfig.textMultiplier,
                                              fontFamily: 'Bebas Nue',
                                              fontWeight: FontWeight.w700,
                                            )),
                                        Text(
                                            'N' +
                                                snapshot.data[index].price
                                                    .toString(),
                                            style: TextStyle(
                                              color: Colors.cyan[300],
                                              fontSize: 3.43 *
                                                  SizeConfig.textMultiplier,
                                              fontFamily: 'Bebas Nue',
                                              fontWeight: FontWeight.w700,
                                            )),
                                        SizedBox(
                                          height: 2.14 *
                                              SizeConfig.heightMultiplier,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.14 * SizeConfig.heightMultiplier,
                                ),
                              ],
                            ),
                          ));
                        });
                  default:
                    break;
                }
              } else if (snapshot.hasError) {
                return Padding(
                    padding: EdgeInsets.fromLTRB(130.0, 0, 150.0, 0),
                    child: Text(
                      'Could not get News',
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
        )
      ]),
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
