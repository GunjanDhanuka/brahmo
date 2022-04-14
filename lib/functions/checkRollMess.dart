import 'package:gsheets_get/gsheets_get.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

List<List<dynamic>> _data = [];

Future<Map<dynamic, dynamic>> checkRollMess(String roll, String email) async {
  print("Checking Roll Numbers");

  //USING LOCAL CSV FILE INSTEAD OF GOOGLE SHEETS
  //FILE STORED IN: assets/data/Brahma Boarders.csv

  // final GSheetsGet sheet = GSheetsGet(
  //
  //     //sheetId: "1B2QiNCe36N2J4oTQYTLIwc8QngkPeHo2skwkxaUO8KQ",
  //     sheetId: "1-nE8Cb_p3pcFGr4osgTjq26UZdm0NLRUqcM4Yxfv2oM",
  //     page: 1,
  //     skipRows: 1);

  // GSheetsResult result = await sheet.getSheet();
  // if(!result.sucess) print(result.message);
  await _loadCSV();
  print(_data[0]);

  List<String> allowedRollList = [];
  List<String> allowedEmailList = [];
  _data.forEach((row) {
    // StringBuffer buffer = StringBuffer();
    //
    // if (row != null) {
    //   row.forEach((cell) {
    //     buffer.write(cell.text.toString() + "|");
    //   });
    // }
    // allowedRollList.add(buffer.toString().split("|")[0]);
    // allowedEmailList.add(buffer.toString().split("|")[7]);
    allowedRollList.add(row[0].toString());
    allowedEmailList.add(row[7].toString());
  });
  //
  print(allowedRollList);
  print(allowedEmailList);
  Map map = {'isPresent': true, 'roll': roll};
  if (allowedEmailList.contains(email)) {
    //update the roll number from the GSheet incase the Azure API didn't return the roll for this user.
    String rollNew = allowedRollList[allowedEmailList.indexOf(email)];
    if (rollNew != "null") {
      print('*******New Roll Number: ' + rollNew + '******');
      map['roll'] = rollNew;
    }
    return map;
  } else if (allowedRollList.contains(roll)) {
    return map;
  } else {
    map['isPresent'] = false;
    return map;
  }
}

void _loadCSV() async{
  final _rawData = await rootBundle.loadString("assets/data/Brahma Boarders.csv");
  List<List<dynamic>> _listData =
  const CsvToListConverter().convert(_rawData);
  _data = _listData;
  print(_listData);
}