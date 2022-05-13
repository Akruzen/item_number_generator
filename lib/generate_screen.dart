import 'package:flutter/material.dart';
import 'package:item_number_generator/homeFAB.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  String code = ""; // The code which generates at the end

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
        title: const Text("Item Name Generator"),
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
                    width: 500,
                    height: 75,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.grid_view_rounded, color: Colors.redAccent,),
                            const SizedBox(width: 20.0,),
                            const Text("Select a Group:"),
                            const SizedBox(width: 25.0,),
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
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            const Icon(Icons.category, color: Colors.amberAccent,),
                            const SizedBox(width: 20.0,),
                            const Text("Select a Category:"),
                            const SizedBox(width: 25.0,),
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
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            const Icon(Icons.mediation, color: Colors.blueAccent,),
                            const SizedBox(width: 20.0,),
                            const Text("Select a Sub Category:"),
                            const SizedBox(width: 25.0,),
                            DropdownButton<String>(
                              value: selectedSubCat,
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
                                    clearDropDown("Item");
                                    selectedSubCat = newValue!;
                                    loadItems();
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
                    height: 75,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            const Icon(Icons.emoji_objects_outlined, color: Colors.green,),
                            const SizedBox(width: 20.0,),
                            const Text("Select an Item: "),
                            const SizedBox(width: 25.0,),
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
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 500,
                    height: 150,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.stars_sharp),
                              label: const Text("Generate"),
                              onPressed: (){
                                if (
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
                  /*SizedBox(
                    width: 500,
                    height: 500,
                    child: Card(
                      elevation: 15.0,
                      child: Column(
                        children: [
                          const SizedBox(height: 10.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: const [
                                  Icon(Icons.grid_view_rounded, color: Colors.redAccent,),
                                  SizedBox(height: 20.0,),
                                  Icon(Icons.category, color: Colors.amberAccent,),
                                  SizedBox(height: 20.0,),
                                  Icon(Icons.mediation, color: Colors.blueAccent,),
                                  SizedBox(height: 20.0,),
                                  Icon(Icons.emoji_objects_outlined, color: Colors.green,),
                                ],
                              ),
                              const SizedBox(width: 20.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start  ,
                                children: const [
                                  Text("Select a Group:"),
                                  SizedBox(height: 25.0,),
                                  Text("Select a Category:"),
                                  SizedBox(height: 25.0,),
                                  Text("Select a Sub Category:"),
                                  SizedBox(height: 25.0,),
                                  Text("Select an Item: "),
                                ],
                              ),
                              const SizedBox(width: 20.0,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
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
                                  DropdownButton<String>(
                                    value: selectedSubCat,
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
                                          clearDropDown("Item");
                                          selectedSubCat = newValue!;
                                          loadItems();
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
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0,),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.stars_sharp),
                            label: const Text("Generate"),
                            onPressed: (){
                              if (
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
                              }
                            },
                          ),
                          const SizedBox(height: 20.0,),
                          Text(code, style: const TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
