import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';

class NotesProvider with ChangeNotifier {
  final List<Note> _notes = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Note? _lastDeletedNote;

  List<Note> get notes => [..._notes];

  // 🔁 Fetch notes in real-time
  void fetchNotesRealtime() {
    _firestore
        .collection('notes')
        .orderBy('lastEdited', descending: true)
        .snapshots()
        .listen((snapshot) {
      _notes.clear();
      for (var doc in snapshot.docs) {
        _notes.add(Note.fromFirestore(doc));
      }
      notifyListeners();
    });
  }

  // ➕ Add new note to Firestore
  Future<void> addNote(String title, String content) async {
    final newNote = Note(
      id: const Uuid().v4(),
      title: title,
      content: content,
      color: _generateRandomColor(),
      lastEdited: DateTime.now(),
    );

    await _firestore.collection('notes').doc(newNote.id).set(newNote.toMap());
  }

  // ✏️ Update existing note
  Future<void> updateNote(String id, String title, String content) async {
    final updatedData = {
      'title': title,
      'content': content,
      'lastEdited': Timestamp.fromDate(DateTime.now()),
    };

    await _firestore.collection('notes').doc(id).update(updatedData);
  }

  // ❌ Delete note & store last deleted
  Future<void> deleteNote(String id) async {
    Note? note;
    try {
      note = _notes.firstWhere((note) => note.id == id);
    } catch (_) {
      note = null;
    }

    if (note != null) {
      _lastDeletedNote = note;
      await _firestore.collection('notes').doc(id).delete();
    }
  }

  // ♻️ Restore last deleted note
  Future<void> restoreDeletedNote(Note note) async {
    final restoredNote = Note(
      id: note.id,
      title: note.title,
      content: note.content,
      color: note.color,
      lastEdited: DateTime.now(),
    );

    await _firestore
        .collection('notes')
        .doc(restoredNote.id)
        .set(restoredNote.toMap());
  }

  // 🔍 Search notes by title or content
  List<Note> searchNotes(String query) {
    return _notes
        .where((note) =>
            note.title.toLowerCase().contains(query.toLowerCase()) ||
            note.content.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // 🎨 Generate random note color
  Color _generateRandomColor() {
    final colors = [
      Colors.amber.shade100,
      Colors.blue.shade100,
      Colors.green.shade100,
      Colors.pink.shade100,
      Colors.purple.shade100,
      Colors.teal.shade100,
    ];
    colors.shuffle();
    return colors.first;
  }

  // 📄 Get note by ID (optional)
  Note? getNoteById(String id) {
    try {
      return _notes.firstWhere((note) => note.id == id);
    } catch (_) {
      return null;
    }
  }
}
