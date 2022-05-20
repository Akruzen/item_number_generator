/// Program by Omkar Phadke, Pune Institute of Computer Technology, in May 2022

import 'package:flutter/material.dart';
import 'package:item_number_generator/add_subcat2.dart';
import 'package:item_number_generator/homeFAB.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddSubCat extends StatefulWidget {
  final bool isCreateItemTapped;
  const AddSubCat({Key? key, required this.isCreateItemTapped}) : super(key: key);

  @override
  State<AddSubCat> createState() => _AddSubCatState();
}

class _AddSubCatState extends State<AddSubCat> {
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
        title: const Text("Add a Sub Category"),
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
                            child: Text("Select the group", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                          ),
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
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (catDropDownValue == "None") {
                                showCustomSnackBar("Please select a group first");
                              }
                              else {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddSubCat2(selectedGroup: catDropDownValue ?? "None", isCreateItemTapped: widget.isCreateItemTapped,)));
                              }
                            },
                            icon: const Icon(Icons.arrow_right),
                            label: const Text("Next"),
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
