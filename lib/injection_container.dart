import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'features/todo_list/data/data_source/todo_list_remote_data_source.dart';
import 'features/todo_list/presenter/bloc/todo_list_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => http.Client());

  sl.registerLazySingleton(() => TodoListRemoteDataSource(sl()));

  sl.registerLazySingleton(() => TodoListBloc(sl()));

}
