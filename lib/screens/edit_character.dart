import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:initiative_tracker/character.dart';
import 'package:initiative_tracker/party_model.dart';
import 'package:initiative_tracker/validators.dart';

class EditCharacterPage extends StatefulWidget {
  static final String route = "Edit-Page";

  final Character item;

  const EditCharacterPage({Key key, this.item}) : super(key: key);

  @override
  EditCharacterPageState createState() => EditCharacterPageState();
}

class EditCharacterPageState extends State<EditCharacterPage> {
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController hpController = new TextEditingController();
  final TextEditingController initController = new TextEditingController();
  final TextEditingController noteController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    nameController.text = widget.item.name.toString();
    hpController.text = widget.item.hp.toString();
    initController.text = widget.item.initiative.toString();
    noteController.text = (widget.item.notes ?? "").toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Character'),
      ),
      body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Name",
                  ),
                  initialValue: widget.item.name,
                  validator: (value) {
                    if (value.isEmpty) {
                      nameController.text = "";
                      return 'Please enter a name';
                    }
                    nameController.text = value;
                    return null;
                  },
                ),
              ),
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "HP",
                  ),
                  keyboardType: TextInputType.number,
                  controller: hpController,
                  validator: (value) {
                    if (value.isEmpty || !isNumeric(value)) {
                      return "Please enter an integer number";
                    }
                    return null;
                  },
                ),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Initiative",
                      ),
                      keyboardType: TextInputType.number,
                      controller: initController,
                      validator: (value) {
                        if (value.isEmpty || !isNumeric(value)) {
                          return "Please enter an integer number";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Flexible(
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Notes",
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: noteController,
                ),
              ),
              new ScopedModelDescendant<PartyModel>(
                builder: (context, child, model) => RaisedButton(
                  child: Text('Edit Character'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      widget.item.edit(
                          nameController.text,
                          int.parse(hpController.text),
                          initController.text != ""
                              ? int.parse(initController.text)
                              : null,
                          noteController.text);

                      model.characterList.sort();
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }
}
