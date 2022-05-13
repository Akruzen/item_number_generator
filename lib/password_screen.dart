import 'package:flutter/material.dart';
import 'package:item_number_generator/edit_screen.dart';
import 'package:item_number_generator/homeFAB.dart';
import 'package:item_number_generator/selection_screen.dart';

class PasswordScreen extends StatefulWidget {
  final String buttonPress;
  const PasswordScreen(this.buttonPress, {Key? key}) : super(key: key);

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {

  TextEditingController _password_controller = TextEditingController();
  bool _invalid = false;
  bool showPassword = false;

  @override
  void dispose() {
    _password_controller.dispose();
    super.dispose();
  }

  void okPressed () {
    setState(() {
      _invalid = _password_controller.text != "abcd";
      if (!_invalid) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => widget.buttonPress == "Edit" ? const EditScreen() : const SelectionScreenClass(isAdmin: true)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.buttonPress),
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
                          SizedBox(
                            width: 100.0,
                            height: 100.0,
                            child: Image.asset("assets/key.png"),
                          ),
                          const SizedBox(height: 20.0,),
                          Text(
                              (widget.buttonPress == "Create" ? "Creating " : "Editing ") + "Items requires a password."
                          ),
                          const SizedBox(height: 20.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                            child: TextField(
                              onSubmitted: (value) {
                                okPressed();
                              },
                              obscureText: !showPassword,
                              controller: _password_controller,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                ),
                                prefixIcon: const Icon(Icons.password),
                                border: const OutlineInputBorder(),
                                labelText: "Password",
                                errorText: _invalid ? 'Wrong Password' : null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  child: const Text("OK"),
                                  onPressed: (){
                                    okPressed();
                                  },
                                ),
                            ],),
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
