class CustomTask {
  String title;
  String moment;
  String method;
  String proof;

  CustomTask.fromData(Map<String, dynamic> data) {
    title = data["title"];
    moment = data["moment"];
    method = data["method"];
    proof = data["proof"];
  }

  // Default constructor for custom tasks
  CustomTask() {
    title = "";
    moment = "";
    method = "";
    proof = "";
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'moment': moment, 'method': method, 'proof': proof};
  }

  @override
  String toString() {
    return "{'title': ${title}, 'moment': ${moment}, 'method': ${method}, 'proof': ${proof}}";
  }
}
