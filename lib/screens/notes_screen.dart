import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notepad/components/rounded_button.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final CollectionReference _notes =
      FirebaseFirestore.instance.collection('notes');
  final FirebaseAuth auth = FirebaseAuth.instance;


  //DESC: DELETE NOTE FUNCTION
    Future<void> _deleteTaskItem(String taskID) async {
    await _notes.doc(taskID).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "You have successfully deleted the note",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.grey,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      dismissDirection: DismissDirection.up,
    ));
  }


//DESC: EDIT NOTE FUNCTION
 Future<void> _editTaskItem([DocumentSnapshot? documentSnapshot]) async {
    final TextEditingController title = TextEditingController();
    final TextEditingController content = TextEditingController();
    DateTime now = new DateTime.now();
    if (documentSnapshot != null) {
      title.text = documentSnapshot['title'];
      content.text = documentSnapshot['content'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
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
                    TextField(
                      controller: title,
                      decoration: const InputDecoration(
                        hintText: "title",
                      ),
                    ),
                    TextField(
                      controller: content,
                      decoration: const InputDecoration(
                        hintText: "content",
                      ),
                    ),
                    RoundedButton(
                      child: ElevatedButton(
                        onPressed: () async {
                          await _notes.doc(documentSnapshot!.id).update({
                            'title': title.text,
                            'content': content.text,
                            'time': now
                          });
                          title.text = '';
                          content.text = '';
                        },
                        style: const ButtonStyle(
                          padding: MaterialStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          ),
                        ),
                        child: const Text("Update"),
                      ),
                    )
                  ]));
        });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(stream:  _notes
                  .where("userID",
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(), builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if(streamSnapshot.hasData){
                      return Column(
                    children: [
                      Expanded(
                          child: Card(
                        margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                        child: ListView.builder(
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                                streamSnapshot.data!.docs[index];
                            return Column(
                              children: [
                                ListTile(
                                  leading: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.task_alt_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    documentSnapshot['title'],
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 18, 18, 18),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    children: [
                                      Text(
                                    documentSnapshot['content'],
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 14, 14, 14),
                                    ),
                                  ),
                                  Text(
                                    (documentSnapshot['time'] as Timestamp).toDate().toString(),
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 12, 12, 12),
                                    ),
                                  ),
                                    ],
                                  ),
                                  tileColor: Theme.of(context)
                                      .bottomNavigationBarTheme
                                      .backgroundColor,
                                  trailing: IconButton(
                                      onPressed: () async {
                                       await _editTaskItem(documentSnapshot);
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      )),
                                  onLongPress: () async {
                                    //delete when long press
                                    await _deleteTaskItem(documentSnapshot.id);
                                  },
                                ),
                                const Divider(
                                  height: 5.0,
                                  thickness: 0.8,
                                )
                              ],
                            );
                          },
                        ),
                      ))
                    ],
                  );
                    }else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

      }),),
    );
  }
}