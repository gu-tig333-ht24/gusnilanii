import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/internet_interactor.dart';
import '/to_do_items.dart';
import 'to_do_button.dart';

class MyState extends ChangeNotifier {
  List<ToDoItem> _toDoList = [];
  List<ToDoItem> _toDoListDisplay = [];
  int filter = 1;
  bool loading = false;

  List<ToDoItem> get toDoList => _toDoList;
  List<ToDoItem> get toDoListDisplay => _toDoListDisplay;

  void fetchToDoList() async {
    var toDoList = InternetInteractor.getTodos();
    _toDoList = await toDoList;
    updateDisplay();
  }

  void add(ToDoItem newItem) async {
    loading = true;
    notifyListeners();
    _toDoList = await InternetInteractor.createToDo(newItem);
    updateDisplay();
  }

  void remove(ToDoItem itemToRemove) async {
    loading = true;
    notifyListeners();
    _toDoList = await InternetInteractor.removeToDo(itemToRemove);
    updateDisplay();
  }

  void updateStatus(ToDoItem itemToUpdate) async {
    loading = true;
    notifyListeners();
    _toDoList = await InternetInteractor.updateToDo(itemToUpdate);
    updateDisplay();
  }

  void setFilter(int newFilter) {
    filter = newFilter;
    updateDisplay();
  }

  void updateDisplay() {
    switch (filter) {
      case 1:
        _toDoListDisplay = _toDoList;
        break;
      case 2:
        _toDoListDisplay =
            _toDoList.where((item) => item.done == true).toList();
        break;
      case 3:
        _toDoListDisplay =
            _toDoList.where((item) => item.done == false).toList();
        break;
    }
    loading = false;
    notifyListeners();
  }
}

void main() {
  MyState state = MyState();
  state.fetchToDoList();
  state.updateDisplay();
  runApp(
    ChangeNotifierProvider(create: (context) => state, child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black, size: 24),
          title:
              const Text("TIG333 TODO", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.deepPurple,
          actions: <Widget>[
            PopupMenuButton(
                onSelected: (String value) {
                  context.read<MyState>().setFilter(int.parse(value));
                },
                itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(value: "1", child: Text('all')),
                      const PopupMenuItem(value: "2", child: Text('done')),
                      const PopupMenuItem(value: "3", child: Text('undone')),
                    ])
          ],
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return ToDoButton(context.watch<MyState>().toDoListDisplay[index]);
          },
          itemCount: context.watch<MyState>().toDoListDisplay.length,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddItemToToDoPage()));
          },
          child: Icon(Icons.add),
        ),
        bottomSheet: Container(
            color: Colors.white,
            child: Icon(context.watch<MyState>().loading ? Icons.wifi : null,
                size: 40)));
  }
}
