import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:halal_app/services/db.dart';
import 'package:halal_app/screens/loading.dart';
import 'package:halal_app/shared/infoAlert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:halal_app/shared/statusColor.dart';
import 'package:halal_app/shared/customDialog.dart';
import 'package:halal_app/screens/home/deleteDB.dart';
import 'package:halal_app/screens/home/addDBForm.dart';
import 'package:halal_app/models/ingredientModel.dart';
import 'package:halal_app/screens/home/updateDBForm.dart';

class SearchIngredient extends SearchDelegate {
  final List<IngredientModel> list;

  SearchIngredient({@required this.list});

  @override
  List<Widget> buildActions(BuildContext context) {
    final admin = Provider.of<User>(context);

    try {
      return [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
        admin == null
            ? Container()
            : IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialog(title: 'Add DB', child: AddDBForm());
                    },
                  );
                },
              ),
      ];
    } catch (e) {
      print(e);
    }
    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    try {
      return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        },
      );
    } catch (e) {
      print(e);
    }
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    try {
      final Iterable<IngredientModel> results = list.where(
          (item) => item.name.toLowerCase().contains(query.toLowerCase()));
      return results.isEmpty
          ? Center(
              child: Text(
                'not found',
                style: TextStyle(
                  fontSize: 24.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            )
          : SearchList(results: results);
    } catch (e) {
      print(e);
    }
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    try {
      return StreamBuilder(
        stream: DatabaseService().ingredients,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Loading();
          else {
            List<IngredientModel> list = snapshot.data;
            Iterable<IngredientModel> results = list.where((item) =>
                item.name.toLowerCase().contains(query.toLowerCase()));
            return results.isEmpty
                ? Center(
                    child: Text(
                      'not found',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : SearchList(results: results);
          }
        },
      );
    } catch (e) {
      print(e.toString());
    }
    throw UnimplementedError();
  }
}

class SearchList extends StatelessWidget {
  final Iterable<IngredientModel> results;

  const SearchList({
    Key key,
    @required this.results,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<User>(context);

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return admin == null
            ? ItemTile(results: results, index: index)
            : DismissibleItem(results: results, index: index);
      },
    );
  }
}

class ItemTile extends StatelessWidget {
  const ItemTile({
    Key key,
    @required this.results,
    @required this.index,
  }) : super(key: key);

  final Iterable<IngredientModel> results;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(results.elementAt(index).name),
      subtitle: Text(
        results.elementAt(index).status,
        style: TextStyle(
          color: statusColor(results.elementAt(index).status),
        ),
      ),
      trailing: results.elementAt(index).comment == ''
          ? Container(
              width: 0.0,
              height: 0.0,
            )
          : IconButton(
              icon: Icon(
                Icons.info_outline,
                size: 30.0,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return InfoAlert(alert: results.elementAt(index).comment);
                  },
                );
              },
            ),
    );
  }
}

class DismissibleItem extends StatelessWidget {
  const DismissibleItem({
    Key key,
    @required this.results,
    @required this.index,
  }) : super(key: key);

  final Iterable<IngredientModel> results;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(results.elementAt(index).id),
      background: Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        alignment: AlignmentDirectional.centerStart,
        child: Icon(Icons.edit, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        alignment: AlignmentDirectional.centerEnd,
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {},
      confirmDismiss: (direction) async {
        String action;
        if (direction == DismissDirection.startToEnd)
          action = 'update';
        else
          action = 'delete';

        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return action == 'update'
                ? CustomDialog(
                    title: 'Update DB',
                    child: UpdateDBForm(id: results.elementAt(index).id))
                : DeleteDB(action: action, results: results, index: index);
          },
        );
      },
      child: ItemTile(results: results, index: index),
    );
  }
}
