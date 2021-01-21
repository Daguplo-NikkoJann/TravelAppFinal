import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class Forget extends StatefulWidget {
  @override
  _ForgetState createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  TextEditingController email = TextEditingController();

  bool verifyButton = false;
  String verifyLink;
  Future checkemail() async {
    var response =
        await http.post("http://192.168.1.13/salon/check.php", body: {
      "email": email.text,
    });
    var link = json.decode(response.body);
    if (link == "INVALIDUSER") {
      showToast("This Email Is Not Yet Registered",
          gravity: Toast.CENTER, duration: 5);
    } else {
      setState(() {
        verifyLink = link;
        verifyButton = true;
      });
      showToast("Click Verify Button To Reset Password",
          gravity: Toast.CENTER, duration: 5);
    }
    print(link);
  }

  int newPass = 0;
  Future resetPassword() async {
    var response = await http.post(verifyLink);
    var link = json.decode(response.body);
    print(link);
    setState(() {
      newPass = link;
    });
    showToast("Your Password has been reset : $newPass",
        gravity: Toast.CENTER, duration: 5);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forget Password'),
        backgroundColor: Color(0xff083663),
      ),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              style: new TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.black),
              controller: email,
              decoration: InputDecoration(
                  labelText: 'Email',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Color(0xff083663),
                  )),
                  border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              color: Colors.green,
              onPressed: () {
                checkemail();
              },
              child: Text(
                'Recover Password',
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
            ),
          ),
          verifyButton
              ? MaterialButton(
                  color: Color(0xff083663),
                  onPressed: () {
                    resetPassword();
                  },
                  child: Text(
                    'Verify Password',
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                )
              : Container(),
          newPass == 0
              ? Container()
              : Text(
                  'New Password is : $newPass',
                  style: TextStyle(fontSize: 20.0),
                ),
        ],
      )),
    );
  }

  showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}
