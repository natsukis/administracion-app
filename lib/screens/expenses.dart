import 'package:administracion/model/product.dart';
import 'package:administracion/screens/expensetotal.dart';
import 'package:flutter/material.dart';
import 'package:administracion/screens/expensedetail.dart';
import 'package:intl/intl.dart';
import 'package:administracion/screens/picktwodates.dart';

class Expenses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Control de gastos"),
        backgroundColor: Colors.black,),
        floatingActionButton: FloatingActionButton(
            child: Text("Volver",style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.pop(context, true);
            }),
            backgroundColor: Colors.black,
        body:Padding(
      padding: EdgeInsets.only(top: 120.0, left: 5.0, right: 5.0),
      child: Center(
          child: Column(children: <Widget>[
            Padding(padding: EdgeInsets.only(top:20),
        child:Container(
            width: 180.0,
            height: 50.0,
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
                        builder: (context) => ExpenseDetail(
                            new Product("Pago", 1, 0, date(), "Pago"),
                            date())));
              },
              child: Text("Agregar nuevo gasto"),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            ))),
        Padding(padding: EdgeInsets.only(top:20),
        child:Container(
            width: 180.0,
            height: 50.0,
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
                        builder: (context) => ExpenseTotal(
                            DateTime.now(),
                            DateTime.now())));
              },
              child: Text("Gastos de hoy"),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            ))),
        Padding(padding: EdgeInsets.only(top:20),
        child:Container(
            width: 180.0,
            height: 50.0,
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
                        builder: (context) => PickTwoDate("Expenses")));
              },
              child: Text("Buscar gastos por fecha"),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            )))
      ])),
    )
    );}

  String date() {
    String date = new DateFormat.yMd().format(DateTime.now());
    return date;
  }
}
