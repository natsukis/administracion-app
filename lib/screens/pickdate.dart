import 'package:administracion/screens/salesofday.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class PickDate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PickDateState();
}

class PickDateState extends State {
  String datesText = '';
  String dates = '';
  DateTime dateValidation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Fecha"),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Center(
            child: Column(children: <Widget>[
          RaisedButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(28.0),
                  side: BorderSide(color: Colors.black)),
              onPressed: () {
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(2020, 1, 1),
                    maxTime: DateTime(2028, 12, 31),
                    onChanged: (date) {}, onConfirm: (date) {
                  setState(() {
                    datesText = dateToString(date);
                    dates = dateToBd(date);
                    dateValidation = date;
                  });
                }, currentTime: DateTime.now(), locale: LocaleType.es);
              },
              child: Text(
                'Elegir fecha a buscar',
                style: TextStyle(color: Colors.black),
              )),
          Container(child: Text(datesText)),
          RaisedButton(
            color: Colors.black,
            child: Text("Buscar"),
            textColor: Colors.white,
            onPressed: () {
              alert();
            },
          )
        ])));
  }

  void navigateToSale(String dates) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => SalesOfDay(dates)));
  }

  String dateToString(DateTime dateAux) {
          var x = dateAux.day.toString() +'/' +dateAux.month.toString() +'/' +dateAux.year.toString();
          return x;
    }

    String dateToBd(DateTime dateAux){
      var x = dateAux.month.toString()+'/' +dateAux.day.toString()  +'/' +dateAux.year.toString();
      return x;
    }

  bool checkDates() {
    if (dateValidation == null) {
      return false;
    } else {
      return true;
    }
  }

  Widget alert() {
    if (checkDates()) {
      navigateToSale(dates);
    } else {
      return showAlertDialog(context);
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text("Elegir fecha correctamente."),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
