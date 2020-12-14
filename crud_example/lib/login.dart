import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {

  @override
  State createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  String name = "";
  @override
  void initState() {
    print("init state");
    User user = FirebaseAuth.instance.currentUser;
    if(user != null) {
      name = user.displayName;
      Navigator.popAndPushNamed(context, "/homepage");
    }
    super.initState();
  }

  void doLogin() {
    setState(() {
      getUser().then((user) => {
        Navigator.pushReplacementNamed(context, '/homepage')
      }).catchError((e) => print(e.toString()));
    });
  }

  Future<User> getUser() async {
    GoogleSignInAccount googleSignInAccount = await GoogleSignIn().signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken
    );
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    User user = userCredential.user;
    setState(() {
      name = user.displayName;
    });
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Page"),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(child: Text("Login with Google"), onPressed: doLogin,),
          ],
        ),
      ),
    );
  }
}