

import 'package:cloud_firestore/cloud_firestore.dart';

class NotesModel {
  String id;
  String titleName;
  String note;
  DateTime? createAt;



  NotesModel({
    this.id = "" ,
    this.titleName = "",
    this.note = "",
    this.createAt,



  });

  factory NotesModel.formjson(Map<String, dynamic>json){
    return NotesModel (
      id: json['id'] ??  "",
      titleName: json['title'] ?? "",
      note: json['notes'] ?? "",
      createAt: json['createAt'] ?? Timestamp.now(),


    );


  }

  Map<String,dynamic>tojson() => {
    'id' : id,
    'title' : titleName,
    'notes' : note,
    'createAt' : createAt,


  };



}