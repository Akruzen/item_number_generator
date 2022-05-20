/// Program by Omkar Phadke, Pune Institute of Computer Technology, in May 2022

import 'package:shared_preferences/shared_preferences.dart';

Future<String> getPartNumber (String item) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  for (String groupNames in (prefs.getStringList("groupNamesList")) ?? []) {
    for (String catName in (prefs.getStringList(groupNames)) ?? []) {
      for (String subCatName in (prefs.getStringList(catName)) ?? []) {
        for (String itemName in (prefs.getStringList(subCatName)) ?? []) {
          if (itemName == item) {
            String groupCode = String.fromCharCode(prefs.getStringList("groupNamesList")!.indexOf(groupNames) + 65);
            String catCode = (prefs.getStringList(groupNames)!.indexOf(catName) + 1).toString().padLeft(2, "0");
            String subCatCode = (prefs.getStringList(catName)!.indexOf(subCatName) + 1).toString().padLeft(2, "0");
            String itemCode = (prefs.getStringList(subCatName)!.indexOf(itemName) + 1).toString().padLeft(3, "0");
            return groupCode + catCode + subCatCode + itemCode;
          }
        }
      }
    }
  }
  return "nullValue";
}