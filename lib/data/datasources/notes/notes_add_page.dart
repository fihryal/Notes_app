import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/data/datasources/notes/bloc/add_note/add_note_bloc.dart';
import 'package:myapp/data/datasources/notes/notes_page.dart';

class NotesAddPage extends StatefulWidget {
  const NotesAddPage({super.key});

  @override
  State<NotesAddPage> createState() => _NotesAddPageState();
}

class _NotesAddPageState extends State<NotesAddPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool isPin = false;
  XFile? image;

  void isPinHandler(bool value) {
    setState(() {
      isPin = value;
    });
  }

  void imagePickerHandler() async {
    final XFile? _image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      image = _image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new notes"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Content'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              child: const Text('Pick Image'),
              onPressed: imagePickerHandler,
            ),
          ),
          // image preview
          if (image != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Image.file(
                File(image!.path),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('Is Pin'),
                Switch(value: isPin, onChanged: isPinHandler)
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.all(16),
              child: BlocConsumer<AddNoteBloc, AddNoteState>(
                listener: (context, state) {
                  if (state is AddNoteSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Note added successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return const NotesPage();
                    }));
                  }

                  if (state is AddNoteFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                      onPressed: () {
                        context.read<AddNoteBloc>().add(AddNoteButtonPressed(
                            title: _titleController.text,
                            content: _contentController.text,
                            isPin: isPin));
                      },
                      child: const Text('Save'));
                },
              ))
        ],
      ),
    );
  }
}