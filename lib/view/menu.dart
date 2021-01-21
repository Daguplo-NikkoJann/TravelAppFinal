import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_app/Widget/airlinescard.dart';

import 'package:travel_app/Widget/constant.dart';
import 'package:travel_app/Widget/custom_list_tile.dart';
import 'package:travel_app/Widget/spots.dart';
import 'package:travel_app/model/Airlines.dart';
import 'package:travel_app/model/spots.dart';

import 'book.dart';
import 'mybooking.dart';

class Menu extends StatefulWidget {
  final VoidCallback signOut;
  Menu(this.signOut);
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  String name = "", email = "";
  getpref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString("name");
      email = preferences.getString("email");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getpref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          "Travel App",
        ),
        backgroundColor: Color(0xff083663),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("$name", style: TextStyle(fontSize: 20.0)),
              accountEmail: Text("$email", style: TextStyle(fontSize: 20.0)),
              decoration: BoxDecoration(color: Color(0xff083663)),
            ),
            ListTile(
              title: Text('Add Booking', style: TextStyle(fontSize: 20.0)),
              trailing: Icon(Icons.book),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Myappoint()));
              },
            ),
            Divider(),
            ListTile(
              title: Text('Sign out', style: TextStyle(fontSize: 20.0)),
              trailing: Icon(Icons.exit_to_app),
              onTap: () {
                signOut();
                Fluttertoast.showToast(
                    msg: 'You Have Sucessfully Logout',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 5,
                    backgroundColor: Colors.green,
                    textColor: Colors.white);
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ClipPath(
                clipper: OvalBottomBorderClipper(),
                child: Container(
                  width: double.infinity,
                  height: 305.0,
                  padding: EdgeInsets.only(bottom: 50.0),
                  decoration: BoxDecoration(
                    color: kYellow,
                    image: DecorationImage(
                      image: AssetImage("assets/1.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AppBar(
                        backgroundColor: Colors.black12.withOpacity(.0),
                        elevation: 0.0,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              CustomListTile(title: "Best Places"),
              SizedBox(height: 25.0),
              Container(
                width: double.infinity,
                height: 150.0,
                child: ListView.builder(
                  itemCount: bestList.length,
                  scrollDirection: Axis.horizontal,
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var spots = bestList[index];
                    return SpotsCard(spots: spots);
                  },
                ),
              ),
              SizedBox(height: 30.0),
              CustomListTile(title: "Best Airlines"),
              SizedBox(height: 25.0),
              Container(
                width: double.infinity,
                height: 150.0,
                child: ListView.builder(
                  itemCount: bestList1.length,
                  scrollDirection: Axis.horizontal,
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var airlines = bestList1[index];
                    return AirlinesCard(airlines: airlines);
                  },
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
