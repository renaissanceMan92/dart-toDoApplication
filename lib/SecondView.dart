import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecondView extends StatelessWidget {

  final _myController = TextEditingController();

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.grey,
          leading: IconButton(icon:Icon(Icons.arrow_back_ios),
            onPressed:() => Navigator.pop(context),
          ),
          title: Text('TIG 169 TODO', style: TextStyle(color: Colors.black)),
        ),
        body: Center(
          child: Column(
              children: <Widget> [
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextField(
                              autofocus: true,
                              controller: _myController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'What are you going to do?',
                              )
                          )
                      ),
                    ),
                  ),
                ),
                RaisedButton.icon(
                  icon: Icon(Icons.add),
                  onPressed:() {
                    if(_myController.text.length > 0) {
                      Navigator.pop(context, _myController.text);
                    }
                  },
                  label: Text('ADD', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ]
          ),
        )
    ),
  );

}