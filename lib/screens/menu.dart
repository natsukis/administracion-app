import 'package:administracion/screens/pickdate.dart';
import 'package:administracion/screens/pickdatefilter.dart';
import 'package:administracion/screens/totalsales.dart';
import 'package:flutter/material.dart';
import 'package:administracion/screens/salesofday.dart';
import 'package:intl/intl.dart';
import 'package:administracion/screens/picktwodates.dart';
import 'package:administracion/screens/expenses.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Image.asset("images/honorablack.jpg",
          height: 250, //MediaQuery.of(context).size.height,
          width: 300, //MediaQuery.of(context).size.wi
          fit: BoxFit.cover,
          alignment: Alignment.center),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("Control de Gastos"),
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 150.0, left: 5.0, right: 5.0),
            child: Center(
                child: SingleChildScrollView(
                    child: Container(
                        alignment: Alignment.center,
                        child: Column(children: <Widget>[
                          Row(children: <Widget>[
                            Expanded(
                                child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(28.0),
                                  side: BorderSide(color: Colors.blueAccent)),
                              textColor: Colors.black,
                              color: Colors.white,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SalesOfDay(date())));
                              },
                              child: Text("Ventas de hoy"),
                            )),
                            Expanded(
                                child: RaisedButton(
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(28.0),
                                        side: BorderSide(color: Colors.blue)),
                                    textColor: Colors.black,
                                    color: Colors.white,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PickDate()));
                                    },
                                    child: Text("Ventas x dia")))
                          ]),
                          Padding(
                              padding: EdgeInsets.only(top: 25),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: RaisedButton(
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(28.0),
                                            side:
                                                BorderSide(color: Colors.blue)),
                                        textColor: Colors.black,
                                        color: Colors.white,
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TotalSales(date())));
                                        },
                                        child: Text("Totales"))),
                                Expanded(
                                    child: RaisedButton(
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(28.0),
                                            side:
                                                BorderSide(color: Colors.blue)),
                                        textColor: Colors.black,
                                        color: Colors.white,
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PickTwoDate(
                                                          "TotalMonth")));
                                        },
                                        child: Text("Total Mensual"))),
                              ])),
                          Padding(
                              padding: EdgeInsets.only(top: 25),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: RaisedButton(
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(28.0),
                                            side:
                                                BorderSide(color: Colors.blue)),
                                        textColor: Colors.black,
                                        color: Colors.white,
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Expenses()));
                                        },
                                        child: Text("Gastos"))),
                                Expanded(
                                    child: RaisedButton(
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(28.0),
                                            side:
                                                BorderSide(color: Colors.blue)),
                                        textColor: Colors.black,
                                        color: Colors.white,
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PickDateFilter()));
                                        },
                                        child: Text("Movimientos")))
                              ]))
                        ])))),
          ),
          drawer: Drawer(
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child:Container(
              color: Colors.black,
              child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  color: Colors.black,
                    height: 150.0,
                    width: 50,
                    child: DrawerHeader(
                      child: Image.asset("images/honorablack.jpg",
                          height: 50, //MediaQuery.of(context).size.height,
                          width: 50, //MediaQuery.of(context).size.wi
                          fit: BoxFit.cover,
                          alignment: Alignment.center),
                    ),
                    margin: EdgeInsets.all(0.0),
                    padding: EdgeInsets.all(0.0)),
                Container(
              color: Colors.white,
              child:ListTile(
                  title: Text('Exportar', style: TextStyle(color: Colors.black),),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PickTwoDate("Excel")));
                  },
                )),
              ],
            )),
          ))
    ]);
  }

  String date() {
    String date = new DateFormat.yMd().format(DateTime.now());
    return date;
  }
}
