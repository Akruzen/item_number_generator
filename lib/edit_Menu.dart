import 'package:flutter/material.dart';
import 'package:item_number_generator/checkNameExist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditMenu extends StatefulWidget {

  final String oldName;
  final String editParam;

  const EditMenu({Key? key, required this.oldName, required this.editParam}) : super(key: key);

  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {

  TextEditingController renameController = TextEditingController();
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
          title: const Text("Enter new name"),
          content: Column(
            children: [
              Text("Old name: " + widget.oldName),
              const SizedBox(height: 10.0,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                child: TextField(
                  controller: renameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.drive_file_rename_outline_outlined),
                    border: OutlineInputBorder(),
                    labelText: "Rename",
                  ),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text("OK"),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                List<String> tempList = [];
                bool nameExists = await checkNameExists(renameController.text.toString());
                if (nameExists) {
                  showCustomSnackBar("A Group, Category, Sub Category or Item with same name already exists.");
                }
                else {
                  switch (widget.editParam) {
                    case "Group":
                      tempList = prefs.getStringList("groupNamesList") ?? [];
                      if (tempList.contains(widget.oldName)) {
                        print("Old name found");
                        int index = tempList.indexOf(widget.oldName);
                        tempList.removeAt(index);
                        tempList.insert(index, renameController.text);
                        prefs.setStringList("groupNamesList", tempList);
                        // Get old names list
                        List<String> catTempStringList = (prefs.getStringList(widget.oldName)) ?? [];
                        // Set the list with new name
                        prefs.setStringList(renameController.text, catTempStringList);
                        // Delete the old database name to save space
                        prefs.remove(widget.oldName);
                        // Prompt the action was successful and remove the dialog box
                        showCustomSnackBar("Rename successful");
                        Navigator.pop(context);
                      }
                      break;

                    case "Category":
                      String catParent = "";
                      bool isCatFound = false;
                      GroupLoop : for (String groupName in prefs.getStringList("groupNamesList") ?? []) {
                        for (String catName in prefs.getStringList(groupName) ?? []) {
                          if (catName == widget.oldName) {
                            catParent = groupName;
                            isCatFound = true;
                            break GroupLoop;
                          }
                        }
                      }
                      if (isCatFound) {
                        print("Old name found");
                        tempList = prefs.getStringList(catParent) ?? [];
                        int index = tempList.indexOf(widget.oldName);
                        tempList.removeAt(index);
                        tempList.insert(index, renameController.text);
                        prefs.setStringList(catParent, tempList);
                        // Get old list names
                        List<String> subCatTempList = prefs.getStringList(widget.oldName) ?? [];
                        // Set the List with new Name
                        prefs.setStringList(renameController.text, subCatTempList);
                        // Delete the old database name to save space
                        prefs.remove(widget.oldName);
                        // Prompt the action was successful and remove the dialog box
                        showCustomSnackBar("Rename successful");
                        Navigator.pop(context);
                      }
                      else {
                        showCustomSnackBar("Category does not exist");
                        Navigator.pop(context);
                      }
                      break;

                    case "Subcategory":
                      String subCatParent = "";
                      bool isSubCatFound = false;
                      GroupLoop : for (String groupName in prefs.getStringList("groupNamesList") ?? []) {
                        for (String catName in prefs.getStringList(groupName) ?? []) {
                          for (String subCatName in prefs.getStringList(catName) ?? []) {
                            if (subCatName == widget.oldName) {
                              subCatParent = catName;
                              isSubCatFound = true;
                              break GroupLoop;
                            }
                          }
                        }
                      }
                      if (isSubCatFound) {
                        print("Old name found");
                        tempList = prefs.getStringList(subCatParent) ?? [];
                        int index = tempList.indexOf(widget.oldName);
                        tempList.removeAt(index);
                        tempList.insert(index, renameController.text);
                        prefs.setStringList(subCatParent, tempList);
                        // Get old list names
                        List<String> itemTempList = prefs.getStringList(widget.oldName) ?? [];
                        // Set the List with new Name
                        prefs.setStringList(renameController.text, itemTempList);
                        // Delete the old database name to save space
                        prefs.remove(widget.oldName);
                        // Prompt the action was successful and remove the dialog box
                        showCustomSnackBar("Rename successful");
                        Navigator.pop(context);
                      }
                      else {
                        showCustomSnackBar("Subcategory does not exist.");
                        Navigator.pop(context);
                      }
                      break;

                    case "Item":
                      String itemParent = "";
                      bool isItemFound = false;
                      GroupLoop : for (String groupName in prefs.getStringList("groupNamesList") ?? []) {
                        for (String catName in prefs.getStringList(groupName) ?? []) {
                          for (String subCatName in prefs.getStringList(catName) ?? []) {
                            for (String itemName in prefs.getStringList(subCatName) ?? []) {
                              if (itemName == widget.oldName) {
                                itemParent = subCatName;
                                isItemFound = true;
                                break GroupLoop;
                              }
                            }
                          }
                        }
                      }
                      if (isItemFound) {
                        print("Old name found");
                        tempList = prefs.getStringList(itemParent) ?? [];
                        int index = tempList.indexOf(widget.oldName);
                        tempList.removeAt(index);
                        tempList.insert(index, renameController.text);
                        prefs.setStringList(itemParent, tempList);
                        // Get old list names
                        List<String> itemDescription = prefs.getStringList(widget.oldName) ?? [];
                        // Set the List with new Name
                        prefs.setStringList(renameController.text, itemDescription);
                        // Delete the old database name to save space
                        prefs.remove(widget.oldName);
                        // Prompt the action was successful and remove the dialog box
                        showCustomSnackBar("Rename successful");
                        Navigator.pop(context);
                      }
                      else {
                        showCustomSnackBar("Item not found");
                        Navigator.pop(context);
                      }
                  }
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
