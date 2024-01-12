class QuestionModel {
  final String id;
  final String title;

  QuestionModel({
    required this.id,
    required this.title,
  });

  QuestionModel.fromMap(Map<String, dynamic> item)
      : id = item["id"],
        title = item["title"];

  Map<String, Object> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }
}
