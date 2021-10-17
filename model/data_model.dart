class Data {
  late int personId;
  late String name;
  late int age;
  Data({required this.personId, required this.name, required this.age});
  Data.fromJson(Map<String, dynamic> json) {
    // a modern parser should understand dynamic can be int
    // so
    personId = int.parse(json["personId"]);
    name = json["name"];
    age = int.parse(json["age"]);
  }
}
