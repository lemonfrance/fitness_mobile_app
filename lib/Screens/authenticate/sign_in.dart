import 'package:flutter/material.dart';
import 'package:wearable_intelligence/Services/auth.dart';
import 'package:wearable_intelligence/loading.dart';
import 'package:wearable_intelligence/styles.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({required this.toggleView});

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
              backgroundColor: Colours.white,
              elevation: 0.0,
              title: Text('Sign In'),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        hintText: 'Enter your email',
                      ),
                      validator: (val) => val!.isEmpty ? 'Enter your email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        hintText: 'Enter your password',
                      ),
                      validator: (val) => val!.length < 6 ? 'Enter a password with 6+ chars' : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    MaterialButton(
                        minWidth: 500,
                        height: 60,
                        elevation: 10,
                        shape: StadiumBorder(),
                        color: Colours.highlight,
                        child: Text('Sign In', style: TextStyle(color: Colours.white)),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _auth.signInWithEmailAndPassword(email, password);
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
                      onPressed: (() => widget.toggleView()),
                      child: Text(
                        'Done have an account? Sign Up',
                        style: TextStyle(color: Colours.black),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0))
                  ],
                ),
              ),
            ),
          );
  }
}
