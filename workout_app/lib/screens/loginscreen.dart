import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/Components/authstate.dart';
import 'package:supabase/supabase.dart';
import '../constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late final TextEditingController _emailController;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });
    final response = await supabase.auth.signIn(
        email: _emailController.text,
        options: AuthOptions(
            redirectTo: kIsWeb
                ? null
                : 'io.supabase.flutterquickstart://login-callback/'));
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error!.message),
        backgroundColor: Colors.red,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check your email for login link!')));
    }
    setState(() {
      _emailController.clear();
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      backgroundColor: defaultLoginBackgroundColour,
    );
  }

  Widget _buildBody(context) {
    final size = MediaQuery
        .of(context)
        .size;

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
                        padding: EdgeInsets.symmetric(vertical:10, horizontal: 20.0),
                        child: TextFormField(
                          controller: _emailController,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white,),
                          decoration: InputDecoration(
                            hintText: 'Enter Email',
                            contentPadding: EdgeInsets.only(top:0),
                            hintStyle: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 0.4),
                              fontSize: 15,
                            ),
                            labelText: 'Sign-in through a magic link',
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
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
                        height: 30,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        width: size.width,
                        height: 45,
                        child: MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _signIn();
                            }
                          },
                          color: Colors.black,
                          child: Text(
                            'Login',
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
                            'Sign-up with just Email',
                            style: TextStyle(color: Colors.white,),
                              ),
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
}
/*
  Future _login() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final result = await supabase.auth.signIn(
        email: _emailController.text, password: _passwordController.text);

    if (result.data != null) {
      await sharedPreferences.setString(
          'user', result.data!.persistSessionString);
      Navigator.pushReplacementNamed(context, '/home');
    } else if (result.error?.message != null) {
      _showDialog(context, title: 'Error', message: result.error?.message);
    }
  }
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
*/