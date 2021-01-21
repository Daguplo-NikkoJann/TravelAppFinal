import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Book extends StatefulWidget {
  final VoidCallback reload;
  Book(this.reload);
  @override
  _BookState createState() => _BookState();
}

class _BookState extends State<Book> {
  final _key = new GlobalKey<FormState>();
  String _val;
  String _val1;

  List _airlines = [
    'Philippine Air lines',
    'CebuPacific',
    'Air Asia',
  ];
  List _spots = [
    'Bohol',
    'Palawan',
    'Siargao',
  ];

  final DateFormat dateFormat = DateFormat('MM-dd-yyyy HH:mm');
  TimeOfDay selecttime = new TimeOfDay.now();
  Future<TimeOfDay> _selectedTime(BuildContext context) {
    return showTimePicker(context: context, initialTime: selecttime);
  }

  DateTime selectdate;
  Future<DateTime> _selectDate(BuildContext context) => showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(seconds: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(3000));

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
    }
  }

  save() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences preferences = await _prefs;
    String id = preferences.getString("id");
    String trans_dt = selectdate.toString();

    debugPrint(id);

    final response = await http.post('http://192.168.43.68/travelapp/book.php',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'clientid': int.parse(id),
          'airline': _val,
          'spots': _val1,
          'trans_dt': trans_dt
        }));
    debugPrint(response.body);
    final data = jsonDecode(response.body);
    int value = data['value'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
      });
      Fluttertoast.showToast(
          msg: 'Book successfully added',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 6,
          backgroundColor: Colors.green,
          textColor: Colors.white);
    } else {
      setState(() {
        Navigator.pop(context);
      });
      Fluttertoast.showToast(
          msg: 'Fail to Book the record',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 6,
          backgroundColor: Color(0xffb5171d),
          textColor: Colors.white);
      String message = data['message'];
      print(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          "Booking",
        ),
        backgroundColor: Color(0xff083663),
      ),
      body: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15.0, 50.0, 0.0, 0.0),
                          child: Material(
                            child: Image.asset(
                              'assets/1.jpg',
                              width: 350,
                              height: 180,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'BOOKING FORM',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w900),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Color(0xff083663), width: 1.0)),
                    child: DropdownButton(
                      hint: Text('Please select a Airlines'),
                      elevation: 5,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 36.0,
                      isExpanded: true,
                      style:
                          TextStyle(color: Color(0xff083663), fontSize: 18.0),
                      value: _val,
                      onChanged: (value) {
                        setState(() {
                          _val = value;
                        });
                      },
                      items: _airlines.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Color(0xff083663), width: 1.0)),
                    child: DropdownButton(
                      hint: Text('Please select a Spot'),
                      elevation: 5,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 36.0,
                      isExpanded: true,
                      style:
                          TextStyle(color: Color(0xff083663), fontSize: 18.0),
                      value: _val1,
                      onChanged: (value) {
                        setState(() {
                          _val1 = value;
                        });
                      },
                      items: _spots.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: InkWell(
                    onTap: () async {
                      final selectdate = await _selectDate(context);
                      if (selectdate == null) return;

                      final selecttime = await _selectedTime(context);
                      if (selecttime == null) return;

                      setState(() {
                        this.selectdate = DateTime(
                          selectdate.year,
                          selectdate.month,
                          selectdate.day,
                          selecttime.hour,
                          selecttime.minute,
                        );
                      });
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                          labelText: 'Actual Date and Time of Arrival',
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(0xff083663)))),
                      baseStyle: TextStyle(
                        fontSize: 16.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            selectdate == null
                                ? '00-00-0000 00:00'
                                : dateFormat.format(selectdate),
                            style: TextStyle(
                                fontSize: 16.0, color: Color(0xff083663)),
                          ),
                          Icon(
                            Icons.calendar_today,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Color(0xff083663)
                                    : Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 250,
                  child: RaisedButton(
                    onPressed: () {
                      check();
                    },
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    textColor: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Add Booking',
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
