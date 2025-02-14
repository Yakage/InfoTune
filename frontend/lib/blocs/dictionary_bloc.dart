import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:infotune/blocs/dictionary_event.dart';
import 'package:infotune/blocs/dictionary_state.dart';
import 'package:infotune/services/api/global_repository_impl.dart';

class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState> {
  final GlobalRepositoryImpl globalRepository = GlobalRepositoryImpl();
  DictionaryBloc() : super(DictionaryLoadingState()) {
    on<DictionaryLoadingEvent>(dictionaryLoadingEvent);
    on<FetchDefiniionEvent>(fetchDefiniionEvent);
  }

  FutureOr<void> dictionaryLoadingEvent(
      DictionaryLoadingEvent event, Emitter<DictionaryState> emit) async {
    emit(DictionaryLoadedSuccessState(definition: ''));
  }

  FutureOr<void> fetchDefiniionEvent(
      FetchDefiniionEvent event, Emitter<DictionaryState> emit) async {
    try {
      final String data = await globalRepository.fetchDefinition(event.word);
      emit(DictionaryLoadedSuccessState(definition: data));
    } catch (e) {
      emit(DictionaryErrorState(message: e.toString()));
    }
  }
}
