import 'package:flutter/material.dart';
import 'globals.dart' as globals;


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
            width: 500.0,
            child: Stack(
              children: <Widget>[
                Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                              'assets/images/atila.jpg',
                              color: Colors.white.withOpacity(0.08),
                              colorBlendMode: BlendMode.modulate
                          ),
                        ]

                    )
                ),
                Center(
                    widthFactor: 15,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              "A sua nota de segurança representa o quão segura calculamos ser a sua visita presencial à universidade. Levamos em consideração, dentre outros, os seguintes fatores:",
                              style: TextStyle(
                                fontSize: globals.defaultStringSize,
                              ),
                          ),
                          const SizedBox(height: 30),
                          Text("- A situação atual da pandemia no estado de São Paulo.",
                            style: TextStyle(
                              fontSize: globals.defaultStringSize - 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text("- As recomendações da Superintendência de Saúde da universidade.",
                            style: TextStyle(
                              fontSize: globals.defaultStringSize - 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text("- O possível contato que você teve com pessoas sintomáticas ou positivadas para a doença, assim como o intervalo temporal desse contato.",
                            style: TextStyle(
                              fontSize: globals.defaultStringSize - 1,
                            ),
                          ),
                        ]
                    )
                ),
              ],
            ),
          ),
        )
    );
  }
}

