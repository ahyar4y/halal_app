import 'package:flutter/material.dart';
import 'package:halal_app/services/auth.dart';

class SecretForm extends StatefulWidget {
  const SecretForm({Key key}) : super(key: key);

  @override
  _SecretFormState createState() => _SecretFormState();
}

class _SecretFormState extends State<SecretForm> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  String _pass = '';
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            autofocus: true,
            obscureText: true,
            validator: (val) => val.isEmpty ? '' : null,
            onChanged: (val) => setState(() => _pass = val),
          ),
          SizedBox(height: 10.0),
          FlatButton(
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                dynamic result = await _auth.adminLogin(_pass);
                if (result == null)
                  setState(() => _error = 'ERROR');
                else {
                  //print(result);
                  Navigator.pop(context);
                }
              }
            },
            color: Theme.of(context).primaryColor,
            child: Text('OK'),
          ),
          Text(
            _error,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
