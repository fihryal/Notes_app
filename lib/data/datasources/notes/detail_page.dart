import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/data/datasources/config.dart';
import 'package:myapp/data/datasources/notes/edit_page.dart';
import 'package:myapp/data/models/response/note_response_model.dart';

class DetailPage extends StatelessWidget {
  final Note note;
  const DetailPage({
    super.key,
    required this.note
    });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
// Suggested code may be subject to a license. Learn more: ~LicenseLog:4080139866.
      appBar: AppBar(
        title: Text(note.title),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.content,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          if(note.image != null)
            Image.network(
              '${Config.baseUrl}/images/${note.image}',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16,),
            Center(
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => EditPage(note: note)
                    )
                    );
                }, 
                child: const Text('Edit')
                ),
            )
        ],
      ),
    )
    );
  }
}