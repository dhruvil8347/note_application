import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:note_app/model/notesmodel.dart';
import 'package:note_app/widget/textfiled.dart';
import 'main.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({Key? key, this.notesModel}) : super(key: key);
  final NotesModel? notesModel;


  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {

  TextEditingController titleController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  final CollectionReference notes = FirebaseFirestore.instance.collection("notes");
  final auth = FirebaseAuth.instance;
  String uid = "";
  String time = "";
  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    uid = auth.currentUser?.uid ?? '';
    super.initState();
    if(widget.notesModel != null){
      titleController.text = widget.notesModel!.titleName;
      notesController.text = widget.notesModel!.note;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color(0xFF1b1c17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF242922),
        title: const Text("Create Note"),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                AppTextfiled(
                  obscureText: false,
                  controller: titleController,
                  text: "Title",
                  maxLine: 1,
                  validation: (value) {
                    if(value == null || value.trim().isEmpty)
                    {
                      return "please insert title";
                    }
                    return null;

                  },
                ),

                AppTextfiled(
                  validation: (value){
                    if(value == null || value.trim().isEmpty)
                    {
                      return "please insert notes";
                    }
                    return null;
                  },
                  obscureText: false,
                  text: "Note",
                  controller: notesController,
                  maxLine: 5
                  ,
                ),

                const SizedBox(
                  height: 20,
                ),

                ElevatedButton(
                    onLongPress: (){
                      if (kDebugMode) {
                        print("null");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(350, 50)),
                    onPressed: ()  {
                      if(formkey.currentState!.validate()){
                        if(widget.notesModel != null){
                          updateNote(notesModel: NotesModel(
                            id: uid,
                            titleName: titleController.text.trim(),
                            note: notesController.text.trim()

                          )).then((value) => Navigator.of(context).pop());
                        }else{
                          addNote(notesModel: NotesModel(
                            id: uid,
                            titleName: titleController.text.trim(),
                            note: notesController.text.trim(),
                            createAt: DateTime.now(),
                          )).then((value) => Navigator.of(context).pop());
                        }
                      }

                    },
                    child:  const Text("SAVE")),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> addNote({required NotesModel notesModel}) {
    return notes
        .add(notesModel.tojson())
        .then((value) => logger.d("notes add sucessfully"))
        .catchError((error) => logger.i("Failed $error"));
  }


  Future<void> updateNote({required NotesModel notesModel}){

   logger.e(uid);
    return notes
        .doc(widget.notesModel!.id)
        .update(notesModel.tojson())
        .then((value) => logger.d("Notes has been updated"))
        .catchError((error) => logger.e("Filed $error"));

  }



  clearText(){
    titleController.clear();
    notesController.clear();
  }

}
