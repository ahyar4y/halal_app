import 'package:flutter/material.dart';
import 'package:halal_app/services/db.dart';
import 'package:halal_app/screens/loading.dart';
import 'package:halal_app/models/ingredientModel.dart';

class UpdateDBForm extends StatefulWidget {
  final String id;
  const UpdateDBForm({Key key, @required this.id}) : super(key: key);

  @override
  _UpdateDBFormState createState() => _UpdateDBFormState();
}

class _UpdateDBFormState extends State<UpdateDBForm> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  String _status;
  String _comment;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: DatabaseService(ingredientId: widget.id).ingredient,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            IngredientModel ingredient = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue: ingredient.name ?? _name,
                    validator: (val) => val.isEmpty ? '' : null,
                    onChanged: (val) => setState(() => _name = val),
                  ),
                  TextFormField(
                    initialValue: ingredient.status ?? _status,
                    validator: (val) {
                      switch (val.toLowerCase()) {
                        case 'halal':
                        case 'haram':
                        case 'doubtful':
                          return null;
                          break;
                        default:
                          return '';
                          break;
                      }
                    },
                    onChanged: (val) => setState(() => _status = val),
                  ),
                  TextFormField(
                    initialValue: ingredient.comment ?? _comment,
                    validator: (val) => null,
                    onChanged: (val) => setState(() => _comment = val),
                  ),
                  SizedBox(height: 30.0),
                  FlatButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await DatabaseService(ingredientId: ingredient.id)
                            .updateDB(
                                _name ?? ingredient.name,
                                _status ?? ingredient.status,
                                _comment ?? ingredient.comment)
                            .catchError((onError) => print(onError));
                        Navigator.pop(context);
                      }
                    },
                    color: Theme.of(context).primaryColor,
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          } else
            return Loading();
        });
  }
}
