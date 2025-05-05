import 'package:flutter/material.dart';

void main() {
  runApp(const TodoListApp());
}

class TodoListApp extends StatelessWidget {
  const TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, // Menggunakan warna abu
      ),
      home: const TodoHomePage(),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800], // Warna abu tua untuk AppBar
        title: const Text('Rutinitas harian'),
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
