import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/favorite/presenter/cubit/favorite_cubit.dart';
import 'package:todo_app/features/todo_list/presenter/bloc/todo_list_bloc.dart';
import 'package:todo_app/router/router.dart';
import 'core/hive/hive.dart' as hive;
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await hive.initHive();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: ((context) => di.sl<TodoListBloc>())),
          BlocProvider(create: ((context) => FavoriteCubit())),
        ],
        child: MaterialApp.router(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routerConfig: router,
        ));
  }
}
