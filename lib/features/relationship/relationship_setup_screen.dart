import 'package:flutter/material.dart';

class RelationshipSetupScreen extends StatefulWidget {
  const RelationshipSetupScreen({super.key});

  @override
  State<RelationshipSetupScreen> createState() =>
      _RelationshipSetupScreenState();
}

class _RelationshipSetupScreenState extends State<RelationshipSetupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Relationship Setup Screen.')));
  }
}
