import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workerlocatorapp/providers/auth.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
          onPressed: () => Provider.of<Auth>(context, listen: false).logout(),
          child: Text('Logout')),
    );
  }
}
