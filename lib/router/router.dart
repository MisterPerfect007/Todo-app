import 'package:go_router/go_router.dart';
import 'package:todo_app/features/todo_list/presenter/page/todo_list_page.dart';

import '../features/favorite/presenter/page/favorite_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => TodoListPage(),
    ),
    GoRoute(
      path: '/favorite',
      builder: (context, state) => FavoritePage(),
    ),
  ],
);
