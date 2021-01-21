import 'package:flutter/material.dart';
import 'package:travel_app/model/Airlines.dart';

import 'constant.dart';

class AirlinesCard extends StatelessWidget {
  final Airlines airlines;
  AirlinesCard({this.airlines});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      // color: Colors.red,
      margin: EdgeInsets.only(left: 18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 130.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.0),
              image: DecorationImage(
                image: AssetImage(airlines.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 100.0,
                child: Text(
                  airlines.name,
                  overflow: TextOverflow.ellipsis,
                  style: kTitleItem,
                ),
              ),
            ],
          ),
          // Text(barbershop.address,
          //     overflow: TextOverflow.ellipsis, style: kTitleItem),
        ],
      ),
    );
  }
}
