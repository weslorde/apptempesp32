import 'package:apptempesp32/bloc/app_state.dart';
import 'package:apptempesp32/bloc/bloc_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//typedef AppBlocRandomUrlPicker = String Function(Iterable<String> allUrls);

/*extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(
        math.Random().nextInt(length),
      );
}
*/

class AppBloc extends Bloc<AppEvent, AppState> {
  //String _pickRandomUrl(Iterable<String> allUrls) => allUrls.getRandomElement();

/* 
// Creat Singleton
  static final PageIndex _shared = PageIndex._sharedInstance();
  PageIndex._sharedInstance();
  factory PageIndex({Function(int)? attPageState}) {
    */

  AppBloc(
      //required Iterable<String> urls,
      //Duration? waitBeforeLoading,
      //AppBlocRandomUrlPicker? urlPicker,
      )
      : super(
          const AppState.empty(),
        ) {
    on<LoadNextUrlEvent>((event, emit) async {
      emit(
        const AppState(
          isLoading: true,
          data: 'OnStartLoad',
          error: null,
        ),
      );
      //final url = (urlPicker ?? _pickRandomUrl)(urls);
      try {
        await Future.delayed(const Duration(seconds: 5));
        emit(
          const AppState(
            isLoading: false,
            data: 'After Load 5 seg',
            error: null,
          ),
        );
      } catch (e) {
        emit(
          AppState(
            isLoading: false,
            data: 'ON error',
            error: e,
          ),
        );
      }
    });
  }
}
