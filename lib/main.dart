import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workerlocatorapp/providers/auth.dart';
import 'package:workerlocatorapp/screens/home.dart';
import 'package:workerlocatorapp/screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Auth(),
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          //auth.isAuth it coming from auth.dart
          home: auth.isAuth
              ? HomeScreen()
              : FutureBuilder(
                  future: auth.tryautoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? CircularProgressIndicator()
                          : LoginPage(),
                ),
        ),
      ),
    );
  }
}
