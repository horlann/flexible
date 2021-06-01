import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/board_page.dart';
import 'package:flexible/board/repository/sqflire_tasks_repo.dart';
import 'package:flexible/board/repository/sqflite_day_options_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlexibleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => SqfliteTasksRepo(),
        ),
        RepositoryProvider(
          create: (context) => SqfliteDayOptionsRepo(),
        )
      ],
      child: BlocProvider(
        create: (context) => DailytasksBloc(
            dayOptionsRepo:
                RepositoryProvider.of<SqfliteDayOptionsRepo>(context),
            tasksRepo: RepositoryProvider.of<SqfliteTasksRepo>(context)),
        child: MaterialApp(home: BoardPage()),
      ),
    );
  }
}
