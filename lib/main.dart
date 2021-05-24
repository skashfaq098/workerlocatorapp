import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workerlocatorapp/providers/auth.dart';
import 'package:workerlocatorapp/providers/getMyApplication_provider.dart';
import 'package:workerlocatorapp/providers/getMyPost_provider.dart';
import 'package:workerlocatorapp/providers/post_provider.dart';
import 'package:workerlocatorapp/screens/home_screen.dart';
import 'package:workerlocatorapp/screens/login_screen.dart';
import 'package:workerlocatorapp/screens/posts_screen.dart';
import 'package:workerlocatorapp/screens/signup_screen.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider<PostProvider>(
            create: (context) => PostProvider()),
        ChangeNotifierProvider<ApplicationProvider>(
            create: (context) => ApplicationProvider()),
        ChangeNotifierProvider<MyPostProvider>(
            create: (context) => MyPostProvider()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                primary: Color(0xff0abde3),
              ),
            ),
          ),
          //auth.isAuth it coming from auth.dart
          home: auth.isAuth
              ? HomeScreen()
              : FutureBuilder(
                  future: auth.tryautoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? Center(child: CircularProgressIndicator())
                          : LoginPage(),
                ),
        ),
      ),
    );
  }
}
