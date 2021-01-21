import 'package:flutter/material.dart';

import 'view/menu.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

enum LoginStatus { notSignIn, signIn }

class _MyHomePageState extends State<MyHomePage> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;

  String email, password;
  final _key = new GlobalKey<FormState>();
  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    debugPrint("Success");
    final response =
        await http.post("http://192.168.43.68/travelapp/login.php", body: {
      'email': email,
      'password': password,
    });

    debugPrint(response.body.toString());
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    String nameAPI = data['name'];
    String emailAPI = data['email'];
    String id = data['userid'];
    print(nameAPI);
    print(id);
    debugPrint(data.toString());
    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, nameAPI, emailAPI, id);
      });
      print(message);
      loginToast(message);
    } else {
      print(message);
      failedToast(message);
    }
  }

  loginToast(String toast) {
    return Fluttertoast.showToast(
        msg: 'You Have Sucessfully Login',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white);
  }

  failedToast(String toast) {
    return Fluttertoast.showToast(
        msg: 'Your Account Dosent Exist',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Color(0xffb5171d),
        textColor: Colors.white);
  }

  savePref(
    int value,
    String fullname,
    String email,
    String id,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt('value', value);
      preferences.setString('name', fullname);
      preferences.setString('email', email);
      preferences.setString('id', id);
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt('value');
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.setString('name', null);
      preferences.setString('email', null);
      preferences.setString('id', null);
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return new Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(110.0, 110.0, 0.0, 0.0),
                          child: Text('Travel',
                              style: TextStyle(
                                  fontSize: 80.0, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(140.0, 175.0, 0.0, 0.0),
                          child: Text('App',
                              style: TextStyle(
                                  fontSize: 80.0, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding:
                          EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Please insert email";
                              }
                              return null;
                            },
                            onSaved: (e) => email = e,
                            decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green))),
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Please insert password";
                              }
                              return null;
                            },
                            onSaved: (e) => password = e,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green))),
                            obscureText: true,
                          ),
                          SizedBox(height: 40.0),
                          Container(
                            width: 400,
                            height: 50.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(25.0),
                              shadowColor: Color(0xff083663),
                              color: Colors.blue,
                              elevation: 7.0,
                              child: MaterialButton(
                                onPressed: () {
                                  check();
                                },
                                child: Center(
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            width: 400,
                            height: 50.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(25.0),
                              shadowColor: Color(0xff083663),
                              color: Colors.white,
                              elevation: 7.0,
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Signup()));
                                },
                                child: Center(
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ));
        break;
      case LoginStatus.signIn:
        return Menu(signOut);
        break;
    }
  }
}

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _secureText = true;
  String username, password, email, name, address;

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
    }
  }

  save() async {
    debugPrint("Success");
    final response =
        await http.post("http://192.168.43.68/travelapp/register.php", body: {
      'username': username,
      'password': password,
      'email': email,
      'name': name,
      'address': address,
    });

    debugPrint(response.body.toString());
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    debugPrint(data.toString());
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
      });
      loginToast(message);
    } else {
      print(message);
      failedToast(message);
    }
  }

  loginToast(String toast) {
    return Fluttertoast.showToast(
        msg: 'You Have Sucessfully Register',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white);
  }

  failedToast(String toast) {
    return Fluttertoast.showToast(
        msg: 'Account Already Exists',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Color(0xffb5171d),
        textColor: Colors.white);
  }

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  final _key = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(110.0, 110.0, 0.0, 0.0),
                          child: Text('Travel',
                              style: TextStyle(
                                  fontSize: 80.0, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(140.0, 175.0, 0.0, 0.0),
                          child: Text('App',
                              style: TextStyle(
                                  fontSize: 80.0, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding:
                          EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            style: new TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Please insert username";
                              }
                              return null;
                            },
                            onSaved: (e) => username = e,
                            decoration: InputDecoration(
                                hintText: 'Username',
                                hintStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.normal,
                                )),
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            style: new TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Please insert password";
                              }
                              return null;
                            },
                            obscureText: _secureText,
                            onSaved: (e) => password = e,
                            decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.normal,
                                )),
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            style: new TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Please insert Email";
                              }
                              return null;
                            },
                            onSaved: (e) => email = e,
                            decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.normal,
                                )),
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            style: new TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Please insert Full name";
                              }
                              return null;
                            },
                            onSaved: (e) => name = e,
                            decoration: InputDecoration(
                                hintText: 'Full Name',
                                hintStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.normal,
                                )),
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            style: new TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Please insert Address";
                              }
                              return null;
                            },
                            onSaved: (e) => address = e,
                            decoration: InputDecoration(
                                hintText: 'Full Address',
                                hintStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.normal,
                                )),
                          ),
                          SizedBox(height: 40.0),
                          Container(
                            width: 300,
                            height: 50.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(25.0),
                              shadowColor: Colors.blueAccent,
                              color: Colors.blue,
                              elevation: 7.0,
                              child: MaterialButton(
                                onPressed: () {
                                  check();
                                },
                                child: Center(
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
