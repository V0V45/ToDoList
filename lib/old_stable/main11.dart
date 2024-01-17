import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ToDoListScreen(),
  ));
}

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({super.key});

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  List<String> tasks = [];
  List<String> ifReady = [];

  Future<void> getInitialTasks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      tasks = (prefs.getStringList('tasks') ?? []);
      ifReady = (prefs.getStringList('ifReady') ?? []);
    });
  }

  Future<void> addEmptyTask() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      tasks = (prefs.getStringList('tasks') ?? []);
      ifReady = (prefs.getStringList('ifReady') ?? []);
      tasks.add('');
      ifReady.add('no');
      prefs.setStringList('tasks', tasks);
      prefs.setStringList('ifReady', ifReady);
    });
  }

  Future<void> updateTaskName(String value, int index) async {
    final prefs = await SharedPreferences.getInstance();
    tasks[index] = value;
    prefs.setStringList('tasks', tasks);
  }

  Widget checkedOrUncheckedIcon(int index) {
    if (ifReady[index] == 'yes') {
      return const Icon(Icons.check_box, color: Colors.greenAccent);
    } else {
      return const Icon(Icons.check_box_outline_blank,
          color: Colors.greenAccent);
    }
  }

  Future<void> updateCheckbox(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (ifReady[index] == 'yes') {
        ifReady[index] = 'no';
      } else {
        ifReady[index] = 'yes';
      }
      prefs.setStringList('ifReady', ifReady);
    });
  }

  TextStyle crossedOrNormalText(int index) {
    if (ifReady[index] == 'yes') {
      return const TextStyle(
          color: Colors.red, decoration: TextDecoration.lineThrough);
    } else {
      return const TextStyle(
          color: Colors.greenAccent, decoration: TextDecoration.none);
    }
  }

  Future<void> removeTask(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      tasks.removeAt(index);
      ifReady.removeAt(index);
      prefs.setStringList('tasks', tasks);
      prefs.setStringList('ifReady', ifReady);
    });
  }

  @override
  void initState() {
    getInitialTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text('Список задач'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addEmptyTask(),
        backgroundColor: Colors.greenAccent,
        child: const Icon(Icons.add),
      ),
      body: Container(
        color: Colors.black,
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: checkedOrUncheckedIcon(index),
                    onPressed: () => updateCheckbox(index),
                  ),
                ),
                Expanded(
                    flex: 8,
                    child: TextField(
                      cursorColor: Colors.greenAccent,
                      controller: TextEditingController(
                        text: tasks[index],
                      ),
                      onChanged: (value) {
                        updateTaskName(value, index);
                      },
                      style: crossedOrNormalText(index),
                      maxLines: null,
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.greenAccent),
                          )),
                    )),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      removeTask(index);
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
