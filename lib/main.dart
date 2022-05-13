import 'package:flutter/material.dart';
import 'package:item_number_generator/generate_screen.dart';
import 'package:item_number_generator/password_screen.dart';
import 'package:item_number_generator/selection_screen.dart';
import 'package:item_number_generator/tree_view_screen.dart';

void main() {
  runApp(const MaterialApp(home: HomeScreen(),));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Item Number Generator"),
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
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("What do you wish to do?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 150.0,
                        height: 150.0,
                        child: Card(
                          elevation: 15.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: Colors.blue),
                            onPressed: (){
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => const GenerateScreen()));
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const TreeViewScreen()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.remove_red_eye, color: Colors.white,),
                                SizedBox(width: 10.0,),
                                Text("View", style: TextStyle(color: Colors.white, fontSize: 17.0),),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20.0,),
                      SizedBox(
                        width: 150.0,
                        height: 150.0,
                        child: Card(
                          elevation: 15.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: Colors.green),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const PasswordScreen("Create")));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.add, color: Colors.white,),
                                SizedBox(width: 10.0,),
                                Text("Create", style: TextStyle(color: Colors.white, fontSize: 17.0),),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20.0,),
                      SizedBox(
                        width: 150.0,
                        height: 150.0,
                        child: Card(
                          elevation: 15.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: Colors.orange),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const PasswordScreen("Edit")));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.edit, color: Colors.white,),
                                SizedBox(width: 10.0,),
                                Text("Edit", style: TextStyle(color: Colors.white, fontSize: 17.0),),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20.0,),
                      SizedBox(
                        width: 150.0,
                        height: 150.0,
                        child: Card(
                          elevation: 15.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const GenerateScreen()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.settings, color: Colors.white,),
                                SizedBox(width: 10.0,),
                                Text("Generate", style: TextStyle(color: Colors.white, fontSize: 17.0),),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
