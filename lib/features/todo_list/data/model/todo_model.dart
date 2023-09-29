import 'dart:convert';

import 'package:todo_app/features/todo_list/domain/entity/todo.dart';

List<TodoModel> todoFromJson(String str) =>
    List<TodoModel>.from(json.decode(str).map((x) => TodoModel.fromJson(x)));

String todoToJson(List<TodoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TodoModel extends TodoEntity{
  const TodoModel({
    required id,
    required userId,
    required title,
    required completed
  }) : super(id: id, userId: userId, title: title, completed: completed);

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        completed: json["completed"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "completed": completed,
      };
}
