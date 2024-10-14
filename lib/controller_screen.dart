import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notepad/screens/home_screen.dart';
import 'package:notepad/screens/notes_screen.dart';
import 'package:notepad/screens/user_screen.dart';

class ControllerScreen extends StatefulWidget {
  const ControllerScreen({super.key});

  @override
  State<ControllerScreen> createState() => _ControllerScreenState();
}

class _ControllerScreenState extends State<ControllerScreen> {
  var initialIndex = 0;
 
 //DESC: SIGN OUT FUNCTION
  bool signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, '/');
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title:const Text("Notepad"),
      actions: [
          IconButton(
            onPressed: () {
              bool isSuccuss = signOut();
              if (isSuccuss == true) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                    "You have logged out succussfully.",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.grey,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  dismissDirection: DismissDirection.up,
                ));
              }
            },
            icon: const Icon(Icons.logout_rounded),
            color: Theme.of(context).iconTheme.color,
          )
        ],),

      body: initialIndex == 0? const HomeScreen(): initialIndex==1? const NoteScreen():const UserScreen(),

      bottomNavigationBar: ConvexAppBar(
    items:const [
      TabItem(icon: Icons.home, title: 'Home'),
      TabItem(icon: Icons.book, title: 'Notes'),
      TabItem(icon: Icons.person, title: 'User'),
    ],
    onTap: (index) {
      setState(() {
        initialIndex = index;
      });
    },
  ),
    );
  }
}