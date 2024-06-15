import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myapp/data/datasources/note_remote_datasource.dart';
import 'package:myapp/data/models/response/note_response_model.dart';

part 'update_note_event.dart';
part 'update_note_state.dart';

class UpdateNoteBloc extends Bloc<UpdateNoteEvent, UpdateNoteState> {
  final NoteRemoteDatasource remote;
  UpdateNoteBloc(
    this.remote
  ) : super(UpdateNoteInitial()) {
    on<UpdateNote>((event, emit) async {
      emit(UpdateNoteLoading());
      final result = await remote.updateNote(
        event.id,
        event.title,
        event.content,
        event.isPin
        );

      result.fold(
        (message) => emit(UpdateNoteFailure(message: message)), 
        (data) => emit(UpdateNoteSuccess(data: data))
      );
    });
  }
}
