import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/hive/hive.dart';
import 'package:todo_app/core/hive/todo.dart';
import 'package:todo_app/features/todo_list/domain/entity/todo.dart';


class FavoriteCubit extends Cubit<List<TodoEntity>> {
  FavoriteCubit() : super([]);

  void initStateFromBox() async {
    final todoBox = await openBox<Todo>(todoBoxName);
    emit(todoBox.values.map((e) => hiveTodoToEntity(e)).toList());
  }

  void toogleFavorite(TodoEntity todo) async {
    final todoBox = await openBox<Todo>(todoBoxName);

    Todo adaptedTodo = entityToHiveTodo(todo);
    
    List<int> todosIds = todoBox.values.map((e) => e.id).toList();
    // todoBox.clear();
    if (!todosIds.contains(adaptedTodo.id)) {
      await todoBox.put("key_${adaptedTodo.id}", adaptedTodo);
      emit(todoBox.values.map((e) => hiveTodoToEntity(e)).toList());
    } else {
      await todoBox.delete("key_${adaptedTodo.id}");
      emit(todoBox.values.map((e) => hiveTodoToEntity(e)).toList());
    }
  }
}

TodoEntity hiveTodoToEntity(Todo todo) => TodoEntity(
    id: todo.id,
    userId: todo.userId,
    title: todo.title,
    completed: todo.completed);

Todo entityToHiveTodo(TodoEntity todo) => Todo(
    id: todo.id,
    userId: todo.userId,
    title: todo.title,
    completed: todo.completed);
