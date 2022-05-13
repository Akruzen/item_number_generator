import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddGroup extends StatefulWidget {
  const AddGroup({Key? key}) : super(key: key);

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {

  TextEditingController groupNameController = TextEditingController();
  List<String>? groupNamesList = [];

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
        title: const Text("Add a Group"),
        centerTitle: true,
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
                    width: 500.0,
                    height: 400.0,
                    child: Card(
                      elevation: 15.0,
                      child: Column(
                        children: [
                          const SizedBox(height: 20.0,),
                          const Text("Enter New Group Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextField(
                              maxLength: 30,
                              controller: groupNameController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.grid_view_rounded),
                                border: OutlineInputBorder(),
                                labelText: "Group Name",
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0,),
                          ElevatedButton.icon(
                            onPressed: () async {
                              if(groupNameController.text.isEmpty) {
                                showCustomSnackBar("Field cannot be empty");
                              }
                              else {
                                if (groupNamesList != null) {
                                  final prefs = await SharedPreferences.getInstance();
                                  String name = groupNameController.text.toString();
                                  groupNamesList = prefs.getStringList("groupNamesList") ?? [];
                                  if (groupNamesList?.contains(name) == false) {
                                    groupNamesList?.add(name);
                                    prefs.setStringList("groupNamesList", groupNamesList ?? ["Empty List"]);
                                    showCustomSnackBar("Group added successfully");
                                    print("Saved");
                                    print(groupNamesList);
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
