import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:myapp/data/datasources/note_remote_datasource.dart';
import 'package:myapp/data/models/response/note_response_model.dart';

part 'add_note_event.dart';
part 'add_note_state.dart';

class AddNoteBloc extends Bloc<AddNoteEvent, AddNoteState> {
  final NoteRemoteDatasource remote;
  AddNoteBloc(
    this.remote
  ) : super(AddNoteInitial()) {
    on<AddNoteButtonPressed>((event, emit) async {
      emit(AddNoteLoading());
      final result = await remote.addNote(
        event.title, 
        event.content, 
        event.isPin, 
        event.image
        );

        result.fold(
          (ifLeft) => emit(
            AddNoteFailed(message: ifLeft)
            ), 
            (ifRight) => emit(
              AddNoteSuccess(data: ifRight)
            )
        );
    });
  }
}
