abstract class DictionaryState {}

final class DictionaryLoadingState extends DictionaryState {}

final class DictionaryLoadedSuccessState extends DictionaryState {
  final String definition;

  DictionaryLoadedSuccessState({required this.definition});
}

final class DictionaryErrorState extends DictionaryState {
  final String message;

  DictionaryErrorState({required this.message});
}