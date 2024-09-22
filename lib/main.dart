import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/internet_interactor.dart';

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

class ToDoItem {
  final String title;
  bool done;
  final String? id;

  ToDoItem(this.title, this.done, [this.id]);

  factory ToDoItem.fromJson(Map<String, dynamic> json) {
    return ToDoItem(json["title"], json["done"], json["id"]);
  }

  Map<String, dynamic> fromJson() {
    return {"id": id, "title": title, "done": done};
  }
}

class ToDoButton extends StatelessWidget {
  final ToDoItem event;
  ToDoButton(this.event, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey))),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Checkbox(
              value: event.done,
              onChanged: (value) => context.read<MyState>().updateStatus(event),
            ),
          ),
          Text(
            event.title,
            style: TextStyle(
                fontSize: 21,
                decoration: event.done ? TextDecoration.lineThrough : null),
          ),
          Expanded(
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: IconButton(
                onPressed: () {
                  context.read<MyState>().remove(event);
                },
                icon: Icon(
                  Icons.close,
                  size: 32,
                ),
              ),
            ),
          ])),
        ]));
  }
}

class AddItemToToDoPage extends StatelessWidget {
  AddItemToToDoPage({super.key});

  @override
  Widget build(BuildContext context) {
    String newItemToAdd = "";
    return Scaffold(
        appBar: AppBar(
            title: const Text("TIG333 TODO",
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.deepPurple),
        body: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(right: 20, left: 20, top: 30, bottom: 30),
              child: TextField(
                onChanged: (value) {
                  newItemToAdd = value;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "Input text here"),
              ),
            ),
            GestureDetector(
                onTap: () {
                  if (newItemToAdd == "") {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("The text box is empty"),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Ok'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    context.read<MyState>().add(ToDoItem(newItemToAdd, false));
                    Navigator.pop(context);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.add), Text("ADD")],
                ))
          ],
        ));
  }
}
