import 'package:flutter/material.dart';
import "package:graphql_flutter/graphql_flutter.dart";

import "contacts/graphqlConf.dart";
import "contacts/contactList.dart";

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

void main() => runApp(
  GraphQLProvider(
    client: graphQLConfiguration.client,
    child: CacheProvider(child: MyApp()),
  ),
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter + GraphQL Sample',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactList(),
    );
  }
}