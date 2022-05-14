import 'package:shared_preferences/shared_preferences.dart';

Future<List<String>> getItemHierarchy(String searchedItemName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  for (String groupNames in (prefs.getStringList("groupNamesList")) ?? []) {
    for (String catName in (prefs.getStringList(groupNames)) ?? []) {
      for (String subCatName in (prefs.getStringList(catName)) ?? []) {
        for (String itemName in (prefs.getStringList(subCatName)) ?? []) {
          if (itemName == searchedItemName) {
            return [groupNames, catName, subCatName];
          }
        }
      }
    }
  }
  return [];
}