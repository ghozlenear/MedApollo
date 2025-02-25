import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medapollo/Constant.dart';
import 'package:medapollo/Screens/RegisterPage.dart';
import 'package:medapollo/Services/API.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: (MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top) *
                      0.2,
                  width: double.infinity,
                  child: Center(
                      child: Text(
                    "Log in",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  )),
                ),
                Container(
                  height: (MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top) *
                      0.25,
                  padding: EdgeInsets.all(16.0),
                  width: double.infinity,
                  child: Column(
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          label: Text("email"),
                          prefixIcon: Icon(Icons.email_rounded),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          label: Text("password"),
                          prefixIcon: Icon(Icons.lock),
                        ),
                      )
                    ],
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      child: loading
                          ? CircularProgressIndicator()
                          : Text(
                              'Log in',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                      onPressed: () {
                        setState(() {
                          loading = true;
                        });
                        _login();
                        setState(() {
                          loading = false;
                        });
                      },
                      style: ButtonStyle(
                          padding: MaterialStatePropertyAll(EdgeInsets.all(8)),
                          backgroundColor:
                              MaterialStatePropertyAll(Constant.Green)),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      child: Text(
                        'Create new account',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => const RegisterPage()),
                          ),
                        );
                      },
                      style: ButtonStyle(
                          padding: MaterialStatePropertyAll(EdgeInsets.all(8)),
                          backgroundColor:
                              MaterialStatePropertyAll(Constant.Green)),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "Forget your"),
                  TextSpan(text: "password?")
                ])),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _login() async {
    bool check =
        emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    if (check) {
      await API.login(emailController.text, passwordController.text, context);
    } else {
      Fluttertoast.showToast(msg: "please fill all fields");
    }
  }
}
