import 'package:flutter/material.dart';
final ValueNotifier<ThemeMode> _themeModeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const TodoListApp());
}

class TodoListApp extends StatelessWidget {
  const TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Todo List',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blueGrey,
            scaffoldBackgroundColor: Colors.pink.shade50,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blueGrey,
          ),
          themeMode: mode,
          home: const TodoHomePage(),
        );
      },
    );
  }
}
class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final List<Map<String, String>> _todos = []; // Daftar tugas dengan deskripsi
  final TextEditingController _titleController = TextEditingController(); // Untuk input judul tugas
  final TextEditingController _descriptionController = TextEditingController(); // Untuk input deskripsi

  void _addTodo() {
    final title = _titleController.text;
    final description = _descriptionController.text;
    if (title.isNotEmpty && description.isNotEmpty) {
      setState(() {
        _todos.add({'title': title, 'description': description});
        _titleController.clear();
        _descriptionController.clear();
      });
    }
  }

  void _removeTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        
       title: const Text('Rutinitas harian'),
        actions: [
          Row(
            children: [
              const Icon(Icons.dark_mode),
              Switch(
                value: _themeModeNotifier.value == ThemeMode.dark,
                onChanged: (val) {
                  _themeModeNotifier.value =
                      val ? ThemeMode.dark : ThemeMode.light;
                },
              ),
            ],
          ),
        ],
      ),
      body: Container(
        color: Colors.pink.shade50, // Background abu muda
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Hari dan tgl',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white, // Warna putih untuk input
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTodo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Warna tombol tambah putih
                    foregroundColor: Colors.black, // Warna teks tombol hitam
                  ),
                  child: const Text('Tambah'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'tambahkan catatan',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white, // Warna putih untuk input deskripsi
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.grey.shade200, // Warna abu muda untuk card
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(_todos[index]['title']!),
                      subtitle: Text(_todos[index]['description']!),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeTodo(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
