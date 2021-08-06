import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase/supabase.dart';

import '../constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}


class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      backgroundColor: defaultLoginBackgroundColour,
    );
  }

  Widget _buildBody(context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 120,
          ),
          Container(
            height: 60,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: ExactAssetImage('assets/logo.png'),
              ),
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Card(
              color: SideBarColour,
              elevation: 1,
              child: Container(
                padding: EdgeInsets.only(bottom: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          controller: _emailController,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            labelStyle: TextStyle(color: Colors.white),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                            ),
                          ),
                          validator: (String? value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Invalid e-mail';
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          controller: _passwordController,
                          cursorColor: Colors.white,
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.white),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                            ),
                          ),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Invalid password';
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          cursorColor: Colors.white,
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(color: Colors.white),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                            ),
                          ),
                          validator: (String? value) {
                            if (value!.isEmpty ||
                                value != _passwordController.text) {
                              return 'Passwords don\'t match';
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        width: size.width,
                        height: 45,
                        child: MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _register();
                            }
                          },
                          color: Colors.black,
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(color: Colors.white,),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future _register() async {
    final result = await GetIt.instance<SupabaseClient>()
        .auth
        .signUp(_emailController.text, _passwordController.text);

    if (result.data != null) {
      Navigator.pushReplacementNamed(context, '/login');
      _showDialog(context, title: 'Success', message: 'Register Successful');
    } else if (result.error?.message != null) {
      _showDialog(context, title: 'Error', message: result.error?.message);
    }

    setState(() {});
  }

  void _showDialog(context, {String? title, String? message}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title ?? ''),
          content: new Text(message ?? ''),
          actions: <Widget>[
            new MaterialButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
