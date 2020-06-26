import 'package:flutter/material.dart';
import 'package:administracion/model/product.dart';
import 'package:administracion/util/dbhelper.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:downloads_path_provider/downloads_path_provider.dart'; 
import 'package:permission_handler/permission_handler.dart'; 


import 'loadandviewcsvpage.dart';

class Excel extends StatefulWidget {
  int count = 0;
  DateTime dateFrom;
  DateTime dateTo;
  Excel(this.dateFrom, this.dateTo);
  @override
  State<StatefulWidget> createState() => ExcelState(dateFrom, dateTo);
}

class ExcelState extends State {
  DbHelper helper = DbHelper();
  List<Product> products;
  int count = 0;
  DateTime dateTo;
  DateTime dateFrom;
  ExcelState(this.dateFrom, this.dateTo);

  @override
  Widget build(BuildContext context) {
    if (products == null) {
      products = List<Product>();
      getData();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Generar csv"),
        centerTitle: true,
        backgroundColor: Colors.black,
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
              onTap: () {}),
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

  String stringToDate(String aux) {
    var newDateTimeObj = new DateFormat().add_yMd().parse(aux);
    return newDateTimeObj.day.toString() +
        '/' +
        newDateTimeObj.month.toString() +
        '/' +
        newDateTimeObj.year.toString();
  }

  Future<void> _generateCSVAndView(context) async {
    List<List<String>> csvData;
    List<String> aux;
    csvData = [
      ['Articulo', 'Precio', 'Cantidad', 'Metodo']
    ];

    for (var item in products) {
      aux = [
        item.article,
        item.price.toString(),
        item.quantity.toString(),
        item.method.toString()
      ];

      csvData = csvData + [aux];
    }

    String csv = const ListToCsvConverter().convert(csvData);

    final PermissionHandler _permissionHandler = PermissionHandler();
    var result = await _permissionHandler.requestPermissions([PermissionGroup.storage]);
      if (result[PermissionGroup.storage] == PermissionStatus.granted) {
      // permission was granted

      

    final String dir = (await DownloadsPathProvider.downloadsDirectory).path;
    final String path =
        '$dir/venta' + convertDatePath(products[0].date) + '.csv';
      
    // create file
    final File file = File(path);
    // Save csv string using default configuration
    // , as field separator
    // " as text delimiter and
    // \r\n as eol.
    await file.writeAsString(csv);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LoadAndViewCsvPage(path: path),
      ),
    );}
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
}
