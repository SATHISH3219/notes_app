import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  String title;
  String content;
  Color color;
  DateTime lastEdited;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.lastEdited,
  });

  // ✅ Convert Note to Firestore format
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color.value,
      'lastEdited': Timestamp.fromDate(lastEdited),
    };
  }

  // ✅ Create Note from Firestore document
  factory Note.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Note(
      id: data['id'],
      title: data['title'],
      content: data['content'],
      color: Color(data['color']),
      lastEdited: (data['lastEdited'] as Timestamp).toDate(),
    );
  }
}
