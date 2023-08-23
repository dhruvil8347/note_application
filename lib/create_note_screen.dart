import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      appBar: AppBar(
        title: Text("Create Note"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: formkey,
          child: Column(
            children: [
              AppTextfiled(
                obscureText: false,
                controller: titleController,
                text: "Title",
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
                    if(formkey.currentState!.validate()){
                      if(widget.notesModel != null){
                        updateNote(notesModel: NotesModel(
                          titleName: titleController.text,
                          note: notesController.text,
                        )).then((value) => Navigator.of(context).pop());
                      }else{
                        addNote().then((value) => Navigator.of(context).pop());
                      }
                    }



                    clearText();

                  },
                  child:  Text("SAVE")),
            ],
          ),
        ),
      ),

    );
  }


  Future<void> addNote() {
    return notes.add({
      "title": titleController.text.trim(),
      "notes": notesController.text.trim(),
      'id' : uid,
      
    })
        .then((value) => logger.d("notes add sucessfully"))
        .catchError((error) => logger.i("Failed $error"));
  }


  Future<void> updateNote({required NotesModel notesModel}){
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
