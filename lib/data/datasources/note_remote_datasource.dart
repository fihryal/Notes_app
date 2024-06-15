import 'dart:convert';
import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/data/datasources/auth_local_datasource.dart';
import 'package:myapp/data/datasources/config.dart';
import 'package:myapp/data/datasources/notes/bloc/all_notes/all_notes_bloc.dart';
import 'package:myapp/data/models/response/all_notes_response_model.dart';
import 'package:myapp/data/models/response/note_response_model.dart';
import 'package:http/http.dart' as http;


class NoteRemoteDatasource{

  Future<Either<String,NoteResponseModel>> addNote(
     String title,
     String content,
     bool isPin,
     XFile? image,
    ) async {
      final authData = await AuthLocalDatasource().getAuthData();
      final Map<String,String> headers = {
        'Content-Type':'application/json',
        'Authorization':'Bearer ${authData.accessToken}'
      };

      var request = http.MultipartRequest(
        'POST', 
        Uri.parse('${Config.baseUrl}/api/notes'));

      request.headers.addAll(headers);
      request.fields['title'] = title;
      request.fields['content'] = content;
      request.fields['is_pin'] = isPin ? '1' : '0';

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image', 
            image.path
            )
            );
      }

      http.StreamedResponse response = await request.send();

      final String body = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        return Right(NoteResponseModel.fromJson(body));
      } else {
        return Left(body);
      }
    }

    Future<Either<String,AllNotesResponseModel>> getAllNotes() async {
        final authData = await AuthLocalDatasource().getAuthData();
        final response = await http.get(
          Uri.parse('${Config.baseUrl}/api/notes'),
          headers: {
            'Content-Type':'application/json',
            'Authorization':'Bearer ${authData.accessToken}'
          
      });
      if(response.statusCode == 200){
        return Right(AllNotesResponseModel.fromJson(response.body));
      }else{
        return Left(response.body);
      }
    }

    Future<Either<String,String>> deleteNote(int id) async {
      final authData = await AuthLocalDatasource().getAuthData();
      final response = await http.delete(
        Uri.parse('${Config.baseUrl}/api/notes/$id'),
        headers: {
          'Content-Type':'application/json',
          'Authorization':'Bearer ${authData.accessToken}'
        
      });
      
      if(response.statusCode == 200){
        return const Right('Delete Success');
      }else{
        return Left(response.body);
      }
    }

    Future<Either<String,NoteResponseModel>> updateNote(
      int id,
      String title,
      String content,
      bool isPin,
      ) async {
        final authData = await AuthLocalDatasource().getAuthData();
        final response = await http.put(
          Uri.parse('${Config.baseUrl}/api/notes/$id'),

          headers: {
            'Content-Type':'application/json',
            'Authorization':'Bearer ${authData.accessToken}'
          },

          body: jsonEncode({
            'title':title,
            'content':content,
            'is_pin':isPin ? '1' : '0'
          }),

        );

        if(response.statusCode == 200){
            return Right(NoteResponseModel.fromJson(response.body));
          }else{
            return Left(response.body);
          }
        
        
      }
      }
    