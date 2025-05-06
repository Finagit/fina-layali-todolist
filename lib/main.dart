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
    final List<Map<String, dynamic>> _todos = [];
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _descriptionController = TextEditingController();

    String _filter = 'Semua';

  void _addTodo() {
    final title = _titleController.text;
    final description = _descriptionController.text;
    if (title.isNotEmpty && description.isNotEmpty) {
      setState(() {
        _todos.add({
          'title': title,
          'description': description,
          'isDone': false,
        });
        _titleController.clear();
        _descriptionController.clear();
      });
    }
  }

  void _editTodo(int index) {
    _titleController.text = _todos[index]['title'];
    _descriptionController.text = _todos[index]['description'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Tugas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Hari dan tgl')),
            TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Catatan')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _todos[index]['title'] = _titleController.text;
                _todos[index]['description'] = _descriptionController.text;
                _titleController.clear();
                _descriptionController.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  void _removeTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredTodos = _todos.where((todo) {
     if (_filter == 'Selesai') return todo['isDone'] == true;
     if (_filter == 'Belum Selesai') return todo['isDone'] == false;
    return true;
  }).toList();


    return Scaffold(
      appBar: AppBar( 
       title: const Text('Rutinitas harian'),
        actions: [
          DropdownButton<String>(
            value: _filter,
            onChanged: (val) => setState(() => _filter = val!),
            items: const [
              DropdownMenuItem(value: 'Semua', child: Text('Semua')),
              DropdownMenuItem(value: 'Selesai', child: Text('Selesai')),
              DropdownMenuItem(value: 'Belum Selesai', child: Text('Belum Selesai')),
            ],
          ),
          Switch(
            value: _themeModeNotifier.value == ThemeMode.dark,
            onChanged: (val) => _themeModeNotifier.value = val ? ThemeMode.dark : ThemeMode.light,
          ),
        ],
      ),
      body: Container(
        color:  Theme.of(context).scaffoldBackgroundColor, // Background abu muda
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
                itemCount: filteredTodos.length,
                itemBuilder: (context, index) {
                  final todo = filteredTodos[index];
                  final realIndex = _todos.indexOf(todo); // Untuk tindakan seperti edit/hapus
                  return Card(
                     margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      onLongPress: () => _editTodo(realIndex),
                      leading: Checkbox(
                        value: todo['isDone'],
                        onChanged: (val) => setState(() => todo['isDone'] = val),
                      ),
                      title: Text(
                        todo['title'],
                        style: TextStyle(
                          decoration: todo['isDone'] ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      subtitle: Text(todo['description']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeTodo(realIndex),
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