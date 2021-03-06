/// Program by Omkar Phadke, Pune Institute of Computer Technology, in May 2022

import 'package:item_number_generator/get_part_number.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<String>> getItemHierarchy(String searchedItemName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  for (String groupNames in (prefs.getStringList("groupNamesList")) ?? []) {
    for (String catName in (prefs.getStringList(groupNames)) ?? []) {
      for (String subCatName in (prefs.getStringList(catName)) ?? []) {
        for (String itemName in (prefs.getStringList(subCatName)) ?? []) {
          if (itemName == searchedItemName) {
            String partNumber = await getPartNumber(itemName);
            return [groupNames, catName, subCatName, ((prefs.getStringList(searchedItemName) ?? ["No Description"])[0]), partNumber];
          }
        }
      }
    }
  }
  return [];
}