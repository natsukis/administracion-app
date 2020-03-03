import 'package:flutter/material.dart';
import 'package:administracion/model/product.dart';
import 'package:administracion/util/dbhelper.dart';
import 'package:administracion/screens/saledetails.dart';
import 'package:intl/intl.dart';

class SalesOfDay extends StatefulWidget {
  String date;
  SalesOfDay(this.date);
  @override
  State<StatefulWidget> createState() => SalesOfDayState(date);
}

class SalesOfDayState extends State {
  DbHelper helper = DbHelper();
  List<Product> products;
  int count = 0;
  String date;
  SalesOfDayState(this.date);

  @override
  Widget build(BuildContext context) {
    if (products == null) {
      products = List<Product>();
      getData();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(stringToDate(date)),
        backgroundColor: Colors.black,
        centerTitle: true,
        bottom: PreferredSize(
            child: Text('Total: \$' + calculateTotalSales(products, count),style: TextStyle(color: Colors.white)),
            preferredSize: null),
      ),
      body: productListItems(),      
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateToDetail(Product("Luna Garzon", 1, 0, date, 'Efectivo',''));
          },
          backgroundColor: Colors.black,
          tooltip: "Agregar nueva venta",
          child: new Icon(Icons.add)),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.add),
      //       title: Text('Nueva venta'),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.arrow_back),
      //       title: Text('Volver'),
      //     ),
      //   ],
      //   selectedItemColor: Colors.amber[800],
      //   onTap: navigate,
      // ),
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
          if (producAux.date == date) {
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
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => SaleDetail(product, date)));
    if (result == true) {
      getData();
    }
  }

  void navigate(int index) {
    if (index == 0) {
      navigateToDetail(Product("Luna Garzon", 1, 0, date,'Efectivo', ''));
    } else {
      Navigator.pop(context, true);
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
}
