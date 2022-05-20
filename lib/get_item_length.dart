import 'package:shared_preferences/shared_preferences.dart';

Future<int> getItemLength (String subCatName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print("Returning " + (prefs.getStringList(subCatName) ?? []).length.toString());
  return (prefs.getStringList(subCatName) ?? []).length;
}