import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:travel_app/Widget/airlinescard.dart';

import 'package:travel_app/Widget/constant.dart';
import 'package:travel_app/Widget/custom_list_tile.dart';
import 'package:travel_app/Widget/spots.dart';
import 'package:travel_app/model/Airlines.dart';

import 'package:travel_app/model/spots.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      image: AssetImage("assets/1.jfif"),
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
