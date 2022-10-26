import 'package:flutter/material.dart';
import 'package:productos_app/pages/home_page.dart';
import 'package:productos_app/pages/login_page.dart';
import 'package:productos_app/pages/producto_page.dart';
import 'package:productos_app/services/producto_service.dart';
import 'package:provider/provider.dart';

void main() => runApp(AppState());

class AppState extends StatelessWidget {
  // const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductoService())
      ],
      child: MyApp(),
    );
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productos DS01SV-21',
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'login': (_) => LoginPage(),
        'home': (_) => HomePage(),
        'producto': (_) => ProductoPage(),
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: AppBarTheme(
          color: Colors.indigo,
          elevation:0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          elevation:0,
        )
      ),
    );
  }
}