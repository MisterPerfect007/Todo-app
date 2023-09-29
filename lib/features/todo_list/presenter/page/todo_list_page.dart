import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/features/favorite/presenter/cubit/favorite_cubit.dart';
import 'package:todo_app/features/todo_list/domain/entity/todo.dart';
import 'package:todo_app/features/todo_list/presenter/bloc/todo_list_bloc.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final todoListBloc = context.read<TodoListBloc>();
    todoListBloc.add(GetTodoList());
    context.read<FavoriteCubit>().initStateFromBox();
  }

  List<TodoEntity> createdTodos = [];

  void addNewTodo(String title) {
    int id = createdTodos.length + 1000;
    setState(() {
      createdTodos
          .add(TodoEntity(id: id, userId: 1, title: title, completed: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Ajoutez un Todo',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                hintText: 'Ajouter un titre'),
                            autofocus: true,
                            controller: titleController,
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return 'Ajoutez un titre';
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              addNewTodo(titleController.text);
                              titleController.clear();
                              context.pop(true);
                            }
                          },
                          child: Text('Ajouter'))
                    ],
                  ));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () {
                context.push('/favorite');
              },
              child: Text('Voir favoris'))
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (createdTodos.isEmpty)
                  Container()
                else
                  Center(
                    child: Column(
                      children: [
                        Text('Todo ajoutés'),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List<Widget>.generate(
                                createdTodos.length,
                                (index) =>
                                    TodoWidget(todo: createdTodos[index])),
                          ),
                        ),
                        Divider()
                      ],
                    ),
                  ),
                Center(
                  child: BlocBuilder<TodoListBloc, TodoListState>(
                      builder: (context, state) {
                    if (state is TodoListInitial || state is TodoListLoading) {
                      return const CircularProgressIndicator();
                    }
                    if (state is TodoListLoaded) {
                      final todos = state.todos;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List<Widget>.generate(todos.length,
                            (index) => TodoWidget(todo: todos[index])),
                      );
                    }
                    return const Text('Unexpected Error');
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TodoWidget extends StatefulWidget {
  final TodoEntity todo;
  const TodoWidget({
    super.key,
    required this.todo,
  });

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  bool isTodoCompleted = false;
  @override
  void initState() {
    super.initState();
    isTodoCompleted = widget.todo.completed;
  }

  void setTodoCompleted() {
    setState(() {
      isTodoCompleted = !isTodoCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setTodoCompleted();
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: isTodoCompleted
                      ? Icon(Icons.check, color: Colors.green)
                      : Icon(Icons.circle_outlined),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.todo.title,
                    style: isTodoCompleted
                        ? const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough)
                        : TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 10),
                BlocBuilder<FavoriteCubit, List<TodoEntity>>(
                    builder: (context, state) {
                  // print("=======================fdgjsdfljgl;");
                  bool isFavorite =
                      state.map((e) => e.id).contains(widget.todo.id);
                  print(isFavorite);
                  return InkWell(
                      onTap: () {
                        context
                            .read<FavoriteCubit>()
                            .toogleFavorite(widget.todo);
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: isFavorite
                            ? Icon(Icons.star, color: Colors.amber)
                            : Icon(Icons.star_outline),
                      ));
                })
              ],
            ),
          ),
        ),
        Divider()
      ],
    );
  }
}
