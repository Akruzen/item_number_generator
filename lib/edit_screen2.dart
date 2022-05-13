import 'package:flutter/material.dart';
import 'package:item_number_generator/edit_Menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditScreen2 extends StatefulWidget {

  final String buttonClicked;

  const EditScreen2({Key? key, required this.buttonClicked}) : super(key: key);

  @override
  State<EditScreen2> createState() => _EditScreen2State();
}

class _EditScreen2State extends State<EditScreen2> {

  List<Widget> dropDownList = [];

  List<String> groupDropDown = [];
  List<Widget> groupListTiles = [];
  List<String> catDropDown = [];
  List<Widget> catListTiles = [];
  List<String> subCatDropDown = [];
  List<Widget> subCatListTiles = [];
  List<String> itemDropDown = [];
  List<Widget> itemListTiles = [];

  @override
  void initState() {
    super.initState();
    switch (widget.buttonClicked) {
      case "Group":
        loadGroups();
        break;
      case "Category":
        loadCategories();
        break;
      case "Subcategory":
        loadSubCategories();
        break;
      case "Item":
        loadItems();
        break;
    }
  }

  void loadGroups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      groupDropDown = prefs.getStringList("groupNamesList") ?? [];
    });
    List<Widget> tempList = [];
    for (String group in groupDropDown) {
      tempList.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
          child: Card(
            color: Colors.green[50],
            elevation: 2.0,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListTile(
                onTap: (){
                  showDialog(context: context, builder: (BuildContext context) => EditMenu(oldName: group, editParam: "Group",)).then((value) => {loadGroups()});
                },
                title: Text(group),
              ),
            ),
          ),
        ),
      );
    }
    setState(() {
      groupListTiles = tempList;
    });
  }
  void loadCategories() async {
    List<Widget> tempList = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    groupDropDown = prefs.getStringList("groupNamesList") ?? [];
    for (String group in groupDropDown) {
      catDropDown = prefs.getStringList(group) ?? [];
      for (String cat in catDropDown) {
        tempList.add(
          Container(
            margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
            child: Card(
              color: Colors.green[50],
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListTile(
                  onTap: (){
                    showDialog(context: context, builder: (BuildContext context) => EditMenu(oldName: cat, editParam: "Category",)).then((value) => {loadCategories()});
                  },
                  title: Text(cat),
                ),
              ),
            ),
          ),
        );
      }
      setState(() {
        catListTiles = tempList;
      });
    }
  }
  void loadSubCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Widget> tempList = [];
    groupDropDown = prefs.getStringList("groupNamesList") ?? [];
    for (String group in groupDropDown) {
      for (String cat in (prefs.getStringList(group)) ?? []) {
        for (String subCat in (prefs.getStringList(cat)) ?? []) {
          tempList.add(
            Container(
              margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
              child: Card(
                color: Colors.green[50],
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListTile(
                    onTap: (){
                      showDialog(context: context, builder: (BuildContext context) => EditMenu(oldName: subCat, editParam: "Subcategory",)).then((value) => {loadSubCategories()});
                    },
                    title: Text(subCat),
                  ),
                ),
              ),
            ),
          );
        }
      }
    }
    setState(() {
      subCatListTiles = tempList;
    });
  }
  void loadItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Widget> tempList = [];
    groupDropDown = prefs.getStringList("groupNamesList") ?? [];
    for (String group in groupDropDown) {
      for (String cat in (prefs.getStringList(group)) ?? []) {
        for (String subCat in (prefs.getStringList(cat)) ?? []) {
          for (String item in (prefs.getStringList(subCat)) ?? []) {
            tempList.add(
              Container(
                margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                child: Card(
                  color: Colors.green[50],
                  elevation: 2.0,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      onTap: (){
                        showDialog(context: context, builder: (BuildContext context) => EditMenu(oldName: item, editParam: "Item",)).then((value) => {loadItems()});
                      },
                      title: Text(item),
                    ),
                  ),
                ),
              ),
            );
          }
        }
      }
    }
    setState(() {
      itemListTiles = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit"),
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
                    width: 500,
                    height: 500,
                    child: Card(
                      elevation: 15.0,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 10,),
                            const Text("Which parameter you wish to edit?"),
                            const SizedBox(height: 10,),
                            ...groupListTiles,
                            ...catListTiles,
                            ...subCatListTiles,
                            ...itemListTiles,
                          ],
                        ),
                      ),
                    )
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
