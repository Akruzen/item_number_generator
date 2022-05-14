import 'package:flutter/material.dart';
import 'package:item_number_generator/checkNameExist.dart';
import 'package:item_number_generator/homeFAB.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddItem extends StatefulWidget {
  final String selectedSubCategory;
  const AddItem({Key? key, required this.selectedSubCategory}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemDescController = TextEditingController();
  List<String>? itemNamesList = [];
  List<String>? itemDescList = [];

  @override
  Widget build(BuildContext context) {

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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add an Item"),
        centerTitle: true,
      ),
      floatingActionButton: getHomeButton(context),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: 500.0,
                    height: 500.0,
                    child: Card(
                      elevation: 15.0,
                      child: Column(
                        children: [
                          const SizedBox(height: 20.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text("Selected Sub Category: " + widget.selectedSubCategory, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                          ),
                          const SizedBox(height: 20.0,),
                          const Text("Enter New Item", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextField(
                              maxLength: 30,
                              controller: itemNameController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.emoji_objects_outlined),
                                border: OutlineInputBorder(),
                                labelText: "Item Name",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextField(
                              maxLength: 30,
                              controller: itemDescController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.description),
                                border: OutlineInputBorder(),
                                labelText: "Item Description",
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0,),
                          ElevatedButton.icon(
                            onPressed: () async {
                              if(itemNameController.text.isEmpty || itemDescController.text.isEmpty) {
                                showCustomSnackBar("Field cannot be empty");
                              }
                              else if (widget.selectedSubCategory == "None") {
                                showCustomSnackBar("Please select a group first");
                              }
                              else {
                                bool nameExists = await checkNameExists(itemNameController.text.toString());
                                if (nameExists) {
                                  showCustomSnackBar("A Group, Category, Sub Category or Item with same name already exists.");
                                }
                                else if (itemNamesList != null) {
                                  String? selectedSubCat = widget.selectedSubCategory;
                                  final prefs = await SharedPreferences.getInstance();
                                  String name = itemNameController.text.toString();
                                  String desc = itemDescController.text.toString();
                                  itemNamesList = prefs.getStringList(selectedSubCat) ?? [];
                                  if (itemNamesList?.contains(name) == false) {
                                    itemNamesList?.add(name);
                                    itemDescList?.add(desc);
                                    // To save the item Name
                                    prefs.setStringList(selectedSubCat, itemNamesList ?? ["Empty List"]);
                                    // To save the item Description
                                    prefs.setStringList(name, itemDescList ?? ["Empty List"]);
                                    showCustomSnackBar("Item added successfully");
                                    print("Saved " + itemNamesList.toString() + " in " + (selectedSubCat));
                                    print("Saved " + itemDescList.toString() + " in " + (name));
                                    print(itemNamesList);
                                    print(itemDescList);
                                    Navigator.pop(context);
                                  }
                                  else {
                                    showCustomSnackBar("Name already exists");
                                  }
                                }
                              }
                            },
                            icon: const Icon(Icons.check),
                            label: const Text("Confirm and Add"),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
