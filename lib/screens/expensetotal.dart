import 'package:administracion/screens/expensedetail.dart';
import 'package:flutter/material.dart';
import 'package:administracion/model/product.dart';
import 'package:administracion/util/dbhelper.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'dart:io';

class ExpenseTotal extends StatefulWidget {
  int count = 0;
  DateTime dateFrom;
  DateTime dateTo;
  ExpenseTotal(this.dateFrom, this.dateTo);
  @override
  State<StatefulWidget> createState() => ExpenseTotalState(dateFrom, dateTo);
}

class ExpenseTotalState extends State {
  DbHelper helper = DbHelper();
  List<Product> products;
  int count = 0;
  DateTime dateTo;
  DateTime dateFrom;
  ExpenseTotalState(this.dateFrom, this.dateTo);

  @override
  Widget build(BuildContext context) {
    if (products == null) {
      products = List<Product>();
      getData();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Gastos totales"),
        centerTitle: true,
        backgroundColor: Colors.black,
        bottom: PreferredSize(
            child: Text(stringToDateConvert(dateFrom) + " a " + stringToDateConvert(dateTo),style: TextStyle(color: Colors.white)),
            preferredSize: null),
      ),
      body: Center(child: productListItems()),
    );
  }

  ListView productListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
              leading: CircleAvatar(
                  backgroundColor: getColor(this.products[position].article),
                  child: Text(this.products[position].quantity.toString())),
              title: Text(this.products[position].article),
              subtitle:
                  Text('Total: \$' + this.products[position].price.toString()),
              onTap: () { navigateToDetail(this.products[position]);}),
        );
      },
    );
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
          if (comparedate(producAux.date) &&
              (producAux.method == "Pago")) {
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

    void navigateToDetail(Product product) async {
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ExpenseDetail(product, product.date)));
    if (result == true) {
      getData();
    }
  }

  String stringToDateConvert(DateTime aux) {
    return aux.day.toString() + '/' + aux.month.toString();
  }

  String stringToDate(String aux) {
    var newDateTimeObj = new DateFormat().add_yMd().parse(aux);
    return newDateTimeObj.day.toString() +
        '/' +
        newDateTimeObj.month.toString() +
        '/' +
        newDateTimeObj.year.toString();
  }

  String convertDatePath(String aux) {
    var newDateTimeObj = new DateFormat().add_yMd().parse(aux);
    return newDateTimeObj.month.toString() +
        '-' +
        newDateTimeObj.day.toString() +
        '-' +
        newDateTimeObj.year.toString();
  }

  bool comparedate(String date) {
    DateTime dateD = new DateFormat().add_yMd().parse(date);

    if (dateD.isAfter(dateFrom.add(new Duration(days: -1))) && dateD.isBefore(dateTo.add(new Duration(days: 1)))) {
      return true;
    } else {
      return false;
    }
  }

  Color getColor(String article) {
    switch (article) {
      case "Pago":
        return Colors.deepOrange;
        break;
      case "Impuesto":
        return Colors.blue;
        break;
      case "Alquiler":
        return Colors.green;
        break;
      case "Comisionista":
        return Colors.grey;
        break;
      default:
        return Colors.brown;
        break;
    }
  }
}
