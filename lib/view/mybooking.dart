import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:travel_app/model/bookdetails.dart';

import 'book.dart';
import 'editbook.dart';

class Myappoint extends StatefulWidget {
  @override
  _MyappointState createState() => _MyappointState();
}

class _MyappointState extends State<Myappoint> {
  var loading = false;
  final list = new List<Bookdetails>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences preferences = await _prefs;
    String id = preferences.getString("id");
    final response = await http.get("http://192.168.43.68/travelapp/read.php");
    debugPrint(response.body);
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new Bookdetails(
          api['id'],
          api['airline'],
          api['spots'],
          api['trans_dt'],
          api['clientid'],
        );

        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  dialogDelete(String id) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  "Are you sure want to delete this booking?",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text("No")),
                    SizedBox(
                      width: 16.0,
                    ),
                    InkWell(
                        onTap: () {
                          _delete(id);
                        },
                        child: Text("Yes")),
                  ],
                )
              ],
            ),
          );
        });
  }

  _delete(String id) async {
    final response = await http.post(
        "http://192.168.43.68/travelapp/deletebook.php",
        body: {"clientid": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        _lihatData();
      });
    } else {
      print(pesan);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Booked"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Book(_lihatData)));
        },
      ),
      body: RefreshIndicator(
        onRefresh: _lihatData,
        key: _refresh,
        child: loading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Plane On Board:\t' + x.airline,
                                  style: TextStyle(fontSize: 17.0)),
                              Text('Spot:\t' + x.spots,
                                  style: TextStyle(fontSize: 17.0)),
                              Text('Date & Time :\t' + x.trans_dt,
                                  style: TextStyle(fontSize: 17.0)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Editbook(x, _lihatData)));
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            dialogDelete(x.id);
                          },
                          icon: Icon(Icons.delete),
                        )
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
