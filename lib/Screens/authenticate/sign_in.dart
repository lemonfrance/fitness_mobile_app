import 'package:flutter/material.dart';
import 'package:wearable_intelligence/Services/auth.dart';
import 'package:wearable_intelligence/styles.dart';
import 'package:wearable_intelligence/loading.dart';


import '../../Services/fitbit.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;



  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colours.white,
            appBar: AppBar(
              backgroundColor: Colours.darkBlue,
              elevation: 0.0,
              title: Text('Sign into Wearable Intel'),
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Enter your email',
                            ),
                            validator: (val) =>
                                val.isEmpty ? 'Enter your email' : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            }),
                        SizedBox(height: 20.0),
                        TextFormField(
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Enter your password',
                            ),
                            validator: (val) => val.length < 6
                                ? 'Enter a password with 6+ chars'
                                : null,
                            onChanged: (val) {
                              setState(() => password = val);
                            }),
                        SizedBox(height: 20.0),
                        MaterialButton(
                            color: Colours.highlight,
                            child: Text('Sign In',
                                style: TextStyle(color: Colours.white)),
                            onPressed: () async {

                              if (_formKey.currentState.validate()) {
                                setState(() => loading = true);
                                dynamic result =
                                    await _auth.signInWithEmailAndPassword(
                                        email, password);
                                if (result == null) {
                                  setState(() {
                                    error = 'invalid credentials';
                                    loading = false;
                                  });
                                }
                              }
                            }),
                        SizedBox(height: 10.0),
                        MaterialButton(
                          color: Colours.lightBlue,
                          onPressed: (() => widget.toggleView()),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(color: Colours.white),
                          ),
                        ),
                        SizedBox(height: 12.0),
                        Text(error,
                            style: TextStyle(color: Colors.red, fontSize: 14.0))
                      ],
                    ))),
          );
  }
}
