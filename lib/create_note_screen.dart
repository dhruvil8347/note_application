import 'package:cloud_firestore/cloud_firestore.dart';
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


  @override
  void initState() {
    super.initState();
    if(widget.notesModel != null){
      titleController.text = widget.notesModel!.titleName;
      notesController.text = widget.notesModel!.note;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Note"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            AppTextfiled(
              obscureText: false,
              controller: titleController,
              text: "Title",
            ),

            AppTextfiled(
              obscureText: false,
              text: "Note",
              controller: notesController,
              maxLine: 6,
            ),

            SizedBox(
              height: 20,
            ),

            ElevatedButton(
                onLongPress: (){
                  print("null");
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(350, 50)),

                onPressed: ()  {
                 /* if(widget.notesModel != null){

                  }*/

                  addNote();
                  clearText();

                },
                child:  Text("SAVE")),
          ],
        ),
      ),

    );
  }


  Future<void> addNote() {
    return notes.add({
      "title": titleController.text.trim(),
      "notes": notesController.text.trim(),
      
    })
        .then((value) => logger.d("notes add sucessfully"))
        .catchError((error) => logger.i("Failed $error"));
  }
  


  clearText(){
    titleController.clear();
    notesController.clear();
  }

}
