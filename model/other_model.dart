class OtherModel {
  late bool success;
  late String message;

  OtherModel({required this.success, required this.message});

  OtherModel.fromJson(Map<String, dynamic> json) {
    success = json["success"];
    message = json["message"];
  }
}
