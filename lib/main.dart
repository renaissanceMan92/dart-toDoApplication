import 'package:flutter/material.dart';
import './SecondView.dart';
import './ToDoHandler.dart';

void main() => runApp(MaterialApp(
    home: MyToDo(),));

class MyToDo extends StatefulWidget {
  @override
  _MyToDoState createState() => _MyToDoState();
}

class _MyToDoState extends State<MyToDo> {

  List<dynamic> _toDoList = [];
  var _filterBy = 'all';

  void _filterList(List<dynamic> list, String filterBy) {
    if (_filterBy == 'done') {
      _toDoList = list.where((item) => item.isChecked).toList();
    } else if (_filterBy == 'undone') {
      _toDoList = list.where((item) => !item.isChecked).toList();
    } else {
      _toDoList = list;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: _myAppBar(),
      body: _myListView(),
      floatingActionButton: _myActionButton(),
    );

  Widget _myAppBar() => AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.grey,
      title: Text('My ToDo', style: TextStyle(color: Colors.black)),
      actions: [
        PopupMenuButton(
            onSelected: (value) => setState(() => _filterBy = value),
            itemBuilder: (context) => [
              PopupMenuItem(child: Text('all'), value: 'all'),
              PopupMenuItem(child: Text('done'), value: 'done'),
              PopupMenuItem(child: Text('undone'), value: 'undone'),
            ]
        ),
      ],
    );

  Widget _myListView() => FutureBuilder<List<dynamic>>(
      future: ToDoHandler.get(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          _filterList(snapshot.data, _filterBy);
          return ListView.builder(
              itemCount: _toDoList.length,
              itemBuilder: (context, index) {
                if (_toDoList[index].name == null) {
                  _toDoList[index].name = "No name";
                }
                return Row(
                    children: <Widget>[
                      Checkbox(
                        checkColor: Colors.black,
                        activeColor: Colors.grey,
                        value: _toDoList[index].isChecked,
                        onChanged: (bool newValue) async {
                          await ToDoHandler.put(_toDoList[index].id, _toDoList[index].name, newValue);
                          setState(() {});
                        },
                      ),
                      Text(_toDoList[index].name, style: TextStyle(fontSize: 18)),
                      Spacer(),
                      CloseButton(
                          onPressed: () async {
                            await ToDoHandler.delete(_toDoList[index].id);
                            setState(() {});
                          }
                      ),
                    ]
                );
              });
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );

  Widget _myActionButton() => FloatingActionButton(
      elevation: 4,
      backgroundColor: Colors.grey,
      child: const Icon(Icons.add),
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondView()),
        );
        if (result != null) {
          await ToDoHandler.post(result);
          setState(() {});
        }
      },
    );

}