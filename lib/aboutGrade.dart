import 'package:flutter/material.dart';

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nota de segurança SAS - USP'),
      ),
      body: Center(
        child: Text("Lorem ipsum")
      ),
    );
  }
}