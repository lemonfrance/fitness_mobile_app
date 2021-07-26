import 'package:flutter/material.dart';
import 'package:wearable_intelligence/Services/auth.dart';
import 'package:wearable_intelligence/loading.dart';
import 'package:wearable_intelligence/styles.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String passwordConfirm = '';
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
              title: Text('Sign up to Wearable Intel'),
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
                            validator: (val) => val!.isEmpty ? 'Invalid email' : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            }),
                        SizedBox(height: 20.0),
                        TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              hintText: 'Enter a password',
                            ),
                            validator: (val) => val!.length < 6 ? 'Password must have  6+ characters' : null,
                            onChanged: (val) {
                              setState(() => password = val);
                            }),
                        SizedBox(height: 20.0),
                        TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              hintText: 'Re-enter your password',
                            ),
                            validator: (val) => val != password ? 'Password does not match' : null,
                            onChanged: (val) {
                              setState(() => passwordConfirm = val);
                            }),
                        SizedBox(height: 20.0),
                        MaterialButton(
                            minWidth: 500,
                            height: 60,
                            elevation: 10,
                            shape: StadiumBorder(),
                            color: Colours.highlight,
                            child: Text('Register', style: TextStyle(color: Colours.white)),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => loading = true);
                                dynamic result = await _auth.registerUserWithEmailAndPassword(email, password);
                                if (result == null) {
                                  setState(() {
                                    error = 'invalid credentials';
                                    loading = false;
                                  });
                                }
                              }
                            }),
                        SizedBox(height: 10.0),
                        MaterialButton(child: Text('Have an account? Sign In'), onPressed: (() => widget.toggleView())),
                        SizedBox(height: 12.0),
                        Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0))
                      ],
                    ))),
          );
  }
}
