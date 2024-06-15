import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/data/datasources/notes/bloc/all_notes/all_notes_bloc.dart';
import 'package:myapp/data/datasources/notes/bloc/delete_bloc/delete_note_bloc.dart';
import 'package:myapp/data/datasources/notes/detail_page.dart';
import 'package:myapp/data/datasources/notes/notes_add_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    context.read<AllNotesBloc>().add(GetAllNotes());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        centerTitle: true,
      ),
      body: BlocBuilder<AllNotesBloc, AllNotesState>(
        builder: (context, state) {
          if (state is AllNotesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is AllNotesFailed) {
            return const Center(
              child: Text('Failed to load Notes'),
            );
          }
          if (state is AllNotesSuccess) {
            if (state.data.data!.isEmpty) {
              return const Center(
                child: Text('No Notes'),
              );
            }
            return ListView.builder(
              itemCount: state.data.data!.length,
              itemBuilder: (context, index) {
                final note = state.data.data![index];
                return ListTile(
                  title: Text(note.title ?? 'Untitled'),
                  subtitle: Text(
                    note.content!.length < 20
                        ? note.content!
                        : '${note.content!.substring(0, 20)}...',
                  ),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BlocConsumer<DeleteNoteBloc, DeleteNoteState>(
                          listener: (context, state) {
                            if(state is DeleteNoteSuccess){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Note Delete Successfully'),
                                  backgroundColor: Colors.green,
                                  )
                              );
                              context.read<AllNotesBloc>().add(GetAllNotes());
                            }
                            if(state is DeleteNoteFailed){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.message),
                                  backgroundColor: Colors.red,
                                  )
                              );
                            }
                          },
                          builder: (context, state) {
                            return IconButton(
                              icon: Icon(Icons.delete_forever),
                              onPressed: () {
                                context
                                    .read<DeleteNoteBloc>()
                                    .add(DeleteNoteButtonPressed(id: note.id));
                              },
                            );
                          },
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                    return DetailPage(note: note); // Fixed incorrect class name
                                }
                              ),
                            );
                          },
                          child: const Icon(Icons.arrow_forward_ios),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    // Handle tap event, e.g., navigate to a detail page
                  },
                );
              },
            );
          }
          return const Center(
              child: Text(
                  'Unexpected State')); // Default state if no conditions match
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const NotesAddPage(), // Fixed incorrect class name
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
