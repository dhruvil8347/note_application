import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:note_app/create_note_screen.dart';
import 'package:note_app/login.dart';
import 'model/notesmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

Logger logger = Logger();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Notes",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomepage(),
    );
  }
}

class MyHomepage extends StatefulWidget {
  const MyHomepage({Key? key}) : super(key: key);

  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  final CollectionReference notes =
      FirebaseFirestore.instance.collection("notes");
  final auth = FirebaseAuth.instance;
  String uid = "";

  @override
  void initState() {
    uid = auth.currentUser?.uid ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateNoteScreen(),
              ));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          TextButton(
              onPressed: () {
                if (uid.isNotEmpty) {
                  logout();
                }
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false);
              },
              child: Text(
                uid.isNotEmpty ? "Logout" : "Login",
                style: const TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('notes').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView(

                      ///docs[index].id
                      children: snapshot.data!.docs
                          .where((e) => uid == e['id'])
                          .map((document) {
                    return ListTile(
                      title: InkWell(
                        onLongPress: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Delete ?",
                                      style: TextStyle(color: Colors.red)),
                                  content: const Text(
                                      "This note will be permenetally deleted from this List"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          deleteNotes(document.id);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.red),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Cancel"))
                                  ],
                                );
                              });
                        },
                        onTap: () {
                          var model = NotesModel(
                            id: document.id,
                            note: document['notes'] ?? "",
                            titleName: document['title'] ?? "",
                          );
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CreateNoteScreen(
                                    notesModel: model,
                                  )));
                        },
                        child: Container(
                            height: 100,

                            decoration: BoxDecoration(

                                borderRadius: BorderRadius.circular(5),
                                color: Colors.blue),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 1,
                                ),
                                Container(
                                  width: 202,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Title : ${document['title']}".trim(),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 18,fontWeight: FontWeight.w800),
                                      ),
                                      Text(
                                        "Notes : ${document['notes']}".trim(),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 13,fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                    );
                  }).toList());
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deleteNotes(String id) {
    return notes
        .doc(id)
        .delete()
        .then((value) => logger.i("Delete successfully"))
        .catchError((error) => logger.i("Filed $error"));
  }

  Future<void> logout() async {
    auth.signOut();
  }
}
