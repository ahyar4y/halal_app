import 'package:flutter/material.dart';
import 'package:halal_app/services/db.dart';

class AddDBForm extends StatefulWidget {
  const AddDBForm({
    Key key,
  }) : super(key: key);

  @override
  _AddDBFormState createState() => _AddDBFormState();
}

class _AddDBFormState extends State<AddDBForm> {
  final _dbService = DatabaseService();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();

  String _name = '';
  String _status = '';
  String _comment = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _controller1,
            validator: (val) => val.isEmpty ? '' : null,
            onChanged: (val) => setState(() => _name = val),
            decoration: InputDecoration(
              hintText: 'Name',
            ),
          ),
          TextFormField(
            controller: _controller2,
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
            decoration: InputDecoration(
              hintText: 'Status',
            ),
          ),
          TextFormField(
            controller: _controller3,
            validator: (val) => null,
            onChanged: (val) => setState(() => _comment = val),
            decoration: InputDecoration(
              hintText: 'Comment',
            ),
          ),
          SizedBox(height: 30.0),
          FlatButton(
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                await _dbService
                    .addDB(_name, _status, _comment)
                    .catchError((onError) => print(onError));

                setState(() {
                  _controller1.clear();
                  _controller2.clear();
                  if (_controller3 != null) _controller3.clear();
                });
              }
            },
            color: Theme.of(context).primaryColor,
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
