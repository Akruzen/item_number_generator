import 'package:flutter/material.dart';
import 'package:item_number_generator/generate_screen.dart';
import 'package:item_number_generator/password_screen.dart';
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 150.0,
                        height: 150.0,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                  )
                              )
                          ),
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
                      const SizedBox(width: 20.0,),
                      SizedBox(
                        width: 150.0,
                        height: 150.0,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                  )
                              )
                          ),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const PasswordScreen("Create")));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add, color: Colors.white,),
                              SizedBox(width: 10.0,),
                              Text("Master\nData", style: TextStyle(color: Colors.white, fontSize: 17.0),),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20.0,),
                      SizedBox(
                        width: 150.0,
                        height: 150.0,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                  )
                              )
                          ),
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
                      const SizedBox(width: 20.0,),
                      SizedBox(
                        width: 150.0,
                        height: 150.0,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                  )
                              )
                          ),
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
