/// Program by Omkar Phadke, Pune Institute of Computer Technology, in May 2022

import 'package:flutter/material.dart';
import 'package:item_number_generator/get_item_length.dart';
import 'package:item_number_generator/homeFAB.dart';
import 'package:item_number_generator/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_item.dart';
import 'checkNameExist.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({Key? key}) : super(key: key);

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {

  bool _isSnackBarActive = false;

  List<String> groupDropDown = [];
  List<String> catDropDown = [];
  List<String> subCatDropDown = [];
  List<String> itemDropDown = [];

  String selectedGroup = "None";
  String selectedCat = "None";
  String selectedSubCat = "None";
  String selectedItem = "None";

  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemDescController = TextEditingController();

  List<String>? itemNamesList = [];
  List<String>? itemDescList = [];

  String code = ""; // The code which generates at the end

  String groupCode = "";
  String catCode = "";
  String subCatCode = "";
  String itemCode = "";
  
  void setCode () {
    setState(() {
      code = groupCode + (catCode != "" ? catCode.toString().padLeft(2, "0") : "") + (subCatCode != "" ? subCatCode.toString().padLeft(2, "0") : "") + (itemCode != "" ? itemCode.toString().padLeft(3, "0") : "");
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

  void loadGroups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      groupDropDown = prefs.getStringList("groupNamesList") ?? [];
      groupDropDown.insert(0, "None");
    });
  }
  void loadCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      catDropDown = prefs.getStringList(selectedGroup) ?? [];
      catDropDown.insert(0, "None");
    });
  }
  void loadSubCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      subCatDropDown = prefs.getStringList(selectedCat) ?? [];
      subCatDropDown.insert(0, "None");
    });
  }
  void loadItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      itemDropDown = prefs.getStringList(selectedSubCat) ?? [];
      itemDropDown.insert(0, "None");
    });
  }
  void clearDropDown(String name) {
    switch (name) {
      case "Cat":
        catDropDown = [];
        selectedCat = "None";
        break;
      case "SubCat":
        subCatDropDown = [];
        selectedSubCat = "None";
        break;
      case "Item":
        itemDropDown = [];
        selectedItem = "None";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    loadGroups();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate an Part Number"),
        centerTitle: true,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 20,),
          FloatingActionButton.extended(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
            },
            label: const Text("Search for Item"),
            icon: const Icon(Icons.search),
            heroTag: "Search",
            backgroundColor: Colors.amber[700],
          ),
          const SizedBox(height: 20,),
          FloatingActionButton.extended(
            onPressed: (){
              if (selectedGroup == "None" || selectedCat == "None" || selectedSubCat == "None") {
                showCustomSnackBar("Please select a subcategory before proceeding");
              }
              else {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddItem(selectedSubCategory: selectedSubCat,))).then((value) => setState(() {
                  itemDropDown.clear();
                  loadItems();
                }));
              }
            },
            heroTag: null,
            label: const Text("Add Item in selected Sub Category"),
            icon: const Icon(Icons.emoji_objects_outlined),
          ),
          const SizedBox(height: 20,),
          getHomeButton(context),
        ],
      ),
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
                    width: 500,
                    height: 75,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.grid_view_rounded, color: Colors.redAccent,),
                            const SizedBox(width: 20.0,),
                            const Text("Select a Group:"),
                            const SizedBox(width: 70.0,),
                            DropdownButton<String>(
                              value: selectedGroup,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  if (newValue != "None") {
                                    setState(() {
                                      groupCode = String.fromCharCode(groupDropDown.indexOf(newValue ?? selectedGroup) + 64);
                                      catCode = "";
                                      subCatCode = "";
                                      itemCode = "";
                                      setCode();
                                    });
                                    clearDropDown("Cat");
                                    clearDropDown("SubCat");
                                    clearDropDown("Item");
                                    selectedGroup = newValue!;
                                    loadCategories();
                                  }
                                });
                              },
                              items: groupDropDown.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 500,
                    height: 75,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            const Icon(Icons.category, color: Colors.amberAccent,),
                            const SizedBox(width: 20.0,),
                            const Text("Select a Category:"),
                            const SizedBox(width: 55.0,),
                            DropdownButton<String>(
                              value: selectedCat,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  if (newValue != "None") {
                                    setState(() {
                                      catCode = catDropDown.indexOf(newValue ?? selectedCat).toString();
                                      subCatCode = "";
                                      itemCode = "";
                                      setCode();
                                    });
                                    clearDropDown("SubCat");
                                    clearDropDown("Item");
                                    selectedCat = newValue!;
                                    loadSubCategories();
                                  }
                                });
                              },
                              items: catDropDown.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 500,
                    height: 75,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            const Icon(Icons.mediation, color: Colors.blueAccent,),
                            const SizedBox(width: 20.0,),
                            const Text("Select a Sub Category:"),
                            const SizedBox(width: 29.0,),
                            DropdownButton<String>(
                              value: selectedSubCat,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String? newValue) async {
                                int itemLength = await getItemLength(newValue??selectedSubCat);
                                setState(() {
                                  if (newValue != "None") {
                                    // clearDropDown("Item");
                                    selectedSubCat = newValue!;
                                    loadItems();
                                    setState(() {
                                      itemLength;
                                      subCatCode = subCatDropDown.indexOf(newValue).toString();
                                      itemCode = "-" + (itemLength + 1).toString().padLeft(3, "0");
                                      setCode();
                                    });
                                  }
                                });
                              },
                              items: subCatDropDown.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 500,
                    height: 250,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        /*child: Row(
                          children: [
                            const Icon(Icons.emoji_objects_outlined, color: Colors.green,),
                            const SizedBox(width: 20.0,),
                            const Text("Select an Item: "),
                            const SizedBox(width: 72.0,),
                            DropdownButton<String>(
                              value: selectedItem,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  if (newValue != "None") {
                                    selectedItem = newValue!;
                                  }
                                });
                              },
                              items: itemDropDown.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),*/
                        child: Column(
                          children: [
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
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 500,
                    height: 150,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.check),
                              label: const Text("Save and Continue"),
                              onPressed: () async {
                                /*if (
                                selectedGroup != "None" &&
                                    selectedCat != "None" &&
                                    selectedSubCat != "None" &&
                                    selectedItem != "None"
                                ) {
                                  // Code generation logic
                                  String tempCode = "";
                                  // Characters start from ASCII value 65. Ignoring 0th index of "None" hence added 64
                                  String groupCode = String.fromCharCode(groupDropDown.indexOf(selectedGroup) + 64);
                                  int catCode = catDropDown.indexOf(selectedCat);
                                  int subCatCode = subCatDropDown.indexOf(selectedSubCat);
                                  int itemCode = itemDropDown.indexOf(selectedItem);
                                  tempCode = "Code: " + groupCode + catCode.toString().padLeft(2, "0") + subCatCode.toString().padLeft(2, "0") + itemCode.toString().padLeft(3, "0");
                                  setState(() {
                                    code = tempCode;
                                  });
                                }
                                else {
                                  showCustomSnackBar("All selections are mandatory");
                                }*/
                                if (
                                selectedGroup != "None" &&
                                    selectedCat != "None" &&
                                    selectedSubCat != "None"
                                ) {
                                  print("Conditions verified");
                                  if(itemNameController.text.isEmpty || itemDescController.text.isEmpty) {
                                    showCustomSnackBar("Field cannot be empty");
                                  }
                                  else {
                                    bool nameExists = await checkNameExists(itemNameController.text.toString());
                                    if (nameExists) {
                                      print("Name exists");
                                      showCustomSnackBar("A Group, Category, Sub Category or Item with same name already exists.");
                                    }
                                    else if (itemNamesList != null) {
                                      print("Name doesn't exist");
                                      String? selectedSubCat2 = selectedSubCat;
                                      final prefs = await SharedPreferences.getInstance();
                                      String name = itemNameController.text.toString();
                                      String desc = itemDescController.text.toString();
                                      itemNamesList = prefs.getStringList(selectedSubCat2) ?? [];
                                      if (itemNamesList!.contains(name) == false) {
                                        itemNamesList!.add(name);
                                        itemDescList?.add(desc);
                                        // To save the item Name
                                        prefs.setStringList(selectedSubCat2, itemNamesList ?? ["Empty List"]);
                                        // To save the item Description
                                        prefs.setStringList(name, itemDescList ?? ["Empty List"]);
                                        showCustomSnackBar("Item added successfully");
                                        print("Saved " + itemNamesList.toString() + " in " + (selectedSubCat2));
                                        print("Saved " + itemDescList.toString() + " in " + (name));
                                        print(itemNamesList);
                                        print(itemDescList);
                                        int itemLength = await getItemLength(selectedSubCat);
                                        setState(() {
                                          itemCode = "-" + (itemLength + 1).toString().padLeft(3, "0");
                                          setCode();
                                        });
                                        // Navigator.pop(context, "again");
                                      }
                                      else {
                                        showCustomSnackBar("Name already exists");
                                      }
                                    }
                                  }
                                }
                              },
                            ),
                            const SizedBox(height: 20.0,),
                            Text(code, style: const TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
