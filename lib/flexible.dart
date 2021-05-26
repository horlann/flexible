import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/board_page.dart';
import 'package:flexible/board/repository/sqflire_tasks_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlexibleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => SqfliteTasksRepo(),
      child: BlocProvider(
        create: (context) => DailytasksBloc(
            tasksRepo: RepositoryProvider.of<SqfliteTasksRepo>(context)),
        child: MaterialApp(home: BoardPage()),
      ),
    );
  }
}
