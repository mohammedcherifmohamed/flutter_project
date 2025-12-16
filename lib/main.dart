import 'package:flutter/material.dart';
import 'package:flutter_project/HomePage.dart';
import 'package:flutter_project/RegisterPage.dart';
import 'package:flutter_project/LoginPage.dart';
import 'package:flutter_project/Forgot_password.dart';
import 'package:flutter_project/Info_user.dart';
import 'package:flutter_project/PizzaFormPage.dart';
import 'package:flutter_project/CartPage.dart';
import 'package:flutter_project/OrderHistoryPage.dart';
import 'package:flutter_project/OrderSuccessPage.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
          home: OrderHistoryPage() ,


    );

  }
}
