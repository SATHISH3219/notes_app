import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;

  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _showPreview = false;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty && content.isEmpty) return;

    final provider = Provider.of<NotesProvider>(context, listen: false);
    if (widget.note == null) {
      provider.addNote(title, content);
    } else {
      provider.updateNote(widget.note!.id, title, content);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = const Color(0xFFF6F4FA);
    final accentColor = Colors.deepPurpleAccent;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 4,
        backgroundColor: accentColor,
        title: Text(
          widget.note == null ? 'Create Note' : 'Edit Note',
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(_showPreview ? Icons.edit : Icons.preview),
            onPressed: () => setState(() => _showPreview = !_showPreview),
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: _showPreview
            ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: MarkdownBody(
                  data: _contentController.text.isEmpty
                      ? '*Nothing to preview*'
                      : _contentController.text,
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                    p: GoogleFonts.poppins(fontSize: 16),
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Note title...',
                      hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                      border: InputBorder.none,
                    ),
                    style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurpleAccent.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _contentController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: GoogleFonts.poppins(fontSize: 16),
                        decoration: const InputDecoration(
                          hintText: 'Start typing your note...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
