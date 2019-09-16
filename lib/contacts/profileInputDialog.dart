import "package:flutter/material.dart";
import "package:graphql_flutter/graphql_flutter.dart";

import "graphQLConf.dart";
import "queryMutation.dart";
import "user.dart";

class ProfileInputDialog extends StatefulWidget {
  final User user;
  final bool isAdd;

  ProfileInputDialog({Key key, this.user, this.isAdd}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _ProfileInputDialog(this.user, this.isAdd);
}

class _ProfileInputDialog extends State<ProfileInputDialog> {
  TextEditingController txtId = TextEditingController();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  QueryMutation addMutation = QueryMutation();

  final User user;
  final bool isAdd;

  _ProfileInputDialog(this.user, this.isAdd);

  @override
  void initState() {
    super.initState();
    if (!this.isAdd) {
      txtId.text = user.getId();
      txtName.text = user.getName();
      txtLastName.text = user.getLastName();
      txtPhone.text = user.getPhone().toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      title: Text(this.isAdd ? "Add" : "Edit or Delete"),
      content: Container(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  child: TextField(
                    maxLength: 255,
                    controller: txtId,
                    enabled: false,
                    decoration: InputDecoration(
                      icon: Icon(Icons.perm_identity),
                      labelText: "ID",
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 80.0),
                  child: TextField(
                    maxLength: 40,
                    controller: txtName,
                    decoration: InputDecoration(
                      icon: Icon(Icons.text_format),
                      labelText: "Name",
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 160.0),
                  child: TextField(
                    maxLength: 40,
                    controller: txtLastName,
                    decoration: InputDecoration(
                      icon: Icon(Icons.text_rotate_vertical),
                      labelText: "Last name",
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 240.0),
                  child: TextField(
                    maxLength: 12,
                    controller: txtPhone,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Phone", icon: Icon(Icons.calendar_today)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Close"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        !this.isAdd
            ? FlatButton(
                child: Text("Delete"),
                onPressed: () async {
                  GraphQLClient _client = graphQLConfiguration.clientToQuery();
                  QueryResult result = await _client.mutate(
                    MutationOptions(
                      document: addMutation.deleteUser(txtId.text),
                    ),
                  );
                  if (!result.hasErrors) Navigator.of(context).pop();
                },
              )
            : null,
        FlatButton(
          child: Text(this.isAdd ? "Add" : "Edit"),
          onPressed: () async {
            if (
                txtName.text.isNotEmpty &&
                txtLastName.text.isNotEmpty &&
                txtPhone.text.isNotEmpty) {
              if (this.isAdd) {
                GraphQLClient _client = graphQLConfiguration.clientToQuery();
                QueryResult result = await _client.mutate(
                  MutationOptions(
                    document: addMutation.createUser(txtName.text,
                      txtLastName.text,
                      int.parse(txtPhone.text),
                    ),
                  ),
                );
                if (!result.hasErrors) {
                  txtId.clear();
                  txtName.clear();
                  txtLastName.clear();
                  txtPhone.clear();
                  Navigator.of(context).pop();
                }
              } else {
                GraphQLClient _client = graphQLConfiguration.clientToQuery();
                QueryResult result = await _client.mutate(
                  MutationOptions(
                    document: addMutation.updateUser(
                      txtId.text,
                      txtName.text,
                      txtLastName.text,
                      int.parse(txtPhone.text),
                    ),
                  ),
                );
                if (!result.hasErrors) {
                  txtId.clear();
                  txtName.clear();
                  txtLastName.clear();
                  txtPhone.clear();
                  Navigator.of(context).pop();
                }
              }
            }
          },
        )
      ],
    );
  }
}