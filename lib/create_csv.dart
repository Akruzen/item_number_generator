import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:item_number_generator/get_part_number.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _isSnackBarActive = false;

void showCustomSnackBar (BuildContext context, String message) {
  if (!_isSnackBarActive) {
    _isSnackBarActive = true;
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(label: "Got it", onPressed: () {},),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((SnackBarClosedReason reason) {_isSnackBarActive = false;});
  }
}

void createCSV (BuildContext context) async {
  int serialNo = 0;
  List<List<dynamic>> excelSheetList = [];
  List<dynamic> headerList = ["SR. NO", "PART NO.", "GROUP", "CATEGORY", "SUBCATEGORY", "ITEM NUMBER", "ITEM NAME", "ITEM DESCRIPTION"];
  excelSheetList.add(headerList); // Add the headings before the actual data
  SharedPreferences prefs = await SharedPreferences.getInstance();
  for (String groupNames in (prefs.getStringList("groupNamesList")) ?? ["No Group Name"]) {
    for (String catName in (prefs.getStringList(groupNames)) ?? ["No Category"]) {
      for (String subCatName in (prefs.getStringList(catName)) ?? ["No Subcategory"]) {
        for (String itemName in (prefs.getStringList(subCatName)) ?? ["No Items"]) {
          if (itemName == "No Items") {
            serialNo++;
            List<dynamic> tempList = [serialNo, "---", groupNames, catName, subCatName, "---", "No Items", "---"];
            excelSheetList.add(tempList);
          }
          else {
            serialNo++;
            String itemDesc = prefs.getStringList(itemName)![0];
            String partCode = await getPartNumber(itemName);
            String itemCode = partCode.substring(partCode.length - 3);
            List<dynamic> tempList = [serialNo, partCode, groupNames, catName, subCatName, itemCode, itemName, itemDesc];
            excelSheetList.add(tempList);
          }
        }
      }
    }
  }
  String csv = const ListToCsvConverter().convert(excelSheetList);
  print("CSV:\n" + csv);
  DateTime now = DateTime.now();
  try {
    String? outputFile = await FilePicker.platform.saveFile(
      allowedExtensions: ["csv"],
      dialogTitle: "Save the CSV File in:",
      fileName: now.year.toString() + now.month.toString() + now.day.toString() + now.hour.toString() + now.minute.toString()
          + now.second.toString() + "_ExportedCSV.csv",
    );
    if (outputFile == null) {
      // User canceled saving operation
    }
    else {
      File file = File(outputFile);
      file.writeAsString(csv);
      showCustomSnackBar(context, "File created at the desired path");
    }
  } catch (e) {
    print(e);
  }
}