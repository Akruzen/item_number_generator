import 'package:shared_preferences/shared_preferences.dart';

Future<bool> checkNameExists(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  for (String groupNames in (prefs.getStringList("groupNamesList")) ?? []) {
    if (groupNames.toLowerCase() == name.toLowerCase()) {
      return true;
    }
    for (String catName in (prefs.getStringList(groupNames)) ?? []) {
      if (catName.toLowerCase() == name.toLowerCase()) {
        return true;
      }
      for (String subCatName in (prefs.getStringList(catName)) ?? []) {
        if (subCatName.toLowerCase() == name.toLowerCase()) {
          return true;
        }
        for (String itemName in (prefs.getStringList(subCatName)) ?? []) {
          if (itemName.toLowerCase() == name.toLowerCase()) {
            return true;
          }
        }
      }
    }
  }
  return false;
}