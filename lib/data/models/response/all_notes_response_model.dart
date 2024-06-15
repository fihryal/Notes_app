import 'dart:convert';

import 'package:myapp/data/models/response/note_response_model.dart';

class AllNotesResponseModel {
    final String? message;
    final List<Note>? data;

    AllNotesResponseModel({
        this.message,
        this.data,
    });

    factory AllNotesResponseModel.fromJson(String str) => AllNotesResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AllNotesResponseModel.fromMap(Map<String, dynamic> json) => AllNotesResponseModel(
        message: json["message"],
        data: json["data"] == null ? [] : List<Note>.from(json["data"]!.map((x) => Note.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    };
}

class Datum {
    final int? id;
    final String? title;
    final String? content;
    final String? image;
    final int? isPin;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Datum({
        this.id,
        this.title,
        this.content,
        this.image,
        this.isPin,
        this.createdAt,
        this.updatedAt,
    });

    factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        image: json["image"],
        isPin: json["is_pin"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "content": content,
        "image": image,
        "is_pin": isPin,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
