import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smartbins/commons/common.dart';
import 'package:smartbins/commons/topcontainer.dart';

//My own imports
import 'package:smartbins/provider/user_provider.dart';

import 'login.dart';

//String uid;

var driver_name = [];
var driver_details = {};
String driver_status;
class Driver extends StatefulWidget {
  @override
  _DriverState createState() => _DriverState();

}

class _DriverState extends State<Driver> {
  final _storage = FlutterSecureStorage();
  FirebaseAuth auth = FirebaseAuth.instance;
  int _radioValue = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_driver_names().then((id) {
      setState(() {});
    });
    //    get_uid().then((id) {
//      setState(() {});
//    });
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          driver_status = "Allotted";
          break;
        case 1:
          driver_status = "Vacant";
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //AppProvider appProvider = Provider.of<AppProvider>(context);
    final user = UserProvider();
//    print("===================== P R I N T I N G ===============");
//    print(uid);
    Widget image_carousel = new Container(
      height: 200.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('images/main2.jpg'),
          AssetImage('images/main1.jpg'),
          AssetImage('images/main3.jpg'),
          AssetImage('images/main4.jpg'),
        ],
        autoplay: false,
        //  animationCurve: Curves.fastOutSlowIn,
        // animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.0,
        indicatorBgPadding: 8.0,
        dotBgColor: Colors.transparent,
        //dotColor :Colors.red,
      ),
    );

    return Scaffold(
      backgroundColor: Color(0xFFFFF9EC),
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color(0xFFF9BE7C),
//          title: Center(child: Text("Asset Tracker",style: TextStyle(color:Color(0xFF0D253F)),)),
          iconTheme: new IconThemeData(color: Color(0xFF0D253F)),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFF0D253F)),
//              onPressed: () => changeScreenReplacement(context, HomePage())),
//          Navigator.of(context).pop()
              onPressed: () => Navigator.of(context).pop()),
          actions: <Widget>[
            new IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Color(0xFF0D253F),
                ),
                onPressed: () {
                  signOut();
                  changeScreenReplacement(context, Login());
                })
          ]),
      //body: new ListView(
      body: build_driver_page(context),
//      body: new Column(
//        children: <Widget>[
//          //Image carousel begins here
//          image_carousel,
//          //Padding widget
//
//          new Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: new Text('Driver Details',
//                style: TextStyle(
//                    fontWeight: FontWeight.bold,
//                    color: Colors.red,
//                    fontSize: 18.0)),
//          ),
//
//          Flexible(
//            child: new StreamBuilder(
//                stream:
//                    Firestore.instance.collection('driver_details').snapshots(),
//                builder: (context, snapshot) {
//                  if (!snapshot.hasData) return const Text('Loading...');
//                  return new GridView.builder(
//                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
//                        crossAxisCount: 2),
//                    itemCount: snapshot.data.documents.length,
//                    padding: const EdgeInsets.all(4.0),
//                    itemBuilder: (context, index) => _buildListItem2(
//                        context, snapshot.data.documents[index]),
//                  );
//                }),
//          ),
//          //Grid View
//        ],
//      ),
    );
  }

//  get_uid() async {
//    final current_user = await _storage.readAll();
//    uid = current_user["uid"];
//  }
  get_driver_names() async {
    await Firestore.instance.collection("driver_details").getDocuments().then((
        querySnapshot) {
      querySnapshot.documents.forEach((result) {
//        print(result.data);
        if (driver_name.contains(result.data['name']) == false) {
          driver_name.add(result.data['name']);
          driver_details[result.data['name']] = [
            result.data['name'],
            result.data['mobile'],
            result.data['status'],
            result.documentID
          ];
        }
        print(driver_details);
      });
    });
  }

  signOut() async {
    auth.signOut();
    await _storage.deleteAll();
    await _storage.write(key: "status", value: "Unauthenticated");
  }

  build_driver_page(BuildContext context) {
    List<Container> containers = new List<Container>();
    for (var i = 0; i < driver_name.length; i++) {
      containers.add(
        Container(
          height: 250,
          child: Card(
            color: Colors.blue,
            margin: EdgeInsets.all(
                10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(
                    10))),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset("images/driver1.png", width: 50,),
                  Padding(
                    padding: EdgeInsets.only(top: 10,
                      bottom: 5,
                    ),
                  ),
                  Text(
                    'Driver :' + driver_name[i].toString(),
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Driver number: ' +
                        driver_details[driver_name[i]][1].toString(),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  Text(
                    'Driver status: ' +
                        driver_details[driver_name[i]][2].toString(),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white54,
                      fontWeight: FontWeight.w400,
                    ),

                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Radio(
                        value: 0,
                        groupValue: _radioValue,
                        onChanged: _handleRadioValueChange,
                      ),
                      new Text(
                        'Allotted',
                        style: new TextStyle(fontSize: 14.0,),
                      ),
                      new Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: _handleRadioValueChange,
                      ),
                      new Text(
                        'Vacant',
                        style: new TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
              RaisedButton(
                child: Text("Update Driver status"),
                onPressed: (){Firestore.instance.collection('driver_details').document(driver_details[driver_name[i]][3]).updateData({"status":driver_status});},
                color: Colors.black,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              )
                ],
              ),
            ),
          ),
        ),
      );
    }
    return ListView(
      children: <Widget>[
        TopContainer(
          height: 60,
          child: Column(
//                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 0, vertical: 0.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "Available drivers",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFF0D253F),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
        ...containers,
      ],
    );
  }
}
//_buildListItem2(context, document) {
//  return Card(
//    child: Hero(
//      tag: Text(document['name'].toString()),
//      child: Material(
//        child: GridTile(
//          //child: Column(
//          child: ListView(
//            children: <Widget>[
//              Image.asset(
//                "images/driver3.png",
//                width: 100.0,
//                height: 80.0,
//              ),
//              RichText(
//                text: TextSpan(
//                  text: '\n Name : ',
//                  style: DefaultTextStyle.of(context).style,
//                  children: <TextSpan>[
//                    TextSpan(
//                        text: document['name'].toString(),
//                        style: TextStyle(
//                            fontWeight: FontWeight.bold, color: Colors.black)),
//                  ],
//                ),
//              ),
//              RichText(
//                text: TextSpan(
//                  text: ' Contact : ',
//                  style: DefaultTextStyle.of(context).style,
//                  children: <TextSpan>[
//                    TextSpan(
//                        text: document['mobile'].toString(),
//                        style: TextStyle(
//                            fontWeight: FontWeight.bold, color: Colors.black)),
//                  ],
//                ),
//              ),
//              RichText(
//                text: TextSpan(
//                  text: ' Status : ',
//                  style: DefaultTextStyle.of(context).style,
//                  children: <TextSpan>[
//                    TextSpan(
//                        text: document['status'].toString(),
//                        style: TextStyle(
//                            fontWeight: FontWeight.bold, color: Colors.red)),
//                  ],
//                ),
//              )
//            ],
//          ),
//        ),
//      ),
//    ),
//  );
//}

//_buildList3(context, document) {
//  return UserAccountsDrawerHeader(
//    accountName: Text(document["name"].toString()),
//    accountEmail: Text(document["email"].toString()),
//    currentAccountPicture: GestureDetector(
//      child: new CircleAvatar(
//        backgroundColor: Colors.white,
//        child: Icon(
//          Icons.person,
//          color: Colors.orange,
//        ),
//      ),
//    ),
//    decoration: new BoxDecoration(
//      color: Colors.orange,
//    ),
//  );
//}
