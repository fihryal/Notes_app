import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/data/datasources/notes/bloc/bloc/update_note_bloc.dart';
import 'package:myapp/data/datasources/notes/notes_page.dart';
import 'package:myapp/data/models/response/note_response_model.dart';

class EditPage extends StatefulWidget {
  final Note note;
  const EditPage({super.key, required this.note});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool isPin = false;

  void _onPinhandler(bool value) {
    setState(() {
      isPin = value;
    });
  }

  @override
  void initState() {
    _titleController.text = widget.note.title!;
    _contentController.text = widget.note.content!;
    isPin = widget.note.isPin! == '1' ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Page'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Content',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('Is Pin'),
                Switch(value: isPin, onChanged: _onPinhandler)
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
              padding: const EdgeInsets.all(16),
              child: BlocConsumer<UpdateNoteBloc, UpdateNoteState>(
                listener: (context, state) {
                  if (state is UpdateNoteSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Update Success'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(builder: (context) => const NotesPage()));
                  } 

                  if (state is UpdateNoteFailure){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is UpdateNoteLoading){
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    onPressed: () {
                      context.read<UpdateNoteBloc>().add(
                            UpdateNote(
                                id: widget.note.id!,
                                title: _titleController.text,
                                content: _contentController.text,
                                isPin: isPin),
                          );
                    },
                    child: const Text('Save'),
                  );
                },
              ))
        ],
      ),
    );
  }
}
