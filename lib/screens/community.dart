import 'package:flutter/material.dart';


// WIDGET 
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});  
  
  @override
  State<ExplorePage> createState() => _ExplorePageState();
}


// STATE
class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('COMMUNITY', style: Theme.of(context).textTheme.headlineMedium)
        ],
      )
    );
  }
}
