// ignore_for_file: constant_identifier_names

// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../models/auth.dart';

enum AuthMode { SignUp, SignIn }

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);
  static const routeName = "/auth-page";
  @override
  Widget build(BuildContext context) {
    // var diviceSize = MediaQuery.of(context).size;
    //   return Scaffold(
    //     body: Stack(
    //       children: [
    //         Container(
    //           decoration: BoxDecoration(
    //             gradient: LinearGradient(
    //               colors: [
    //                 const Color.fromARGB(255, 251, 89, 146).withOpacity(0.9),
    //                 const Color.fromARGB(255, 221, 65, 65).withOpacity(0.5),
    //               ],
    //               begin: Alignment.topLeft,
    //               end: Alignment.bottomRight,
    //               stops: const [0, 1],
    //             ),
    //           ),
    //         ),
    //         SingleChildScrollView(
    //           child: SizedBox(
    //             height: diviceSize.height,
    //             width: diviceSize.width,
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 Flexible(
    //                   child: Container(
    //                     margin: const EdgeInsets.only(bottom: 20),
    //                     padding: const EdgeInsets.symmetric(
    //                         vertical: 8, horizontal: 94),
    //                     transform: Matrix4.rotationZ(-8 * pi / 180)
    //                       ..translate(-10.0),
    //                     decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(20),
    //                       color: Colors.blueAccent.shade700,
    //                       boxShadow: const [
    //                         BoxShadow(
    //                           blurRadius: 8,
    //                           color: Colors.black26,
    //                           offset: Offset(0, 2),
    //                         )
    //                       ],
    //                     ),
    //                     child: const Text(
    //                       "My Quens Shop",
    //                       style: TextStyle(
    //                         color: Colors.white,
    //                         fontSize: 45,
    //                         fontFamily: 'Anton',
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                       textAlign: TextAlign.center,
    //                     ),
    //                   ),
    //                 ),
    //                 Flexible(
    //                   flex: diviceSize.width > 600 ? 2 : 1,
    //                   child: const AuthCard(),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Shop App",
                  style: GoogleFonts.oswald(
                    fontSize: 62,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      const Shadow(
                        offset: Offset(3.0, 4.0),
                        blurRadius: 3.0,
                        color: Color.fromARGB(255, 160, 142, 142),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Welcome, thank you for choosing us',
                  style: GoogleFonts.merienda(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const AuthCard()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.SignIn;
  // ignore: prefer_final_fields
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _handleError(String error) {
    String errorMessage = "Authentication failed ";
    if (error.contains('email-already-in-use')) {
      errorMessage = ' This email is already in use';
    } else if (error.contains('account-exists-with-different-credential')) {
      errorMessage = ' This account already exists with different credential';
    } else if (error.contains('too-many-requests')) {
      errorMessage = ' There are too many requests to this email address';
    } else if (error.contains('wrong-password')) {
      errorMessage = ' Wrong password was entered';
    } else if (error.contains('network-request-failed')) {
      errorMessage = ' Network request failed';
    } else if (error.contains('invalid-email')) {
      errorMessage = ' Invalid email was entered';
    } else if (error.contains('user-disabled')) {
      errorMessage = 'You are not allowed to login to the system.';
    } else if (error.contains('user-not-found')) {
      errorMessage = 'You are not registered with the system';
    }

    showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: const Text('An Error Occurred!'),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              )
            ],
          )),
    );
    return;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_authMode == AuthMode.SignIn) {
      try {
        await Provider.of<Auth>(context, listen: false)
            .singin(_authData['email']!.trim(), _authData['password']!.trim());
      } catch (error) {
        _handleError(error.toString());
      }
    } else {
      try {
        await Provider.of<Auth>(context, listen: false)
            .singup(_authData['email']!.trim(), _authData['password']!.trim())
            .then((value) => _switchMode());
      } catch (error) {
        _handleError(error.toString());
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchMode() {
    if (_authMode == AuthMode.SignIn) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.SignIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var diviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        width: diviceSize.width * 0.75,
        height: _authMode == AuthMode.SignUp ? 360 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.SignUp ? 300 : 200),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty ||
                        !value.contains('@') ||
                        !value.contains('.')) {
                      return 'Invalid email address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return 'Wrong Password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                if (_authMode == AuthMode.SignUp)
                  TextFormField(
                    enabled: _authMode == AuthMode.SignUp,
                    decoration:
                        const InputDecoration(labelText: 'Confirm password'),
                    obscureText: true,
                    validator: (value) {
                      if (_passwordController.text != value) {
                        return 'password does not match';
                      } else if (value!.length <= 5) {
                        return 'password is too short';
                      }
                      return null;
                    },
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 30,
                        )),
                    child: Text(
                      _authMode == AuthMode.SignIn ? "SignIn" : "SignUp",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                TextButton(
                  onPressed: _switchMode,
                  style: TextButton.styleFrom(
                      primary: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: Text(
                      '${_authMode == AuthMode.SignIn ? "SignIn" : "SignUp"} Instead'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
