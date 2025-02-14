abstract class  DictionaryEvent {}
class DictionaryLoadingEvent extends DictionaryEvent {}

class FetchDefiniionEvent extends DictionaryEvent {
  final String word;

  FetchDefiniionEvent({required this.word});
}