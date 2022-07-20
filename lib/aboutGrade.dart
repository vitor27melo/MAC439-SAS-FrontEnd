import 'package:flutter/material.dart';

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nota de segurança SAS - USP'),
      ),
      body:
        Center(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: 350.0,
            child: Stack(
              children: <Widget>[
                Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('obrigado_atila.jpg',
                              color: Colors.white.withOpacity(0.08),
                              colorBlendMode: BlendMode.modulate
                          ),
                        ]

                    )
                ),
                Center(
                    widthFactor: 8,
                    child: Text("A sua nota de segurança representa o quão segura calculamos ser a sua visita presencial à universidade.")
                ),
              ],
            ),
          ),
        )
    );
  }
}

