import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
final CollectionReference _notes =
      FirebaseFirestore.instance.collection('notes');
  final FirebaseAuth auth = FirebaseAuth.instance;

//DESC: ADD NOTES BY FLOATING BUTTON FUNCTION
  Future _addNote() async {
    String currentUserID = auth.currentUser!.uid;
    DateTime now = new DateTime.now();
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          final TextEditingController title = TextEditingController();
          final TextEditingController content = TextEditingController();
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
                Text("Add your note",),
                TextField(
                  controller: title,
                  decoration:
                      const InputDecoration(hintText: "title"),
                ),
                TextField(
                  controller: content,
                  decoration:
                      const InputDecoration(hintText: "content"),
                ),
                MaterialButton(onPressed: ()async{
                    await _notes.add({
                    "title":title.text,
                    "content":content.text,
                    "userID":currentUserID,
                    "time": now
                  });
                  title.text = '';
                  content.text = '';
                },
                child:const Text("Add"),)
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Container(
            height: 300,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(width: 1,color: Colors.yellow),
              color: Colors.yellow
            ),
            child:const Center(
              child: Text("Welcome to the notepad!",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
            ),
          )
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(onPressed: ()async{
      await _addNote();
    }, child:const Text("+", style: TextStyle(fontSize: 18),),),
    );
  }
}