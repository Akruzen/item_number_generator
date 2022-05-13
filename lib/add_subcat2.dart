import 'package:flutter/material.dart';
import 'package:item_number_generator/add_item.dart';
import 'package:item_number_generator/homeFAB.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddSubCat2 extends StatefulWidget {
  final String selectedGroup;
  final bool isCreateItemTapped;
  const AddSubCat2({Key? key, required this.selectedGroup, required this.isCreateItemTapped}) : super(key: key);

  @override
  State<AddSubCat2> createState() => _AddSubCat2State();
}

class _AddSubCat2State extends State<AddSubCat2> {

  @override
  void initState() {
    super.initState();
  }

  TextEditingController subCatNameController = TextEditingController();
  List<String>? subCatNamesList = [];
  String? subCatDropDownValue = "None";

  @override
  Widget build(BuildContext context) {

    bool _isSnackBarActive = false;

    void loadSavedGroups () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        subCatNamesList = prefs.getStringList(widget.selectedGroup) ?? [];
        subCatNamesList?.insert(0, "None");
      });
    }

    List<Widget> toggleTextFieldVisibility () {

      List<Widget> widgetList = [];
      widgetList.clear();

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

      if (widget.isCreateItemTapped) {
        widgetList = [
          const SizedBox(height: 20.0,),
          ElevatedButton.icon(
            icon: const Icon(Icons.arrow_right),
            label: const Text("Next"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddItem(selectedCategory: subCatDropDownValue ?? "None")));
            },
          ),
        ];
        return widgetList;
      }
      else {
        widgetList = [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              maxLength: 30,
              controller: subCatNameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.mediation),
                border: OutlineInputBorder(),
                labelText: "Sub Category Name",
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              if (subCatDropDownValue == "None") {
                showCustomSnackBar("Please select a category first");
              }
              else if (subCatNameController.text.isEmpty) {
                showCustomSnackBar("Field cannot be empty");
              }
              else {
                if (subCatNamesList != null) {
                  String? selectedCategory = subCatDropDownValue;
                  setState(() {
                    subCatDropDownValue = null;
                  });
                  final prefs = await SharedPreferences.getInstance();
                  String name = subCatNameController.text.toString();
                  subCatNamesList = prefs.getStringList(selectedCategory ?? "Uncategorized") ?? [];
                  if (subCatNamesList?.contains(name) == false) {
                    subCatNamesList?.add(name);
                    prefs.setStringList(selectedCategory ?? "Uncategorized", subCatNamesList ?? ["Empty List"]);
                    showCustomSnackBar("Subcategory added successfully");
                    print("Saved " + subCatNamesList.toString() + " in " + (selectedCategory ?? "Uncategorized"));
                    print(subCatNamesList);
                    int count = 0;
                    Navigator.popUntil(context, (route) {
                      return count++ == 2;
                    });
                  }
                  else {
                    showCustomSnackBar("Name already exists");
                  }
                }
              }
            },
            icon: const Icon(Icons.check),
            label: const Text("Confirm and Save"),
          ),
        ];
        return widgetList;
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
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text("Select the category you want to add the sub category in.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                          ),
                          const SizedBox(height: 20.0,),
                          DropdownButton<String>(
                            value: subCatDropDownValue,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                subCatDropDownValue = newValue!;
                              });
                            },
                            items: subCatNamesList!
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20.0,),
                          ...toggleTextFieldVisibility(),
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
