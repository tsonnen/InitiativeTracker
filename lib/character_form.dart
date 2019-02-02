import 'package:flutter/material.dart';
import 'package:hello_world/character_model.dart';

class NewCharacterFormPage extends StatefulWidget{
  @override
  _NewCharacterFormPageState createState() => _NewCharacterFormPageState();

}

class _NewCharacterFormPageState extends State<NewCharacterFormPage>{
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Name",
            ),
            validator: (value){
              if(value.isEmpty){
                return "Please enter a unique name";
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0
            ),
            child: RaisedButton(
              onPressed: (){
                if(_formKey.currentState.validate()){
                  Scaffold.of(context)
                    .showSnackBar(SnackBar(content:Text('Processing Data')));
                }
              },
              child: Text('Submit'),
            ),
          )
        ],
      ),// We'll build this out in the next steps!
    );
  }
}