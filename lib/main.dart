import 'package:flutter/material.dart';
import 'package:myapp/data/datasources/auth_local_datasource.dart';
import 'package:myapp/data/datasources/auth_remote_datasource.dart';
import 'package:myapp/data/datasources/note_remote_datasource.dart';
import 'package:myapp/data/datasources/notes/bloc/add_note/add_note_bloc.dart';
import 'package:myapp/data/datasources/notes/bloc/all_notes/all_notes_bloc.dart';
import 'package:myapp/data/datasources/notes/bloc/bloc/update_note_bloc.dart';
import 'package:myapp/data/datasources/notes/bloc/delete_bloc/delete_note_bloc.dart';
import 'package:myapp/pages/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/presentation/auth/bloc/login/login_bloc.dart';
import 'package:myapp/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:myapp/presentation/auth/bloc/register/register_bloc.dart';
import 'package:myapp/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
   @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => RegisterBloc(AuthRemoteDatasource()),
          ),
          BlocProvider(
            create: (context) => LoginBloc(AuthRemoteDatasource()),
          ),
          BlocProvider(
            create: (context) => LogoutBloc(AuthRemoteDatasource()),
          ),
          BlocProvider(
            create: (context) => AddNoteBloc(NoteRemoteDatasource()),
          ),
          BlocProvider(
            create: (context) => AllNotesBloc(NoteRemoteDatasource()),
          ),
          BlocProvider(
            create: (context) => DeleteNoteBloc(NoteRemoteDatasource()),
          ),
          BlocProvider(
            create: (context) => UpdateNoteBloc(NoteRemoteDatasource()),
          ),
        ],
        child: MaterialApp(
          home: FutureBuilder<bool>(
            future: AuthLocalDatasource().isLogin(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return snapshot.data! ? const HomePage() : const LoginPage();
              }
              return const Scaffold(
                body: Center(
                  child: Text('Error'),
                ),
              );
            },
          ),
        ));
  }
}
