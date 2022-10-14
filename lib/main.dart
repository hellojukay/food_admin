import 'package:flutter/material.dart';
import 'package:food_admin/modes/food.dart';
import 'package:food_admin/pages/admin.dart';
import 'package:food_admin/utils/http.dart';

void main() async {
  FoodMenu menu = await loadFood();
  runApp(MyApp(
    menu: menu,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.menu, super.key});
  final FoodMenu? menu;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '菜单管理',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Admin(menu: menu),
    );
  }
}
