import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
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
    List<ToDoItem> theToDoList = [
      ToDoItem("Have fun", false),
      ToDoItem("Have funz", true),
      ToDoItem("Dance", false),
      ToDoItem("Do the split", false),
    ];

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black, size: 24),
          title:
              const Text("TIG333 TODO", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.deepPurple,
          actions: <Widget>[
            PopupMenuButton(
                onSelected: (String value) {},
                itemBuilder: (BuildContext ctx) => [
                      const PopupMenuItem(value: '1', child: Text('all')),
                      const PopupMenuItem(value: '2', child: Text('done')),
                      const PopupMenuItem(value: '3', child: Text('undone')),
                    ])
          ],
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {},
              child: ToDoButton(theToDoList[index]),
            );
          },
          itemCount: theToDoList.length,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddItemToToDoPage()));
          },
          child: Icon(Icons.add),
        ));
  }
}

class ToDoItem {
  final String actionItem;
  final bool isItCompleted;
  ToDoItem(this.actionItem, this.isItCompleted);
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
              value: event.isItCompleted,
              onChanged: (value) => value!,
            ),
          ),
          Text(
            event.actionItem,
            style: TextStyle(fontSize: 21),
          ),
          Expanded(
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Icon(
                Icons.close,
                size: 32,
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
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "Input text here"),
              ),
            ),
            GestureDetector(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.add), Text("ADD")],
                ))
          ],
        ));
  }
}
