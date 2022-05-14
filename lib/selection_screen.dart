import 'package:flutter/material.dart';
import 'package:item_number_generator/add_category.dart';
import 'package:item_number_generator/add_group.dart';
import 'package:item_number_generator/add_subcat.dart';
import 'package:item_number_generator/homeFAB.dart';
import 'package:item_number_generator/master_reset_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectionScreenClass extends StatefulWidget {
  final bool isAdmin;
  const SelectionScreenClass({Key? key, required this.isAdmin}) : super(key: key);

  @override
  State<SelectionScreenClass> createState() => _SelectionScreenClassState();
}

class _SelectionScreenClassState extends State<SelectionScreenClass> {

  @override
  void initState() {
    super.initState();
    isAdmin = widget.isAdmin;

  }

  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            int count = 0;
            Navigator.popUntil(context, (route) {
              return count++ == 2;
            });
          },
        ),
        title: const Text("Enter the details"),
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
                    height: 500,
                    child: Card(
                      elevation: 15.0,
                      child: GroupDropDown(isAdmin: isAdmin),
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

class GroupDropDown extends StatefulWidget {
  final bool isAdmin;
  const GroupDropDown({Key? key, required this.isAdmin}) : super(key: key);

  @override
  State<GroupDropDown> createState() => _GroupDropDownState();
}

class _GroupDropDownState extends State<GroupDropDown> {
  List<String> groupList = ["None"];
  String groupDropDownValue = "None";
  List<String> categoryList = ["None"];
  String catDropDownValue = "None";
  List<String> subCatList = ["None"];
  String subCatDropDownValue = "None";

  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemDescController = TextEditingController();

  bool _isSnackBarActive = false;

  void loadValues () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    groupList = prefs.getStringList("groupNamesList") ?? [];
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
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
                ],
              ),
              const SizedBox(width: 20.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start  ,
                children: const [
                  Text("Add a Group:"),
                  SizedBox(height: 25.0,),
                  Text("Add a Category:"),
                  SizedBox(height: 25.0,),
                  Text("Add a Sub Category:"),
                ],
              ),
              const SizedBox(width: 20.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      if (widget.isAdmin) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddGroup()));
                      }
                      else {
                        showCustomSnackBar("Not Permitted. Go to create from the Main Menu instead.");
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add"),
                  ),
                  const SizedBox(height: 20.0,),
                  ElevatedButton.icon(
                    onPressed: (){
                      if (widget.isAdmin) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCategory()));
                      }
                      else {
                        showCustomSnackBar("Not Permitted. Go to create from the Main Menu instead.");
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add"),
                  ),
                  const SizedBox(height: 20.0,),
                  ElevatedButton.icon(
                    onPressed: (){
                      if (widget.isAdmin) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddSubCat(isCreateItemTapped: false,)));
                      }
                      else {
                        showCustomSnackBar("Not Permitted. Go to create from the Main Menu instead.");
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add"),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 100.0,),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(primary: Colors.redAccent),
            label: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Master Reset"),
            ),
            icon: const Icon(Icons.clear),
            onPressed: () async {
              showDialog(context: context, builder: (BuildContext context) => const MasterResetAlert());
            },
          ),
        ],
      ),
    );
  }
}
