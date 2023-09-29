part of 'todo_list_bloc.dart';

class TodoListState extends Equatable {
  const TodoListState();

  @override
  List<Object> get props => [];
}

class TodoListInitial extends TodoListState {}

class TodoListLoading extends TodoListState {}

class TodoListLoaded extends TodoListState {
  final List<TodoEntity> todos;

  const TodoListLoaded(this.todos);

  @override
  List<Object> get props => [todos];
}

class TodoListFailed extends TodoListState {
  final Failure failure;

  const TodoListFailed(this.failure);

  @override
  List<Object> get props => [failure];
}
