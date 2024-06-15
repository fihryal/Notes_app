import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myapp/data/datasources/auth_local_datasource.dart';
import 'package:myapp/data/datasources/auth_remote_datasource.dart';


part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthRemoteDatasource remote;
  LogoutBloc(this.remote) : super(LogoutInitial()) {
    on<LogoutButtonPressed>((event, emit) async {
      emit(LogoutLoading());
      final response = await remote.logout();
      response.fold((error) => emit(LogoutFailed(message: error)), (success) {
        AuthLocalDatasource().removeAuthData();
        emit(LogoutSuccess());
      });
    });
  }
}
