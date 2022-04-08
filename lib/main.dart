import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pinterest/pages/detail_page.dart';
import 'package:pinterest/pages/home_page.dart';
import 'package:pinterest/pages/profile_page.dart';
import 'package:pinterest/pages/search_page.dart';
import 'package:pinterest/pages/sms_page.dart';
import 'servises/setting_hive_servise.dart';

void main()async {
  await Hive.initFlutter();
  await Hive.openBox(DBService.dbName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: DBService.box.listenable(),
        builder: (context, box, widget) {
          return MaterialApp(
            themeMode: DBService.loadMode() ? ThemeMode.light : ThemeMode.dark,
            darkTheme: ThemeData.dark(),
            theme: ThemeData.light(),
            home: HomePage(),
            debugShowCheckedModeBanner: false,
            routes: {
              HomePage.id: (context) => HomePage(),
              Searchpage.id: (context) => Searchpage(),
              ProfilePage.id: (context) => ProfilePage(),
              DetailPage.id: (context) => DetailPage(),
              SmsPage.id: (context) => SmsPage(),
            },
          );
        }
    );
  }
}
