import 'package:assesment/screens/home_page.dart';
import 'package:assesment/services/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

void main() async{

    await GetStorage.init();
  await AppPathProvider.initPath();
  runApp(  MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: HomePage(),
    );
  }
}
