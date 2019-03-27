import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:initiative_tracker/character_model.dart';
import 'package:initiative_tracker/validators.dart';

class AddCharacterPage extends StatefulWidget {
  static final String route = "Add-Page";

  @override
  AddCharacterPageState createState() => AddCharacterPageState();
}

class AddCharacterPageState extends State<AddCharacterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController hpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<int>> _dropDownMenuItems;
  int _currentMod;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentMod = _dropDownMenuItems[(_dropDownMenuItems.length~/2)].value;
    super.initState();
  }
  // here we are creating the list needed for the DropDownButton
  List<DropdownMenuItem<int>> getDropDownMenuItems() {
    List<DropdownMenuItem<int>> items = new List();
    for (int i = -5; i <= 5; i++) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(
          value: i,
          child: new Text(i.toString())
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Character'),
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
                  controller: nameController,
                  validator: (value){
                    if(value.isEmpty){
                      return 'Please enter a name';
                    }
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
                  validator: (value){
                    if(value.isEmpty || !isNumeric(value)){
                      return "Please enter an integer number";
                    }
                  },
                ),
              ),
              // Container(
              //   child: DropdownButton(
              //     value: _currentMod,
              //     items: _dropDownMenuItems,
              //     onChanged: changedDropDownItem,
              //   )
              // ),
              ScopedModelDescendant<CharacterListModel>(
                builder: (context, child, model) => RaisedButton(
                  child: Text('Add Character'),
                  onPressed: () {
                    if(_formKey.currentState.validate()){
                      Character character = Character(nameController.text, int.parse(hpController.text));
                      model.addCharacter(character);

                      Scaffold
                        .of(context)
                        .showSnackBar(SnackBar(content: Text('Added Character')));
                    }
                  },
                ),
              ),
            ],
        )
      ),
    );
  }
  void changedDropDownItem(int selectedMod) {
    setState(() {
      _currentMod = selectedMod;
    });
  }
}