import 'package:flutter/material.dart';


// WIDGET 
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});  

  @override
  State<SearchPage> createState() => _SearchPageState();
}


// STATE
class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ColoredBox(
        color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('EXPLORE', style: Theme.of(context).textTheme.headlineMedium)
          ],
        )
      )
    );
  }
}
