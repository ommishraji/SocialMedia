import 'package:flutter/material.dart';
import 'package:socialmedia/Services/apicall.dart';
import 'package:socialmedia/screens/homeScreen.dart';

void main() {
  runApp(const MyApp());
  apiCall apicall = apiCall();
  apicall.MultipleCallToSave();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: homeScreen(),
    );
  }
}