import 'package:flutter/material.dart';
import 'package:medapollo/Screens/LoginPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  _loadingPage() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Apollo',
      theme: ThemeData.dark().copyWith(),
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Allo',
        theme: ThemeData(fontFamily: 'Inter'),
        home: LoginPage());
  }
}
