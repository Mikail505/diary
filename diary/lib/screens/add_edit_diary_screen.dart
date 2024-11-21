import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/diary_provider.dart';

class AddEditDiaryScreen extends StatefulWidget {
  final String? id;
  final String? title;
  final String? content;

  const AddEditDiaryScreen({
    Key? key,
    this.id,
    this.title,
    this.content,
  }) : super(key: key);

  @override
  _AddEditDiaryScreenState createState() => _AddEditDiaryScreenState();
}

class _AddEditDiaryScreenState extends State<AddEditDiaryScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.title != null) _titleController.text = widget.title!;
    if (widget.content != null) _contentController.text = widget.content!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id == null ? 'Tambah Diary' : 'Edit Diary',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal[300], // AppBar berwarna teal
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Judul Diary TextField
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Judul',
                labelStyle:
                    TextStyle(color: Colors.teal[600]), // Label warna teal
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.teal[50], // Background input field
              ),
            ),
            const SizedBox(height: 30),
            // Isi Diary TextField
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Isi',
                labelStyle:
                    TextStyle(color: Colors.teal[600]), // Label warna teal
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.teal[50], // Background input field
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            // Tombol Simpan
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[300], // Tombol berwarna teal
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
              ),
              onPressed: () {
                final title = _titleController.text.trim();
                final content = _contentController.text.trim();
                if (title.isNotEmpty && content.isNotEmpty) {
                  if (widget.id == null) {
                    Provider.of<DiaryProvider>(context, listen: false).addDiary(
                      title,
                      content,
                      DateTime.now(),
                    );
                  } else {
                    Provider.of<DiaryProvider>(context, listen: false)
                        .editDiary(
                      widget.id!,
                      title,
                      content,
                      DateTime.now(),
                    );
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Simpan',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
