import 'package:flutter/material.dart';
import 'package:administracion/model/product.dart';
import 'package:administracion/util/dbhelper.dart';
import 'package:intl/intl.dart';

DbHelper helper = new DbHelper();

class ExpenseDetail extends StatefulWidget {
  final String dateString;
  final Product product;
  ExpenseDetail(this.product,this.dateString);

  @override
  State<StatefulWidget> createState() => ExpenseDetailState(product,dateString);
}

class ExpenseDetailState extends State {
  Product product;
  String dateString;
  ExpenseDetailState(this.product,this.dateString);
  final _names = [
    "Pago",
    "Alquiler",
    "Comisionista",
    "Impuesto"
  ];
  String _name = "Pago";
  String _method = "Pago";

  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    descriptionController.text = product.description;
    priceController.text = product.price.toString();
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: Text(
            "Gasto",
            textAlign: TextAlign.center,
          ),          
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
                Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      controller: priceController,
                      style: textStyle,
                      onChanged: (value) => this.updatePrice(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelStyle: textStyle,
                          labelText: "Gastado",
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

  void save() {
    var date = new DateFormat.yMd().format(DateTime.now());

    if (product.date != dateString) {
      product.date = date;
    }

    product.quantity=1;
    product.method = _method;

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

  void updatePrice() {
    product.price = int.parse(priceController.text);
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
