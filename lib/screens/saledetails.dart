import 'package:flutter/material.dart';
import 'package:administracion/model/product.dart';
import 'package:administracion/util/dbhelper.dart';
import 'package:intl/intl.dart';

DbHelper helper = new DbHelper();
final List<String> choices = const <String>[
  'Guardar venta y volver',
  'Borrar venta y volver',
  'Volver'
];

const mnuSave = 'Guardar venta y volver';
const mnuDelete = 'Borrar venta y volver';
const mnuBack = 'Volver';

class SaleDetail extends StatefulWidget {
  final Product product;
  final String dateString;
  SaleDetail(this.product, this.dateString);

  @override
  State<StatefulWidget> createState() => SaleDetailState(product, dateString);
}

class SaleDetailState extends State {
  Product product;
  String dateString;
  SaleDetailState(this.product, this.dateString);
  final _names = [
    "Luna Garzon",
    "Morellato",
    "Majorica",
    "Peskin",
    "Il gioelio",
    "Pedro",
    "Otro"
  ];
  String _name = "Otro";
  final _methods = [
    "Efectivo",
    "Tarjeta",
    "Tarjeta 1c",
    "Tarjeta 3c",
    "Debito"
  ];
  String _method = "Efectivo";
  TextEditingController quantityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    quantityController.text = product.quantity.toString();
    descriptionController.text = product.description;
    priceController.text = product.price.toString();
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: Text(
            "Venta",
            textAlign: TextAlign.center,
          ),
          // actions: <Widget>[
          //   PopupMenuButton<String>(
          //     onSelected: select,
          //     itemBuilder: (BuildContext context) {
          //       return choices.map((String choice) {
          //         return PopupMenuItem<String>(
          //           value: choice,
          //           child: Text(choice),
          //         );
          //       }).toList();
          //     },
          //   )
          // ],
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10),
          child: ListView(children: <Widget>[
            Column(
              children: <Widget>[
                ListTile(
                    title: DropdownButton<String>(
                  items: _names.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  style: textStyle,
                  value: product.article,
                  onChanged: (value) => updateArticle(value),
                )),
                ListTile(
                    title: DropdownButton<String>(
                  items: _methods.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  style: textStyle,
                  value: product.method,
                  onChanged: (value) => updateMethod(value),
                )),
                Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      controller: priceController,
                      style: textStyle,
                      onChanged: (value) => this.updatePrice(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelStyle: textStyle,
                          labelText: "Precio",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                TextField(
                  controller: descriptionController,
                  style: textStyle,
                  onChanged: (value) => this.updateDescription(),
                  decoration: InputDecoration(
                      labelStyle: textStyle,
                      labelText: "Descripcion",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: TextField(
                      controller: quantityController,
                      style: textStyle,
                      onChanged: (value) => this.updateQuantity(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelStyle: textStyle,
                          labelText: "Cantidad",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
              ],
            )
          ]),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.save),
              title: Text('Guardar'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.delete),
              title: Text('Borrar'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.arrow_back),
              title: Text('Volver'),
            ),
          ],
          selectedItemColor: Colors.amber[800],
          onTap: navigate,
        ));
  }

  void select(String value) async {
    int result;
    switch (value) {
      case mnuSave:
        save();
        break;
      case mnuDelete:
        if (product.id == null) {
          return;
        }
        result = await helper.deleteProduct(product.id);
        if (result != 0) {
          Navigator.pop(context, true);
          AlertDialog alertDialog = AlertDialog(
            title: Text("Borrar venta"),
            content: Text("La venta fue borrado"),
          );
          showDialog(context: context, builder: (_) => alertDialog);
        }
        break;
      case mnuBack:
        Navigator.pop(context, true);
        break;
    }
  }

  void save() {
    var date = new DateFormat.yMd().format(DateTime.now());

    if (product.date != dateString) {
      product.date = date;
    }
    if (product.id != null) {
      helper.updateProduct(product);
    } else {
      helper.insertProduct(product);
    }
    Navigator.pop(context, true);
  }

  void updateArticle(String value) {
    product.article = value;

    setState(() {
      _name = value;
    });
  }

  void updateMethod(String value) {
    product.method = value;

    setState(() {
      _method = value;
    });
  }

  void updatePrice() {
    product.price = int.parse(priceController.text);
  }

  void updateQuantity() {
    product.quantity = int.parse(quantityController.text);
  }

  void updateDescription() {
    product.description = descriptionController.text;
  }

  void navigate(int index) async {
    if (index == 0) {
      save();
    } else if (index == 1) {
      if (product.id == null) {
        return;
      }
      int result = await helper.deleteProduct(product.id);
      if (result != 0) {
        Navigator.pop(context, true);
        AlertDialog alertDialog = AlertDialog(
          title: Text("Borrar venta"),
          content: Text("La venta fue borrado"),
        );
        showDialog(context: context, builder: (_) => alertDialog);
      }
    } else {
      Navigator.pop(context, true);
    }
  }
}
