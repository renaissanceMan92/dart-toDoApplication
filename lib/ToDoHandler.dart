import 'package:http/http.dart' as http;
import 'dart:convert';
import './Item.dart';

class ToDoHandler {

  static const Key = '21a1988a-e13c-4056-b427-77ea577ed475';
  static const URL = "https://todoapp-api-vldfm.ondigitalocean.app/";
  static List<dynamic> toDoList = [];

  static Future<List<dynamic>> get() async {
    List<dynamic> list = [];
    try {
      http.Response response = await http.get(URL + 'todos?key=' + Key);
      if (response.statusCode == 200) {
        jsonDecode(response.body).map((object) {
          list.add(Item(object["id"], object["title"], Item.toBool(object["done"]),));
        }).toList();
        toDoList = list;
        print("Successfully fetched list.");
      }
    } catch (error) {
      print(error);
    }
    return toDoList;
  }

  static Future<void> post(String name) async {
    try {
      http.Response response = await http.post(
        URL + 'todos?key=' + Key,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'title': name, 'done': 'false',
        }),
      );
      if (response.statusCode == 200) {
        print("Posted item with name: " + name + ".");
      }
    } catch (error) {
      print(error);
    }
  }

  static Future<void> put(String id, String name, bool newValue) async {
    try {
      http.Response response = await http.put(
          URL + 'todos/' + id + '?key=' + Key,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'title': name,
            'done': newValue.toString(),
          }));
      if (response.statusCode == 200) {
        print("Changed bool-status of " + name + " to " + newValue.toString() + ".");
      }
    } catch (error) {
      print(error);
    }
  }

  static Future<void> delete(String id) async {
    try {
      http.Response response = await http.delete(URL + 'todos/' + id + '?key=' + Key);
      if (response.statusCode == 200) {
        print("Deleted item with id: " + id + ".");
      }
    } catch (error) {
      print(error);
    }
  }

}