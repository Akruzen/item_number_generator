import 'package:shared_preferences/shared_preferences.dart';

Future<List<String>> getSearchMatch(String keyword) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> matchingSearchesList = [];
  for (String groupNames in (prefs.getStringList("groupNamesList")) ?? []) {
    for (String catName in (prefs.getStringList(groupNames)) ?? []) {
      for (String subCatName in (prefs.getStringList(catName)) ?? []) {
        for (String itemName in (prefs.getStringList(subCatName)) ?? []) {
          if (itemName.toLowerCase().contains(keyword.toLowerCase())) {
            matchingSearchesList.add(itemName);
          }
          else {
            for (String desc in (prefs.getStringList(itemName))!) {
              if (desc.toLowerCase().contains(keyword.toLowerCase())) {
                matchingSearchesList.add(itemName);
              }
            }
          }
        }
      }
    }
  }
  return matchingSearchesList;
}