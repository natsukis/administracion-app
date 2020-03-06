import 'package:administracion/screens/pickdate.dart';
import 'package:administracion/screens/totalsales.dart';
import 'package:flutter/material.dart';
import 'package:administracion/screens/salesofday.dart';
import 'package:intl/intl.dart';
import 'package:administracion/screens/picktwodates.dart';
import 'package:administracion/screens/expenses.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 150.0, left: 5.0, right: 5.0),
      child: Center(
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
                              builder: (context) => SalesOfDay(date())));
                    },
                    child: Text("Ventas de hoy"),
                  )),
                  Expanded(
                      child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(28.0),
                              side: BorderSide(color: Colors.blue)),
                          textColor: Colors.black,
                          color: Colors.white,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PickDate()));
                          },
                          child: Text("Ventas x dia")))
                ]),
                Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Row(children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(28.0),
                                  side: BorderSide(color: Colors.blue)),
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
                                  borderRadius: new BorderRadius.circular(28.0),
                                  side: BorderSide(color: Colors.blue)),
                              textColor: Colors.black,
                              color: Colors.white,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PickTwoDate("TotalMonth")));
                              },
                              child: Text("Total Mensual"))),
                    ])),
                Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Row(children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(28.0),
                                  side: BorderSide(color: Colors.blue)),
                              textColor: Colors.black,
                              color: Colors.white,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Expenses()));
                              },
                              child: Text("Gastos"))),
                      Expanded(
                          child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(28.0),
                                  side: BorderSide(color: Colors.blue)),
                              textColor: Colors.black,
                              color: Colors.white,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PickTwoDate("Excel")));
                              },
                              child: Text("Exportar")))
                    ]))
              ]))),
    );
  }

  String date() {
    String date = new DateFormat.yMd().format(DateTime.now());
    return date;
  }
}
