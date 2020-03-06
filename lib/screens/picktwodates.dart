import 'package:administracion/screens/totalmonth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:administracion/screens/excel.dart';
import 'package:intl/intl.dart';

import 'expensetotal.dart';

class PickTwoDate extends StatefulWidget {
  String screen;
  @override
  State<StatefulWidget> createState() => PickTwoDateState(this.screen);
  PickTwoDate(this.screen);
}

class PickTwoDateState extends State {
  DateTime dateFrom;
  DateTime dateTo;
  String screen;
  PickTwoDateState(this.screen);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Fecha"),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Center(
            child: Column(
          children: <Widget>[
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
                      dateFrom = date;
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.es);
                },
                child: Text(
                  'Elegir fecha desde:',
                  style: TextStyle(color: Colors.black),
                )),
            Container(child: Text(convertDateToString(dateFrom))),
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
                      dateTo = date;
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.es);
                },
                child: Text(
                  'Elegir fecha hasta:',
                  style: TextStyle(color: Colors.black),
                )),
            Container(child: Text(convertDateToString(dateTo))),
            RaisedButton(
              color: Colors.black,
              textColor: Colors.white,
              child: Text("Buscar"),
              onPressed: () {
                alert();
              },
            )
          ],
        )));
  }

  String convertDateToString(DateTime datetoconvert) {
    if (datetoconvert == null) {
      return '';
    } else {      
      return datetoconvert.day.toString() +
        '/' +
        datetoconvert.month.toString() +
        '/' +
        datetoconvert.year.toString();
    }
  }

  bool checkDates() {
    if (dateTo == null || dateFrom == null || dateFrom.add(new Duration(days: -1)).isAfter(dateTo.add(new Duration(days: 1)))) {
      return false;
    } else {
      return true;
    }
  }

  void navigateExcel() async {
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => Excel(dateFrom, dateTo)));
  }

  void navigateTotalMonth() async {
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => TotalMonth(dateFrom, dateTo)));
  }

    void navigateExpenseTotal() async {
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ExpenseTotal(dateFrom, dateTo)));
  }

  Widget alert() {
    if (checkDates()) {
      if (screen == "Excel") {
        navigateExcel();
      }else if(screen == "Expenses"){
        navigateExpenseTotal();
      }else{
        navigateTotalMonth();
      }      
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
      content: Text("Elegir ambas fechas correctamente."),
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
