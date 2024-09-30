import 'package:flutter/material.dart';
import 'to_do_items.dart';
import 'package:provider/provider.dart';
import 'main.dart';

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
