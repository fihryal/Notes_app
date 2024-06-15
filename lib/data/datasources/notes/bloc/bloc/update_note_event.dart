part of 'update_note_bloc.dart';

@immutable
sealed class UpdateNoteEvent {}

class UpdateNote extends UpdateNoteEvent {
  final int id;
  final String title;
  final String content;
  final bool isPin;
  UpdateNote({
    required this.id,
    required this.title,
    required this.content,
    required this.isPin,
  });
}
  
