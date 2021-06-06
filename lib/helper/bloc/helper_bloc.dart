import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flexible/helper/first_time_servise.dart';

part 'helper_event.dart';
part 'helper_state.dart';

class HelperBloc extends Bloc<HelperEvent, HelperState> {
  HelperBloc() : super(HelperInitState());

  FirstTimeService firstTimeService = FirstTimeService();

  @override
  Stream<HelperState> mapEventToState(
    HelperEvent event,
  ) async* {
    if (event is HelperAppStart) {
      bool isShowedBefore = await firstTimeService.isAppRunsFirst;

      if (isShowedBefore) {
        yield HelperShowed();
      } else {
        yield ShowHelper();
      }
    }

    if (event is HelperSeened) {
      await firstTimeService.markAsRunned();
      yield HelperShowed();
    }
  }
}
