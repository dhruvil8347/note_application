import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:note_app/create_note_screen.dart';
import 'package:note_app/login.dart';
import 'model/notesmodel.dart';



void main() {
  firebase();
  runApp(const MyApp());
}

firebase ()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

  final CollectionReference notes = FirebaseFirestore.instance.collection("notes");



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  CreateNoteScreen(),));
        },child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          TextButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
          }, child: const Text(
            "Login",style: TextStyle(color: Colors.white),
          ))
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('notes')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView(

                    ///docs[index].id
                      children: snapshot.data!.docs.map((document) {
                        return ListTile(
                          title: InkWell(
                            onLongPress: (){
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      title: Text("Delete ?",style: TextStyle(color: Colors.red)),
                                      content: Text("This note will be permenetally deleted from this List"),

                                      actions: [

                                        TextButton(onPressed: (){
                                          deleteNotes(document.id);
                                          Navigator.of(context).pop();
                                        }, child: Text("Delete",style: TextStyle(
                                          color: Colors.red),)),

                                        TextButton(onPressed: (){
                                          Navigator.of(context).pop();
                                        }, child: Text("Cancel"))
                                      ],
                                    );
                                  });
                            },
                            onTap: (){
                              var model = NotesModel(
                                id: document.id,
                                note: document['notes'] ?? "",
                                titleName: document['title'] ?? "",
                              );   Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                           CreateNoteScreen(notesModel: model,))

                              );
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
                                    SizedBox(
                                      width: 202,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Title : ${document['title']}",
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(color: Colors.white,fontSize: 18),
                                          ),

                                          Text(
                                            "Notes : ${document['notes']}",
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(color: Colors.white,fontSize: 16),
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

}
