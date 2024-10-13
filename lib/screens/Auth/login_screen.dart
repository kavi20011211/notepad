import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notepad/components/rounded_button.dart';
import 'package:notepad/components/text_field_Container.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
    final TextEditingController _username = TextEditingController();
    final TextEditingController _password = TextEditingController();

//DESC: USER SIGNIN FUNCTION

  Future<bool> _signInWithUsernameAndPassword(
      String username, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: username, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return false;
    }
  }

  Future _resetPassword() async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          final TextEditingController emailTextField = TextEditingController();
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                    "Enter your login email address to reset the password.",
                    textAlign: TextAlign.center),
                TextField(
                  controller: emailTextField,
                  decoration:
                      const InputDecoration(hintText: "example@gmail.com"),
                ),
                MaterialButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: emailTextField.text);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                content: Text(
                                    "Reset password link is sent to the email."),
                              );
                            });
                      } on FirebaseAuthException catch (e) {
                        print(e);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                content: Text("Something went wrong!"),
                              );
                            });
                      }
                    },
                    color: const Color.fromARGB(255, 169, 209, 248),
                    child: const Text("Reset password"))
              ],
            ),
          );
        });
  }
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(leading: const Icon(Icons.abc),),

      backgroundColor: Colors.white,

      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            const Text("Welcome! Login here", style: TextStyle(fontSize: 24,fontWeight: FontWeight.w900,color: Colors.blue),),

            TextFieldContainer(
                      child: TextField(
                    controller: _username,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "username or email",
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          await _resetPassword();
                        },
                        style: const ButtonStyle(
                            padding: MaterialStatePropertyAll(
                                EdgeInsets.fromLTRB(0, 0, 45, 0))),
                        child: Text(
                          "Forget password?",
                          style: TextStyle(
                            color: Colors.blue.shade700,
                          ),
                        ),
                      )
                    ],
                  ),

                  RoundedButton(
                    child: ElevatedButton(onPressed: () async{
                      bool isSuccess = await _signInWithUsernameAndPassword(
                              _username.text, _password.text);
                          if (isSuccess == true) {
                            Navigator.pushNamed(context, '/controller_screeen');
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                "You are logged in.",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.grey,
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              dismissDirection: DismissDirection.up,
                            ));
                          }else{
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                "Something wrong! try again.",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.grey,
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              dismissDirection: DismissDirection.up,
                            ));
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
                        child: const Text("Login",style: TextStyle(color: Colors.white),)),
                  ),

                   RoundedButton(
                    child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        style: const ButtonStyle(
                          padding: MaterialStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          ),
                        ),
                        child: const Text("Register", style: TextStyle(color: Colors.black),)),
                  ),
          ],
        ),
      ),
    );
  }
}