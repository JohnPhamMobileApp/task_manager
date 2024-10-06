import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TaskListScreen(),
    );
  }
}

// Task class with optional sub-tasks
class Task {
  String name;
  bool isCompleted;
  List<Task> subTasks; // List of sub-tasks

  Task({required this.name, this.isCompleted = false, this.subTasks = const []});
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = []; // List to store tasks
  final TextEditingController _taskController = TextEditingController();

  // Method to add a task
  void addTask(String taskName) {
    setState(() {
      tasks.add(Task(name: taskName));
    });
  }

  // Method to mark a task as completed/incomplete
  void toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  // Method to remove a task
  void removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  // Show dialog to add a new task
  Future<void> _showAddTaskDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: TextField(
            controller: _taskController,
            decoration: InputDecoration(hintText: 'Enter task name'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (_taskController.text.isNotEmpty) {
                  addTask(_taskController.text);
                  _taskController.clear();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CW4: Task Manager App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _showAddTaskDialog, // Show add task dialog
              child: Text('Add Task'),
            ),
          ),
          // Task list
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(
                    value: tasks[index].isCompleted,
                    onChanged: (value) {
                      toggleTaskCompletion(index);
                    },
                  ),
                  title: Text(
                    tasks[index].name,
                    style: TextStyle(
                      decoration: tasks[index].isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  trailing: TextButton(
                    onPressed: () {
                      removeTask(index);
                    },
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.red), // DELETE Button Color
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }
}
