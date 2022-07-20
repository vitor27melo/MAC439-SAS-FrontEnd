import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'aboutGrade.dart' as aboutGrade;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAS',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'SAS - USP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool formVisible = false;
  int _formsIndex = 1;
  var user = {};
  var usuarioLogado = false;

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final cpfController = TextEditingController();


  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    cpfController.dispose();
    super.dispose();
  }

  void _login() async {
    var url = Uri.parse('https://sas-mac439.herokuapp.com/login');
    var response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Access-Control_Allow_Origin": "*"
        },
        body: {
          "username": usernameController.text,
          "password": passwordController.text
        }
    );

    if (response.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop();
      Map<String, dynamic> user_json = jsonDecode(response.body);
      setState(() {
        user["token"] = user_json["token"];
        user["nome"] = user_json["nome"];
        usuarioLogado = true;
      });
      final snackBar = SnackBar(
        content: Text('Bem vindo(a), ${user["nome"]}!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        content: Text(response.body),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _register() async {
    var url = Uri.parse('https://sas-mac439.herokuapp.com/register');
    var response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Access-Control_Allow_Origin": "*"
        },
        body: {
          "username": usernameController.text,
          "name": nameController.text,
          "password": passwordController.text,
          "cpf": cpfController.text
        }
    );

    if (response.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop();
      Map<String, dynamic> user_json = jsonDecode(response.body);
      setState(() {
        user["token"] = user_json["token"];
        user["nome"] = user_json["nome"];
        usuarioLogado = true;
      });
      final snackBar = SnackBar(
        content: Text('Bem vindo(a), ${user["nome"]}!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        content: Text(response.body),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _onGoToAboutGradePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const aboutGrade.SecondRoute()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child:
          usuarioLogado ?
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  'Bom dia, ${user["nome"]}!',
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline6
              ),
              const SizedBox(height: 25),
              Image.asset('coronavirus.png', width: 100),
              const SizedBox(height: 25),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 20,
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          const Text('Sua'),
                          TextButton(onPressed: _onGoToAboutGradePage,
                              child: Text('nota de segurança')),
                          const Text('hoje é:')
                        ],
                      ),
                    ),
                  ]
              )
            ],
          )
              :
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 20,
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            TextButton(
                              child: Text('Faça login'),
                              onPressed: () {
                                Navigator.of(context).restorablePush(
                                    _loginDialogBuilder);
                              },
                            ),
                            const Text('ou'),
                            TextButton(
                              child: Text('cadastre-se'),
                              onPressed: () {
                                Navigator.of(context).restorablePush(
                                    _registerDialogBuilder);
                              },
                            ),
                            const Text('para acessar a plataforma!')
                          ],
                        ),
                      ),
                    ]
                )
              ]
          )
      ),
      floatingActionButton: usuarioLogado ? FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ) : null,
    );
  }

  Route<Object?> _loginDialogBuilder(BuildContext context, Object? arguments) {
    return RawDialogRoute<void>(
      pageBuilder: (BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,) {
        return SimpleDialog(
            titleTextStyle: TextStyle(
                color: Colors.green,
                fontSize: 20
            ),
            titlePadding: EdgeInsets.fromLTRB(12.0, 12.0, 0.0, 5.0),
            contentPadding: EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 16.0),
            title: Text('Login'),
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'CPF ou e-mail',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Senha',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      child: Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton(
                              onPressed: _login,
                              child: Text("Entrar")
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ]
        );
      },
    );
  }

  Route<Object?> _registerDialogBuilder(BuildContext context, Object? arguments) {
    return RawDialogRoute<void>(
      pageBuilder: (BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,) {
        return SimpleDialog(
            titleTextStyle: TextStyle(
                color: Colors.green,
                fontSize: 20
            ),
            titlePadding: EdgeInsets.fromLTRB(12.0, 12.0, 0.0, 5.0),
            contentPadding: EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 16.0),
            title: Text('Cadastro'),
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Nome ou apelido',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'E-mail',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: cpfController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'CPF',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Senha',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      child: Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton(
                              onPressed: _register,
                              child: Text("Registrar")
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ]
        );
      },
    );
  }
}
