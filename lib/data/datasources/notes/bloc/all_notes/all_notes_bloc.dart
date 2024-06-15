import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myapp/data/datasources/note_remote_datasource.dart';
import 'package:myapp/data/models/response/all_notes_response_model.dart';

part 'all_notes_event.dart';
part 'all_notes_state.dart';

class AllNotesBloc extends Bloc<AllNotesEvent, AllNotesState> {
    final NoteRemoteDatasource remote;
  AllNotesBloc(
    this.remote
  ) : super(AllNotesInitial()) {
    on<AllNotesEvent>((event, emit) async {
      emit(AllNotesLoading());
      final result = await remote.getAllNotes();

      result.fold(
        (message) => emit(
          AllNotesFailed(message: message)
          ), 
          (data) => emit(
            AllNotesSuccess(data: data)
          )
      );
    });
  }
}
