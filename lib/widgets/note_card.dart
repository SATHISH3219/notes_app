import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final IconButton deleteButton; // ✅ Add this parameter

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.deleteButton, // ✅ Include in constructor
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: note.color,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          note.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          note.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${note.lastEdited.hour}:${note.lastEdited.minute.toString().padLeft(2, '0')}",
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(width: 8),
            deleteButton, // ✅ Delete button rendered here
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
