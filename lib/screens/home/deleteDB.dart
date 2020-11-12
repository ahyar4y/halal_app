import 'package:flutter/material.dart';
import 'package:halal_app/services/db.dart';
import 'package:halal_app/models/ingredientModel.dart';

class DeleteDB extends StatelessWidget {
  const DeleteDB({
    Key key,
    @required this.action,
    @required this.results,
    @required this.index,
  }) : super(key: key);

  final String action;
  final Iterable<IngredientModel> results;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirmation'),
      content: Text('Are you sure you want to $action this item?'),
      actions: <Widget>[
        TextButton(
          child: Text('Yes'),
          onPressed: () {
            DatabaseService(ingredientId: results.elementAt(index).id)
                .deleteDB();

            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
