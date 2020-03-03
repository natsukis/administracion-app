import 'package:administracion/screens/menu.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Control App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Control de Ventas'),
        debugShowCheckedModeBanner: false);
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          Image.asset(
            "images/honorablack.jpg",
            height: 250,//MediaQuery.of(context).size.height,
            width: 300,//MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            alignment:Alignment.center
          ),Scaffold(
            backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
                elevation: 0.0,
          title: Text(widget.title),
        ),
        body: Menu())]);
  }
}
