class NotesModel {
  String id;
  String titleName;
  String note;

  NotesModel({
    this.id = "" ,
    this.titleName = "",
    this.note = "",
  });

  factory NotesModel.formjson(Map<String, dynamic>json){
    return NotesModel (
      id: json['id'] ??  "",
      titleName: json['title'] ?? "",
      note: json['notes'] ?? "",
    );


  }

  Map<String,dynamic>tojson() => {
    'id' : id,
    'title' : titleName,
    'notes' : note,
  };



}