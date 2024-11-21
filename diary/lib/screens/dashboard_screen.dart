import 'package:diary/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/diary_provider.dart';
import 'add_edit_diary_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String username;

  const DashboardScreen({Key? key, required this.username}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late String username;

  @override
  void initState() {
    super.initState();
    username = widget.username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary App'),
        backgroundColor: Colors.teal[300],
      ),
      body: Container(
        color: Colors.teal[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Hai $username, apakah kamu siap bercerita hari ini?",
                style: GoogleFonts.dancingScript(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Consumer<DiaryProvider>(
                builder: (context, diaryProvider, _) {
                  final diaries = diaryProvider.diaries;
                  if (diaries.isEmpty) {
                    return const Center(
                      child: Text('Belum ada diary. Tambahkan diary baru!'),
                    );
                  }
                  return ListView.builder(
                    itemCount: diaries.length,
                    itemBuilder: (ctx, i) {
                      final diary = diaries[i];
                      return GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.teal[50],
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (_) => Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      diary.title,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      diary.content,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "Tanggal: ${diary.date.toLocal().toString().split(' ')[0]}",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal[300],
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Tutup"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(
                                'Kelola Diary',
                                style: TextStyle(color: Colors.teal[700]),
                              ),
                              content: const Text(
                                  'Pilih aksi yang ingin dilakukan:'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddEditDiaryScreen(
                                          id: diary.id,
                                          title: diary.title,
                                          content: diary.content,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Edit'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Provider.of<DiaryProvider>(context,
                                            listen: false)
                                        .deleteDiary(diary.id);
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Diary berhasil dihapus!'),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Hapus',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          color: Colors.teal[100],
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                // Kotak Tanggal
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.teal[300],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "${diary.date.day}/${diary.date.month}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Judul dan preview konten
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        diary.title,
                                        style: GoogleFonts.dancingScript(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        diary.content.length > 100
                                            ? "${diary.content.substring(0, 100)}..."
                                            : diary.content,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.teal[300],
        selectedItemColor: Colors.teal[800],
        unselectedItemColor: Colors.teal[600],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Tambah Diary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
        onTap: (index) async {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddEditDiaryScreen(),
              ),
            );
          } else if (index == 1) {
            final newUsername = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsScreen(currentUsername: username),
              ),
            );
            if (newUsername != null && newUsername != username) {
              setState(() {
                username = newUsername;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Username berhasil diperbarui!')),
              );
            }
          }
        },
      ),
    );
  }
}
