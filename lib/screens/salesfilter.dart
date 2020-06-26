import 'dart:io';
import 'package:csv/csv.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:administracion/model/product.dart';
import 'package:administracion/util/dbhelper.dart';
import 'package:administracion/screens/saledetails.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'loadandviewcsvpage.dart';

class SalesFilter extends StatefulWidget {
  DateTime dateFrom;
  DateTime dateTo;
  String method;
  SalesFilter(this.dateFrom, this.dateTo, this.method);
  @override
  State<StatefulWidget> createState() =>
      SalesFilterState(dateFrom, dateTo, method);
}

class SalesFilterState extends State {
  DbHelper helper = DbHelper();
  List<Product> products;
  int count = 0;
  DateTime dateFrom;
  DateTime dateTo;
  String method;
  SalesFilterState(this.dateFrom, this.dateTo, this.method);

  @override
  Widget build(BuildContext context) {
    if (products == null) {
      products = List<Product>();
      getData();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Resultados"),
        backgroundColor: Colors.black,
        centerTitle: true,
        bottom: PreferredSize(
            child: Text('Total: \$' + calculateTotalSales(products, count),
                style: TextStyle(color: Colors.white)),
            preferredSize: null),
        actions: <Widget>[
          InkWell(
            onTap: () => _generateCSVAndView(context),
            child: Align(
              alignment: Alignment.center,
              child: Text('CSV'),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: productListItems(),
    );
  }

  ListView productListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          margin: EdgeInsets.all(3),
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
              contentPadding: EdgeInsets.only(left: 5, right: 5),
              leading: CircleAvatar(
                  backgroundColor: getColor(this.products[position].article),
                  child: Text(this.products[position].quantity.toString())),
              title: Text(this.products[position].article),
              subtitle: Text(stringToDate(this.products[position].date)),
              trailing: Text("\$" + this.products[position].price.toString()),
              onTap: () {
                navigateToDetail(this.products[position]);
              }),
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
        int notToday = 0;
        for (int i = 0; i < count; i++) {
          Product producAux = Product.fromObject(result[i]);
          if (method == "Efectivo") {
            if (comparedate(producAux.date) && producAux.method == method) {
              productList.add(producAux);
            } else {
              notToday = notToday + 1;
            }
          } else {
            if (comparedate(producAux.date) && producAux.method != "Efectivo") {
              productList.add(producAux);
            } else {
              notToday = notToday + 1;
            }
          }
        }
        setState(() {
          products = productList;
          count = count - notToday;
        });
      });
    });
  }

  Color getColor(String article) {
    switch (article) {
      case "Luna Garzon":
        return Colors.deepOrange;
        break;
      case "Morellato":
        return Colors.blue;
        break;
      case "Il gioelio":
        return Colors.green;
        break;
      case "Pedro":
        return Colors.grey;
        break;
      case "Peskin":
        return Colors.pink;
        break;
      case "Majorica":
        return Colors.purple;
        break;
      case "Otro":
        return Colors.redAccent;
        break;
      default:
        return Colors.brown;
        break;
    }
  }

  void navigateToDetail(Product product) async {
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SaleDetail(product, product.date)));
    if (result == true) {
      getData();
    }
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

    if (dateD.isAfter(dateFrom.add(new Duration(days: -1))) &&
        dateD.isBefore(dateTo.add(new Duration(days: 1)))) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _generateCSVAndView(context) async {
    List<List<String>> csvData;
    List<String> aux;
    csvData = [
      ['Articulo          ', 'U.', 'Metodo', 'Precio']
    ];

    String article;
    String price;
    String quantity;
    String method;

    for (var item in products) {
      switch (item.article) {
        case "Luna Garzon":
          article = item.article;
          break;
        case "Morellato":
          article = item.article + "        ";
          break;
        case "Majorica":
          article = item.article + "          ";
          break;
        case "Peskin":
          article = item.article + "             ";
          break;
        case "Il gioelio":
          article = item.article + "         ";
          break;
        case "Pedro":
          article = item.article + "              ";
          break;
        case "Otro":
          article = item.article + "            ";
          break;
      }

      switch (5 - item.price.toString().length) {
        case 1:
          price = item.price.toString() + " ";
          break;
        case 2:
          price = item.price.toString() + "  ";
          break;
        case 3:
          price = item.price.toString() + "   ";
          break;
        case 4:
          price = item.price.toString() + "    ";
          break;
      }

      switch (item.method) {
        case "Efectivo":
          method = item.method + "  ";
          break;
        case "Debito":
          method = item.method + "    ";
          break;
        case "Tarjeta 1c":
          method = item.method + "  ";
          break;
        case "Tarjeta 3c":
          method = item.method + "  ";
          break;
        case "Tarjeta":
          method = item.method + "   ";
          break;
      }

      aux = [
        article,
        item.quantity.toString(),
        method,
        price,
      ];

      csvData = csvData + [aux];
    }

    String csv = const ListToCsvConverter().convert(csvData);

    final PermissionHandler _permissionHandler = PermissionHandler();
    var result =
        await _permissionHandler.requestPermissions([PermissionGroup.storage]);
    if (result[PermissionGroup.storage] == PermissionStatus.granted) {
      // permission was granted

      final String dir = (await DownloadsPathProvider.downloadsDirectory).path;
      final String path =
          '$dir/venta' + stringToDateConvertCsv(dateFrom) +
          "a" +
          stringToDateConvertCsv(dateTo) + '.csv';

      // create file
      final File file = File(path);

      await file.writeAsString(csv);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => LoadAndViewCsvPage(path: path),
        ),
      );
    }
  }

  String stringToDateConvertCsv(DateTime aux) {
    return aux.day.toString() +
        '-' +
        aux.month.toString() +
        '-' +
        aux.year.toString();
  }

  String convertDate(String aux) {
    var newDateTimeObj = new DateFormat().add_yMd().parse(aux);
    return newDateTimeObj.day.toString() +
        '/' +
        newDateTimeObj.month.toString() +
        '/' +
        newDateTimeObj.year.toString();
  }
}
