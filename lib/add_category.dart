import 'package:flutter/material.dart';
import 'package:item_number_generator/homeFAB.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {

  TextEditingController catNameController = TextEditingController();
  List<String>? catNamesList = [];
  String? catDropDownValue = "None";

  @override
  Widget build(BuildContext context) {

    bool _isSnackBarActive = false;

    void loadSavedGroups () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        catNamesList = prefs.getStringList("groupNamesList") ?? [];
        catNamesList?.insert(0, "None");
      });
    }

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

    loadSavedGroups();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a Category"),
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
                    height: 400.0,
                    child: Card(
                      elevation: 15.0,
                      child: Column(
                        children: [
                          const SizedBox(height: 20.0,),
                          const Text("Select the group you want to add the category in.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                          const SizedBox(height: 20.0,),
                          DropdownButton<String>(
                            value: catDropDownValue,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                catDropDownValue = newValue!;
                              });
                            },
                            items: catNamesList!
                            .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20.0,),
                          const Text("Enter New Category Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextField(
                              maxLength: 30,
                              controller: catNameController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.category),
                                border: OutlineInputBorder(),
                                labelText: "Category Name",
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0,),
                          ElevatedButton.icon(
                            onPressed: () async {
                              if(catNameController.text.isEmpty) {
                                showCustomSnackBar("Field cannot be empty");
                              }
                              else if (catDropDownValue == "None") {
                                showCustomSnackBar("Please select a group first");
                              }
                              else {
                                if (catNamesList != null) {
                                  String? selectedGroup = catDropDownValue;
                                  setState(() {
                                    catDropDownValue = null;
                                  });
                                  final prefs = await SharedPreferences.getInstance();
                                  String name = catNameController.text.toString();
                                  catNamesList = prefs.getStringList(selectedGroup ?? "Uncategorized") ?? [];
                                  if (catNamesList?.contains(name) == false) {
                                    catNamesList?.add(name);
                                    prefs.setStringList(selectedGroup ?? "Uncategorized", catNamesList ?? ["Empty List"]);
                                    showCustomSnackBar("Category added successfully");
                                    print("Saved " + catNamesList.toString() + " in " + (selectedGroup ?? "Uncategorized"));
                                    print(catNamesList);
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
