import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/features/todo_list/presenter/page/todo_list_page.dart';

import '../../../todo_list/domain/entity/todo.dart';
import '../cubit/favorite_cubit.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => context.pop(true), icon: Icon(Icons.arrow_back)),
        title: Text('Favoris'),
      ),
      body: Container(
        child: BlocBuilder<FavoriteCubit, List<TodoEntity>>(
            builder: (context, state) {
          if (state.isNotEmpty) {
            return ListView.builder(
                itemCount: state.length,
                itemBuilder: (context, index) {
                  return TodoWidget(todo: state[index]);
                });
          } else {
            return Center(
              child: Text('No todo added'),
            );
          }
        }),
      ),
    );
  }
}
