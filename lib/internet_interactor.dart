import 'dart:convert';
import 'package:http/http.dart' as http;
import 'to_do_items.dart';

String ENDPOINT = "https://todoapp-api.apps.k8s.gu.se";
String apiKey = "e78b5f31-8969-4a97-b493-16361a5c4233";

class InternetInteractor {
  static Future<List<ToDoItem>> getTodos() async {
    http.Response response =
        await http.get(Uri.parse('$ENDPOINT/todos?key=$apiKey'));
    String body = response.body;
    List jsonResponse = jsonDecode(body);
    if (response.statusCode != 200) {}
    return jsonResponse.map((json) => ToDoItem.fromJson(json)).toList();
  }

  static createToDo(ToDoItem item) async {
    var body = {"title": item.title, "done": item.done};

    var response = await http.post(Uri.parse('$ENDPOINT/todos?key=$apiKey'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      return getTodos();
    }
  }

  static removeToDo(ToDoItem item) async {
    var response =
        await http.delete(Uri.parse('$ENDPOINT/todos/${item.id}?key=$apiKey'));

    if (response.statusCode == 200) {
      return getTodos();
    }
  }

  static updateToDo(ToDoItem item) async {
    var body = {"title": item.title, "done": !item.done};

    var response = await http.put(
        Uri.parse('$ENDPOINT/todos/${item.id}?key=$apiKey'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      return getTodos();
    }

    String array = response.body;
    List jsonResponse = jsonDecode(array);
    return jsonResponse.map((json) => ToDoItem.fromJson(json)).toList();
  }
}
