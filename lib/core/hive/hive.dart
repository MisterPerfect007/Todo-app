import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/core/hive/todo.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
}

Future<Box<E>> openBox<E>(
  String name,
) async {
  return await Hive.openBox(name);
}

const String todoBoxName = 'todoBox';
