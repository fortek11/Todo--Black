import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_black_todo/core/google_auth.dart';

final _firebase = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<FormState>();
  bool _createAccount = false;
  void submitForm() async {
    final _isValid = _key.currentState!.validate();
    if (!_isValid) {
      return;
    }
    _key.currentState!.save();
    if (_createAccount) {
      //newuser
      try {
        final _credentials = await _firebase.createUserWithEmailAndPassword(
            email: _email, password: _pass);
        print(_credentials);
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Failed, Try Again')));
      }
    }
    if (!_createAccount) {
      try {
        final _credentials = await _firebase.signInWithEmailAndPassword(
          email: _email,
          password: _pass,
        );
        print(_credentials);
      } on FirebaseException catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message ?? 'Failed, Try Again')));
      }
    }
  }

  bool _isLoading = false;

  var _email = '';
  var _pass = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 80,
              ),
              Image.asset('assets/Colorful Sound Waves Music App Logo.png',
                  fit: BoxFit.fill),
              Card(
                color: Colors.white,
                elevation: 20,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                margin: EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                      key: _key,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(!_createAccount ? 'Login' : 'Create Account',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            onSaved: (newValue) {
                              _email = newValue!;
                            },
                            validator: (value) {
                              //validate on save
                              if (value == null || value.isEmpty) {
                                return 'Invalid Email';
                              }
                              return null;
                            },
                            autofocus: false,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Email'),
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid PassWord';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _pass = newValue!;
                            },
                            //hide passowrd
                            obscureText: true,
                            autocorrect: false,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              submitForm();
                            },
                            child: Text("Submit",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 100),
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextButton(
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0))),
                              onPressed: () {
                                setState(() {
                                  _createAccount = !_createAccount;
                                });
                              },
                              child: Text(
                                !_createAccount ? 'Create Account' : 'Login',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))
                        ],
                      )),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                indent: 60,
                endIndent: 60,
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });
                    GoogleAuthServ().signInWithGoo();
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 20,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      foregroundColor: Colors.white,
                      backgroundColor: _isLoading ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child: !_isLoading
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 20,
                                child: Image.asset('assets/google.png'),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              const Text('Continue With Google'),
                              const SizedBox(
                                width: 30,
                              ),
                            ],
                          ),
                        )
                      : Container(
                          width: 200,
                          child: LinearProgressIndicator(
                            color: Colors.black,
                          ),
                        )),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}
