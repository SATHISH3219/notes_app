import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../widgets/note_card.dart';
import 'note_editor_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    Provider.of<NotesProvider>(context, listen: false).fetchNotesRealtime();
    _controller = BottomSheet.createAnimationController(this);
    _controller.duration = const Duration(milliseconds: 300);
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    final notes = notesProvider.notes;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Smart Notes",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        elevation: 8,
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NoteSearchDelegate(notesProvider),
              );
            },
          ),
        ],
      ),
      body: notes.isEmpty
          ? const Center(
              child: Text(
                "📝 No notes yet!\nTap + to start writing.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              itemCount: notes.length,
              itemBuilder: (ctx, index) {
                final note = notes[index];
                return NoteCard(
                  note: note,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => NoteEditorScreen(note: note),
                      ),
                    );
                  },
                  deleteButton: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      notesProvider.deleteNote(note.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("Note deleted"),
                          action: SnackBarAction(
                            label: "Undo",
                            onPressed: () {
                              notesProvider.restoreDeletedNote(note);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color.fromARGB(255, 194, 176, 245),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => const NoteEditorScreen()),
          );
        },
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}

// 🔍 Custom Search Experience
class NoteSearchDelegate extends SearchDelegate {
  final NotesProvider provider;

  NoteSearchDelegate(this.provider);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final base = Theme.of(context);
    return base.copyWith(
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
      ),
      textTheme: TextTheme(
        titleLarge: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.deepPurpleAccent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        )
      ];

  @override
  Widget? buildLeading(BuildContext context) =>
      IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) {
    final results = provider.searchNotes(query);
    if (results.isEmpty) {
      return const Center(child: Text("No matching notes found."));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (ctx, index) {
        final note = results[index];
        return NoteCard(
          note: note,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (ctx) => NoteEditorScreen(note: note)),
            );
          },
          deleteButton: IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () {
              provider.deleteNote(note.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Note deleted"),
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () {
                      provider.restoreDeletedNote(note);
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}
