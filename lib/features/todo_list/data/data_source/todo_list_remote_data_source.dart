import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:todo_app/errors/failures.dart';
import 'package:todo_app/features/todo_list/data/model/todo_model.dart';

class TodoListRemoteDataSource {
  final Client client;
  const TodoListRemoteDataSource(this.client);

  Future<Either<Failure, List<TodoModel>>> getRemoteTodos() async {
    final Response response;
    try {
      response = await client
          .get(Uri.https('jsonplaceholder.typicode.com', '/todos'))
          .timeout(const Duration(seconds: 60));
    } catch (e) {
      return Left(NoConnectionFailure());
    }
    if (response.statusCode == 200) {
      final responseBody = response.body;
      return Right(todoFromJson(responseBody));
    } else {
      return Left(ServerFailure());
    }
  }
}
