import 'package:flutter/material.dart';
import 'package:niia_mis_app/network_utils/paymentsapi.dart';
import 'package:niia_mis_app/widgets/size_config.dart';
import 'dart:convert';
import 'dart:async';
import 'package:niia_mis_app/widgets/nav-drawer.dart';
import 'package:niia_mis_app/network_utils/api.dart';

class UserPaymentTransaction extends StatefulWidget {
  @override
  _UserPaymentTransactionState createState() => _UserPaymentTransactionState();
}

class _UserPaymentTransactionState extends State<UserPaymentTransaction> {
  var listCount;

  void initState() {
    _countPaymentTransactions();

    super.initState();
  }

  _countPaymentTransactions() async {
    final res = await Network().getData('/userpayments');
    PaymentApi payments = paymentApiFromJson(res.body);
    setState(() {
      listCount = payments.payments.length;
    });
  }

  _getPaymentTransactions() async {
    final res = await Network().getData('/userpayments');
    PaymentApi payments = paymentApiFromJson(res.body);
    List<Payment> paymentsdetails = payments.payments;
    return paymentsdetails;
  }

  Widget getWidget() {
    // without index
    if (listCount == 1) {
      return FutureBuilder(
        future: _getPaymentTransactions(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                return Container(
                  child: Row(
                    children: [
                      /*  */
                      Expanded(
                        child: Container(
                         
                          child: Column(
                            
                            children: [
                              SizedBox(
                                height: 2.14 * SizeConfig.heightMultiplier,
                              ),
                              Text(snapshot.data[0].paymentType,
                                  style: TextStyle(
                                    color: Colors.blue[900],
                                    fontSize: 3.0 * SizeConfig.textMultiplier,
                                    fontFamily: 'Bebas Nue',
                                    fontWeight: FontWeight.w700,
                                  ),
                                  ),
                              Text(
                                  snapshot.data[0].startDate
                                          .toString()
                                          .substring(0, 10) +
                                      ' - ' +
                                      snapshot.data[0].expiryDate
                                          .toString()
                                          .substring(0, 10),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 2.43 * SizeConfig.textMultiplier,
                                    fontFamily: 'Bebas Nue',
                                    fontWeight: FontWeight.w700,
                                  )),
                              
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: new EdgeInsets.all(
                              0.95 * SizeConfig.heightMultiplier),
                          child: Column(
                            
                            children: [
                              SizedBox(
                                height: 2.14 * SizeConfig.heightMultiplier,
                              ),
                              Text('N ' + snapshot.data[0].amount.toString(),
                                  style: TextStyle(
                                    color: Colors.blue[900],
                                    fontSize: 3.0 * SizeConfig.textMultiplier,
                                    fontFamily: 'Bebas Nue',
                                    fontWeight: FontWeight.w700,
                                  )),
                             
                            ],
                          ),
                        ),
                      ),
                     
                    ],
                  ),
                );

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
      );
    }
    // With Index
    else {
      return FutureBuilder(
        future: _getPaymentTransactions(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                return ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                          color: Colors.blue[900],
                        ),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      assert(index != null);

                      return Container(
                        child: Row(
                          children: [
                            /*  */
                            Expanded(
                              child: Container(
                                padding: new EdgeInsets.only(
                                    left: 2.5 * SizeConfig.heightMultiplier),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      height:
                                          5.14 * SizeConfig.heightMultiplier,
                                    ),
                                    Text(snapshot.data[index].paymentType,
                                        style: TextStyle(
                                          color: Colors.blue[900],
                                          fontSize:
                                              3.0 * SizeConfig.textMultiplier,
                                          fontFamily: 'Bebas Nue',
                                          fontWeight: FontWeight.w700,
                                        )),
                                    Text(
                                        snapshot.data[index].startDate
                                                .toString()
                                                .substring(0, 10) +
                                            ' - ' +
                                            snapshot.data[index].expiryDate
                                                .toString()
                                                .substring(0, 10),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize:
                                              2.43 * SizeConfig.textMultiplier,
                                          fontFamily: 'Bebas Nue',
                                          fontWeight: FontWeight.w700,
                                        )),
                                    SizedBox(
                                      height:
                                          2.14 * SizeConfig.heightMultiplier,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: new EdgeInsets.only(
                                    left: 2.45 * SizeConfig.heightMultiplier),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      height:
                                          2.14 * SizeConfig.heightMultiplier,
                                    ),
                                    Text(
                                        'N ' +
                                            snapshot.data[index].amount
                                                .toString(),
                                        style: TextStyle(
                                          color: Colors.blue[900],
                                          fontSize:
                                              3.0 * SizeConfig.textMultiplier,
                                          fontFamily: 'Bebas Nue',
                                          fontWeight: FontWeight.w700,
                                        )),
                                    SizedBox(
                                      height:
                                          2.14 * SizeConfig.heightMultiplier,
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
                      );
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
      );
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
                title: Text('My Transactions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 3.5 * SizeConfig.textMultiplier,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                    )),
                centerTitle: true,
                backgroundColor: Colors.blue[800],
                iconTheme: new IconThemeData(color: Colors.white),
              ),
              body: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.blue[900]),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: new Border.all(
                          color: Colors.black,
                          width: 1.25 * SizeConfig.widthMultiplier,
                          style: BorderStyle.solid),
                      borderRadius: new BorderRadius.vertical(
                        top: new Radius.circular(
                            7.5 * SizeConfig.heightMultiplier),
                      ),
                    ),
                    child: getWidget(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
