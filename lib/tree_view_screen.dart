/// Program by Omkar Phadke, Pune Institute of Computer Technology, in May 2022

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:item_number_generator/get_part_number.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'create_csv.dart';
import 'homeFAB.dart';

class TreeViewScreen extends StatefulWidget {
  const TreeViewScreen({Key? key}) : super(key: key);

  @override
  State<TreeViewScreen> createState() => _TreeViewScreenState();
}

class _TreeViewScreenState extends State<TreeViewScreen> {

  @override
  void initState() {
    super.initState();
    loadTree();
  }

  List<TreeNode> groupTreeNodeList = [];

  void loadTree() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (String groupNames in (prefs.getStringList("groupNamesList")) ?? []) {
      print("groupName = " + groupNames);
      List<TreeNode> catTreeNodeList = [];
      for (String catName in (prefs.getStringList(groupNames)) ?? []) {
        print("catName = " + catName);
        List<TreeNode> subCatTreeNodeList = [];
        for(String subCatName in (prefs.getStringList(catName)) ?? []) {
          print("subCatName = " + subCatName);
          List<TreeNode> itemTreeNodeList = [];
          for (String itemName in (prefs.getStringList(subCatName)) ?? []) {
            String partNumber = await getPartNumber(itemName);
            print("itemName = " + itemName);
            itemTreeNodeList.add(TreeNode(content: borderText(itemName + " - " + partNumber, Colors.greenAccent)));
          }
          subCatTreeNodeList.add(TreeNode(content: borderText(subCatName, Colors.blueAccent), children: itemTreeNodeList));
        }
        catTreeNodeList.add(TreeNode(content: borderText(catName, Colors.amberAccent), children: subCatTreeNodeList));
      }
      TreeNode groupTreeNode = TreeNode(
        content: borderText(groupNames, Colors.redAccent),
        children: catTreeNodeList
      );
      setState(() {
        groupTreeNodeList.add(groupTreeNode);
      });
    }
  }

  Widget borderText(String text, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
      decoration: BoxDecoration(
          border: Border.all(color: color, width: 3.0),
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tree View"),
        centerTitle: true,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              try {
                createCSV(context);
              } catch (e) {
                showCustomSnackBar(context, e.toString());
              }
            },
            label: const Text("Create CSV"),
            icon: const Icon(Icons.table_chart_outlined),
            heroTag: "CSV",
            backgroundColor: Colors.green,
          ),
          const SizedBox(height: 20.0,),
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
                  const SizedBox(height: 20.0,),
                  SizedBox(
                    width: 500,
                    child: Card(
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const SizedBox(width: 20.0,),
                            const Text("Legend:", style: TextStyle(fontWeight: FontWeight.bold),),
                            const SizedBox(width: 20.0,),
                            borderText("Group", Colors.redAccent),
                            const SizedBox(width: 20.0,),
                            borderText("Category", Colors.amberAccent),
                            const SizedBox(width: 20.0,),
                            borderText("Subcategory", Colors.blueAccent),
                            const SizedBox(width: 20.0,),
                            borderText("Item", Colors.greenAccent),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 500,
                    height: 500,
                    child: Card(
                      elevation: 15.0,
                      child: SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              const SizedBox(height: 20.0,),
                              TreeView(nodes: groupTreeNodeList, indent: 20.0, iconSize: 17.0),
                            ],
                          ),
                        ),
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
