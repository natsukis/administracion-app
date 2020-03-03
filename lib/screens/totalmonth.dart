import 'package:flutter/material.dart';
import 'package:administracion/model/product.dart';
import 'package:administracion/util/dbhelper.dart';
import 'package:intl/intl.dart';

class TotalMonth extends StatefulWidget {
  DateTime dateFrom;
  DateTime dateTo;
  TotalMonth(this.dateFrom, this.dateTo);
  @override
  State<StatefulWidget> createState() => TotalMonthState(dateFrom, dateTo);
}

class TotalMonthState extends State {
  DateTime dateFrom;
  DateTime dateTo;
  TotalMonthState(this.dateFrom, this.dateTo);
  DbHelper helper = DbHelper();
  List<Product> products;
  List<Product> tarjetproduct;
  List<Product> efectproduct;
  int efectcount = 0;
  int tarjetcount = 0;
  int count = 0;
  String date;

  @override
  Widget build(BuildContext context) {
    if (products == null) {
      products = List<Product>();
      getData();
      getTarjetData();
      getEfectData();
    }
    return Scaffold(
        appBar: AppBar(
            title: Text(stringToDate(dateFrom) + " a " + stringToDate(dateTo)),
            backgroundColor: Colors.black,),
        floatingActionButton: FloatingActionButton(
            child: Text("Volver"),
            backgroundColor: Colors.black,
            onPressed: () {
              Navigator.pop(context, true);
            }),
        body: Padding(
          padding: EdgeInsets.only(top: 30.0, left: 10.0),
          child: Center(
              child: Container(
                  alignment: Alignment.center,
                  child: Column(children: <Widget>[
                    Row(children: <Widget>[
                      Expanded(
                        child: Text("Ventas del mes: "),
                      ),
                      Expanded(
                          child:
                              Text('\$' + calculateTotalSales(products, count)))
                    ]),
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(children: <Widget>[
                          Expanded(child: Text("Mas vendido:")),
                          Expanded(
                              child: Text(calculateMostSell(products, count)))
                        ])),
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(children: <Widget>[
                          Expanded(child: Text("Ventas en EFECTIVO:")),
                          Expanded(
                              child: Text('\$' +
                                  calculateTotalSales(
                                      efectproduct, efectcount)))
                        ])),
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(children: <Widget>[
                          Expanded(child: Text("Ventas en TARJETA:")),
                          Expanded(
                              child: Text('\$' +
                                  calculateTotalSales(
                                      tarjetproduct, tarjetcount)))
                        ])),
                  ]))),
        ));
  }

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final productsFuture = helper.getProduct();
      productsFuture.then((result) {
        List<Product> productList = List<Product>();
        count = result.length;
        int notInRange = 0;
        for (int i = 0; i < count; i++) {
          Product producAux = Product.fromObject(result[i]);
          if (comparedate(producAux.date)) {
            productList.add(producAux);
          } else {
            notInRange = notInRange + 1;
          }
        }
        setState(() {
          products = productList;
          count = count - notInRange;
        });
      });
    });
  }

  String stringToDate(DateTime aux) {
    return aux.day.toString() + '/' + aux.month.toString();
  }

  bool comparedate(String date) {
    DateTime dateD = new DateFormat().add_yMd().parse(date);

    if (dateD.isAfter(dateFrom) && dateD.isBefore(dateTo)) {
      return true;
    } else {
      return false;
    }
  }

  void getEfectData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final productsFuture = helper.getProduct();
      productsFuture.then((result) {
        List<Product> productList = List<Product>();
        efectcount = result.length;
        int notToday = 0;
        for (int i = 0; i < efectcount; i++) {
          Product producAux = Product.fromObject(result[i]);
          if (comparedate(producAux.date) && producAux.method == "Efectivo") {
            productList.add(producAux);
          } else {
            notToday = notToday + 1;
          }
        }
        setState(() {
          efectproduct = productList;
          efectcount = efectcount - notToday;
        });
      });
    });
  }

  void getTarjetData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final productsFuture = helper.getProduct();
      productsFuture.then((result) {
        List<Product> productList = List<Product>();
        tarjetcount = result.length;
        int notToday = 0;
        for (int i = 0; i < tarjetcount; i++) {
          Product producAux = Product.fromObject(result[i]);
          if (comparedate(producAux.date) &&
              (producAux.method == "Debito" ||
                  producAux.method == "Tarjeta" ||
                  producAux.method == "Tarjeta 1c" ||
                  producAux.method == "Tarjeta 3c")) {
            productList.add(producAux);
          } else {
            notToday = notToday + 1;
          }
        }
        setState(() {
          tarjetproduct = productList;
          tarjetcount = tarjetcount - notToday;
        });
      });
    });
  }

  String calculateTotalSales(List<Product> products, int count) {
    var total = 0;
    for (var i = 0; i < count; i++) {
      total = total + products[i].price;
    }
    return total.toString();
  }

  String calculateMostSell(List<Product> products, int count) {
    var luna = 0;
    var morellato = 0;
    var peskin = 0;
    var ilgioelio = 0;
    var pedro = 0;
    var majorica = 0;
    var otro = 0;
    for (var i = 0; i < count; i++) {
      switch (products[i].article) {
        case "Luna Garzon":
          luna = luna + products[i].price;
          break;
        case "Morellato":
          morellato = morellato + products[i].price;
          break;
        case "Il gioelio":
          ilgioelio = ilgioelio + products[i].price;
          break;
        case "Pedro":
          pedro = pedro + products[i].price;
          break;
        case "Peskin":
          peskin = peskin + products[i].price;
          break;
        case "Majorica":
          majorica = majorica + products[i].price;
          break;
        case "Otro":
          otro = otro + products[i].price;
          break;
        default:
          otro = otro + products[i].price;
          break;
      }
    }
    if (luna > morellato &&
        luna > ilgioelio &&
        luna > pedro &&
        luna > peskin &&
        luna > majorica &&
        luna > otro) {
      return "Luna Garzon";
    } else if (morellato > ilgioelio &&
        morellato > pedro &&
        morellato > peskin &&
        morellato > majorica &&
        morellato > luna &&
        morellato > otro) {
      return "Morellato";
    } else if (ilgioelio > pedro && ilgioelio > peskin && ilgioelio > otro) {
      return "Il Gioelio";
    } else if (pedro > peskin && pedro > otro) {
      return "Pedro";
    } else if (peskin > otro) {
      return "Peskin";
    }
    return "Otro";
  }
}
