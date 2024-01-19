class NotesModel {
  final int? id;
  final int age;
  final String title;
  final String description;
  final String email;
  const NotesModel({
    this.id,
    required this.age,
    required this.title,
    required this.description,
    required this.email,
  });

  NotesModel.fromDb(Map<String, dynamic> map)
      : id = map["id"],
        age = map["age"],
        title = map["title"],
        description = map["description"],
        email = map["email"];
        
  Map<String, dynamic> toDb() {
    return {
      "id": id,
      "age": age,
      "title": title,
      "description": description,
      "email": email,
    };
  }
}
