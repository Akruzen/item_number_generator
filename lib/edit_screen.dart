import 'package:flutter/material.dart';
import 'package:item_number_generator/edit_screen2.dart';
import 'package:item_number_generator/homeFAB.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
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
        title: const Text("Edit"),
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
                    width: 700,
                    height: 500,
                    child: Card(
                      elevation: 15.0,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Select the element you want to edit", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                            const SizedBox(height: 50.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EditScreen2(buttonClicked: "Group")));
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0)),
                                      )
                                    )
                                  ),
                                  child: SizedBox(
                                    height: 150,
                                    width: 150,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.grid_view_rounded, color: Colors.white,),
                                        SizedBox(width: 10.0,),
                                        Text("Edit\nGroup", style: TextStyle(color: Colors.white, fontSize: 17.0),),
                                      ],
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EditScreen2(buttonClicked: "Category")));
                                  },
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.amberAccent),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(topRight: Radius.circular(50.0)),
                                          )
                                      )
                                  ),
                                  child: SizedBox(
                                    height: 150,
                                    width: 150,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.category, color: Colors.white,),
                                        SizedBox(width: 10.0,),
                                        Text("Edit\nCategory", style: TextStyle(color: Colors.white, fontSize: 17.0),),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EditScreen2(buttonClicked: "Subcategory")));
                                  },
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0)),
                                          )
                                      )
                                  ),
                                  child: SizedBox(
                                    height: 150,
                                    width: 150,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.mediation, color: Colors.white,),
                                        SizedBox(width: 10.0,),
                                        Text("Edit\nSubcategory", style: TextStyle(color: Colors.white, fontSize: 17.0),),
                                      ],
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EditScreen2(buttonClicked: "Item")));
                                  },
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(50.0)),
                                          )
                                      )
                                  ),
                                  child: SizedBox(
                                    height: 150,
                                    width: 150,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.emoji_objects_outlined, color: Colors.white,),
                                        SizedBox(width: 10.0,),
                                        Text("Edit\nItem", style: TextStyle(color: Colors.white, fontSize: 17.0),),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
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
