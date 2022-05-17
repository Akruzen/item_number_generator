import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MasterResetAlert extends StatefulWidget {
  const MasterResetAlert({Key? key}) : super(key: key);

  @override
  State<MasterResetAlert> createState() => _MasterResetAlertState();
}

class _MasterResetAlertState extends State<MasterResetAlert> {

  bool _isSnackBarActive = false;

  void showCustomSnackBar (String message) {
    if (!_isSnackBarActive) {
      _isSnackBarActive = true;
      final snackBar = SnackBar(
        content: Text(message),
        action: SnackBarAction(label: "Got it", onPressed: () {},),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((SnackBarClosedReason reason) {_isSnackBarActive = false;});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        AlertDialog(
          title: const Text("Master Reset", style: TextStyle(fontWeight: FontWeight.bold),),
          content: Column(
            children: [
              Row(
                children: const [
                  Icon(Icons.warning, color: Colors.redAccent,),
                  SizedBox(width: 10.0,),
                  Text("YOU ARE ABOUT TO DELETE ALL DATA. ARE YOU SURE YOU WANT TO PROCEED?"),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.green),
              onPressed: () {
                showCustomSnackBar("Master Reset operation cancelled. Data not deleted.");
                Navigator.pop(context);
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("No, do NOT delete the data"),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.redAccent),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Yes, delete all data"),
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                List<String> clearedList = [];
                for (String groupNames in (prefs.getStringList("groupNamesList")) ?? clearedList) {
                  for (String catName in (prefs.getStringList(groupNames)) ?? clearedList) {
                    for (String subCatName in (prefs.getStringList(catName)) ?? clearedList) {
                      for (String itemName in (prefs.getStringList(subCatName)) ?? clearedList) {
                        prefs.remove(itemName);
                      }
                      prefs.remove(subCatName);
                    }
                    prefs.remove(catName);
                  }
                  prefs.remove(groupNames);
                  prefs.clear();
                }
                prefs.setStringList("groupNamesList", clearedList);
                prefs.setStringList("Uncategorized", clearedList);
                showCustomSnackBar("Done. All data deleted");
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
