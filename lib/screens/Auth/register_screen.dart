import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notepad/components/rounded_button.dart';
import 'package:notepad/components/text_field_Container.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //DESC: GET USER COLLECTION REFERENCE
  final CollectionReference _users = FirebaseFirestore.instance.collection('users');

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password= TextEditingController();
  final TextEditingController _confirmpassword= TextEditingController();

//DESC: CREATE THE USER
Future<bool> _createUser (name,email,password) async{
  try{
    await _users.add({
      "name":name,
      "email":email,
      "password":password
    });

    //DESC: ADD THE CREATED USER TO AUTHENTICATIONS
    _createUserWithEmailPass(email, password);

    return true;
  }catch(e){
    print(e);
    return false;
  }
}

//DESC: CREATING USER WITH EMAIL AND PASSWORD
    Future<void> _createUserWithEmailPass(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading:const Icon(Icons.abc),),
      backgroundColor: Colors.white,

      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            const Text("Welcome! Register for notepad here", style: TextStyle(fontSize: 24,fontWeight: FontWeight.w900,color: Colors.blue),),

            TextFieldContainer(
                      child: TextField(
                    controller: _name,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "username",
                      suffixIcon: Icon(
                        Icons.mail_rounded,
                        size: 16,
                      ),
                    ),
                  )),

              TextFieldContainer(
                      child: TextField(
                    controller: _email,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "email",
                      suffixIcon: Icon(
                        Icons.mail_rounded,
                        size: 16,
                      ),
                    ),
                  )),

              TextFieldContainer(
                      child: TextField(
                    obscureText: true,
                    controller: _password,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "password",
                        suffixIcon: Icon(
                          Icons.key_rounded,
                          size: 16,
                        )),
                  )),

              TextFieldContainer(
                      child: TextField(
                    obscureText: true,
                    controller: _confirmpassword,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "confirm password",
                        suffixIcon: Icon(
                          Icons.key_rounded,
                          size: 16,
                        )),
                  )),


                  RoundedButton(
                    child: ElevatedButton(onPressed: ()async{
                      try{
                        if(_password.text != _confirmpassword.text){
                          ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            "Passwords are mismatched! try again.",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.grey,
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          dismissDirection: DismissDirection.up,
                        ));
                        }else if(_name.text.isEmpty || _email.text.isEmpty || _password.text.isEmpty){
                          ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            "Fill the required fields.",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.grey,
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          dismissDirection: DismissDirection.up,
                        ));
                        }else{
                          bool isSuccess = await _createUser(_name.text, _email.text, _password.text);
                          if(isSuccess){
                            ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              "You are registered succussfully!.",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.grey,
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            dismissDirection: DismissDirection.up,
                          ));
                          Navigator.pushNamed(context, '/');
                          }else{
                            ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              "Something went wrong! please try again.",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.grey,
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            dismissDirection: DismissDirection.up,
                          ));
                          }
                        }
                      }catch(e){
                        print(e);
                      }
                    }, 
                    style: const ButtonStyle(
                          padding: MaterialStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          ),
                          backgroundColor: MaterialStatePropertyAll(
                            Colors.cyan
                          )
                        ),
                        child: const Text("Register",style: TextStyle(color: Colors.white),)),
                  ),
          ],
        ),
      ),
    );
  }
}