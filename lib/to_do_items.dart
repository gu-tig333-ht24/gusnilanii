import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

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
