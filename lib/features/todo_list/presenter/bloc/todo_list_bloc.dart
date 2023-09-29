import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/errors/failures.dart';
import 'package:todo_app/features/todo_list/data/data_source/todo_list_remote_data_source.dart';

import '../../domain/entity/todo.dart';

part 'todo_list_event.dart';
part 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  final TodoListRemoteDataSource todoDataSource;
  TodoListBloc(this.todoDataSource) : super(TodoListInitial()) {
    on<TodoListEvent>((event, emit) async {
      if (event is GetTodoList) {
        emit(TodoListLoading());
        final result = await todoDataSource.getRemoteTodos();
        result.fold(
          (failure) => emit(TodoListFailed(failure)),
          (todos) => emit(TodoListLoaded(todos)),
        );
      }
    });
  }
}



