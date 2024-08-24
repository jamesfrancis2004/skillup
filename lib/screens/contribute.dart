import 'package:flutter/material.dart';


// WIDGET 
class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});  
  
  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}


// STATE
class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('CONTRIBUTE', style: Theme.of(context).textTheme.headlineMedium)
        ],
      )
    );
  }
}
