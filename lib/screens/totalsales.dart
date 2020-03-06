import 'package:flutter/material.dart';
import 'package:administracion/model/product.dart';
import 'package:administracion/util/dbhelper.dart';
import 'package:intl/intl.dart';

class TotalSales extends StatefulWidget {
  String date;
  TotalSales(this.date);
  @override
  State<StatefulWidget> createState() => TotalSalesState(date);
}

class TotalSalesState extends State {
  DbHelper helper = DbHelper();
  List<Product> products;
  List<Product> weekproduct;
  List<Product> monthproduct;
  List<Product> tarjetproduct;
  List<Product> efectproduct;
  List<Product> expenseproduct;
  List<Product> monthexpenseproduct;
  int efectcount = 0;
  int tarjetcount = 0;
  int weekcount = 0;
  int monthcount = 0;
  int count = 0;
  int expensecount = 0;
  int monthexpensecount = 0;
  String date;
  TotalSalesState(this.date);

  @override
  Widget build(BuildContext context) {
    if (products == null) {
      products = List<Product>();
      getData();
      getWeekData();
      getMonthData();
      getEfectData();
      getTarjetData();
      getExpensetData();
      getMonthExpenseData();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(stringToDate(date)),
          backgroundColor: Colors.black,
        ),
        floatingActionButton: FloatingActionButton(
            child: Text("Volver"),
            backgroundColor: Colors.black,
            onPressed: () {
              Navigator.pop(context, true);
            }),
        body: Padding(
          padding: EdgeInsets.only(top: 50.0, left: 20.0),
          child: Center(
              child: Container(
                  alignment: Alignment.center,
                  child: Column(children: <Widget>[
                    Row(children: <Widget>[
                      Expanded(
                        child: Text("Ventas del dia BRUTO: "),
                      ),
                      Expanded(
                          child:
                              Text('\$' + calculateTotalSales(products, count)))
                    ]),
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(children: <Widget>[
                          Expanded(child: Text("Gastos de hoy:")),
                          Expanded(
                              child: Text('\$' +
                                  calculateTotalSales(
                                      expenseproduct, expensecount)))
                        ])),
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(children: <Widget>[
                          Expanded(child: Text("Ventas del dia NETO: ")),
                          Expanded(
                              child: Text('\$' +
                                  calculateTotal(products, count,
                                      expenseproduct, expensecount)))
                        ])),
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(children: <Widget>[
                          Expanded(child: Text("Mas vendido hoy:")),
                          Expanded(
                              child: Text(calculateMostSell(products, count)))
                        ])),
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(children: <Widget>[
                          Expanded(child: Text("Ventas en EFECTIVO hoy:")),
                          Expanded(
                              child: Text('\$' +
                                  calculateTotalSales(
                                      efectproduct, efectcount)))
                        ])),
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(children: <Widget>[
                          Expanded(child: Text("Ventas en TARJETA hoy:")),
                          Expanded(
                              child: Text('\$' +
                                  calculateTotalSales(
                                      tarjetproduct, tarjetcount)))
                        ])),
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(children: <Widget>[
                          Expanded(child: Text("Ventas ult. 7 dias:")),
                          Expanded(
                              child: Text('\$' +
                                  calculateTotalSales(weekproduct, weekcount)))
                        ])),
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(children: <Widget>[
                          Expanded(child: Text("Ventas ult. 30 dias:")),
                          Expanded(
                              child: Text('\$' +
                                  calculateTotalSales(
                                      monthproduct, monthcount)))
                        ])),
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(children: <Widget>[
                          Expanded(child: Text("Gastos ult. 30 dias:")),
                          Expanded(
                              child: Text('\$' +
                                  calculateTotalSales(
                                      monthexpenseproduct, monthexpensecount)))
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
        int notToday = 0;
        for (int i = 0; i < count; i++) {
          Product producAux = Product.fromObject(result[i]);
          if (producAux.date == date && producAux.method != "Pago") {
            productList.add(producAux);
          } else {
            notToday = notToday + 1;
          }
        }
        setState(() {
          products = productList;
          count = count - notToday;
        });
      });
    });
  }

  void getWeekData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final productsFuture = helper.getProduct();
      productsFuture.then((result) {
        List<Product> productList = List<Product>();
        weekcount = result.length;
        int notToday = 0;
        for (int i = 0; i < weekcount; i++) {
          Product producAux = Product.fromObject(result[i]);
          DateTime tempDate = DateFormat().add_yMd().parse(producAux.date);
          var diff = DateTime.now().difference(tempDate);
          if (diff.inDays <= 7 && producAux.method != "Pago") {
            productList.add(producAux);
          } else {
            notToday = notToday + 1;
          }
        }
        setState(() {
          weekproduct = productList;
          weekcount = weekcount - notToday;
        });
      });
    });
  }

  void getMonthData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final productsFuture = helper.getProduct();
      productsFuture.then((result) {
        List<Product> productList = List<Product>();
        monthcount = result.length;
        int notToday = 0;
        for (int i = 0; i < monthcount; i++) {
          Product producAux = Product.fromObject(result[i]);
          DateTime tempDate = DateFormat().add_yMd().parse(producAux.date);
          var diff = DateTime.now().difference(tempDate);
          if (diff.inDays <= 30 && producAux.method != "Pago") {
            productList.add(producAux);
          } else {
            notToday = notToday + 1;
          }
        }
        setState(() {
          monthproduct = productList;
          monthcount = monthcount - notToday;
        });
      });
    });
  }

  void getMonthExpenseData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final productsFuture = helper.getProduct();
      productsFuture.then((result) {
        List<Product> productList = List<Product>();
        monthexpensecount = result.length;
        int notToday = 0;
        for (int i = 0; i < monthexpensecount; i++) {
          Product producAux = Product.fromObject(result[i]);
          DateTime tempDate = DateFormat().add_yMd().parse(producAux.date);
          var diff = DateTime.now().difference(tempDate);
          if (diff.inDays <= 30 &&
              (producAux.method == "Pago")) {
            productList.add(producAux);
          } else {
            notToday = notToday + 1;
          }
        }
        setState(() {
          monthexpenseproduct = productList;
          monthexpensecount = monthexpensecount - notToday;
        });
      });
    });
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
          if (producAux.method == "Efectivo" && producAux.date == date) {
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
          if (producAux.date == date &&
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

  void getExpensetData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final productsFuture = helper.getProduct();
      productsFuture.then((result) {
        List<Product> productList = List<Product>();
        expensecount = result.length;
        int notToday = 0;
        for (int i = 0; i < expensecount; i++) {
          Product producAux = Product.fromObject(result[i]);
          if (producAux.date == date &&
              (producAux.method == "Pago")) {
            productList.add(producAux);
          } else {
            notToday = notToday + 1;
          }
        }
        setState(() {
          expenseproduct = productList;
          expensecount = expensecount - notToday;
        });
      });
    });
  }

  String stringToDate(String aux) {
    var newDateTimeObj = new DateFormat().add_yMd().parse(aux);
    return newDateTimeObj.day.toString() +
        '/' +
        newDateTimeObj.month.toString() +
        '/' +
        newDateTimeObj.year.toString();
  }

  String calculateTotalSales(List<Product> products, int count) {
    var total = 0;
    for (var i = 0; i < count; i++) {
      total = total + products[i].price;
    }
    return total.toString();
  }

  String calculateTotal(
    List<Product> products,
    int count,
    List<Product> expenseproducts,
    int countexpense,
  ) {
    var total = 0;
    for (var i = 0; i < count; i++) {
      total = total + products[i].price;
    }

    var totalexpense = 0;
    for (var i = 0; i < countexpense; i++) {
      totalexpense = totalexpense + expenseproducts[i].price;
    }

    return (total - totalexpense).toString();
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
