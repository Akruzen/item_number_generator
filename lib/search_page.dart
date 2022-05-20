/// Program by Omkar Phadke, Pune Institute of Computer Technology, in May 2022

import 'package:flutter/material.dart';
import 'package:item_number_generator/get_item_hierarchy.dart';
import 'package:item_number_generator/homeFAB.dart';
import 'package:item_number_generator/search_result_func.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  String result = "Type something in search to start.";
  bool _isSnackBarActive = false;
  List<Widget> tileList = [];
  TextEditingController controller = TextEditingController();

  Column getListTile(String title, List<String> hierarchyList) {
    return Column(
      children: [
        ListTile(
          title: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(title),
                Text(hierarchyList[0] + " -> " + hierarchyList[1] + " -> " + hierarchyList[2], style: const TextStyle(
                  fontSize: 15.0, color: Colors.grey
                ),),
                Text("Description: " + hierarchyList[3], style: const TextStyle(
                    fontSize: 15.0, color: Colors.grey
                ),),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10.0,)
      ],
    );
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

  void goClicked(String keyword) async {
    tileList.clear();
    List<String> matchResultsList = await getSearchMatch(keyword);
    for (String result in matchResultsList) {
      List<String> hierarchyList = await getItemHierarchy(result);
      tileList.add(getListTile(result, hierarchyList));
    }
    result = tileList.isEmpty ? "No results found." : "Matches Found";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
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
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(20.0),
                              child: TextField(
                                onChanged: (String value) {
                                  if (controller.text.isEmpty) {
                                    setState(() {
                                      result = "Type something in search to start.";
                                      tileList = [];
                                    });
                                  }
                                  else {
                                    setState(() {
                                      goClicked(controller.text.toString());
                                    });
                                  }
                                },
                                onSubmitted: (value) {
                                  if (controller.text.isEmpty) {
                                    showCustomSnackBar("Please enter a value to search");
                                  }
                                  else {
                                    setState(() {
                                      goClicked(controller.text.toString());
                                    });
                                  }
                                },
                                controller: controller,
                                decoration: InputDecoration(
                                  labelText: "Search",
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      if (controller.text.isEmpty) {
                                        showCustomSnackBar("Please enter a value to search");
                                      }
                                      else {
                                        setState(() {
                                          goClicked(controller.text.toString());
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.arrow_forward_rounded),
                                  ),
                                  suffixText: "GO",
                                  prefixIcon: const Icon(Icons.search_rounded),
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(50)),
                                      borderSide: BorderSide(
                                        color:Colors.redAccent,
                                        width: 3,
                                      )
                                  )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                  SizedBox(
                    width: 500,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 20.0,),
                            Text(result),
                            const SizedBox(height: 20.0,),
                            ...tileList,
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
