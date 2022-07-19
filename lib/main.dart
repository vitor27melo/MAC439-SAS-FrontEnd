import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'aboutGrade.dart' as aboutGrade;

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();


  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() async{
    var url = Uri.parse('http://localhost:1323/login');
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
    print(response.body);
  }

  void _banana() async{

    var url = Uri.parse('http://localhost:1323/days');
    var response = await http.get(url, headers: {
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*"
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  void _onGoToAboutGradePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const aboutGrade.SecondRoute()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var condition = false;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child:
          condition ?
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Bom dia, Vítor',
                  style: Theme.of(context).textTheme.headline6
                ),
                const SizedBox(height: 25),
                const Image(
                  image: NetworkImage('https://cdn.pixabay.com/photo/2020/04/29/08/24/coronavirus-5107804_960_720.png'),
                  width: 100,
                ),
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
                          TextButton(onPressed: _onGoToAboutGradePage, child: Text('nota de segurança')),
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
                                  Navigator.of(context).restorablePush(_loginDialogBuilder);
                                },
                            ),
                            const Text('ou'),
                            TextButton(
                              child: Text('cadastre-se'),
                              onPressed: () {
                                setState(() {
                                  formVisible = true;
                                  _formsIndex = 2;
                                });
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
      floatingActionButton: FloatingActionButton(
        onPressed: _banana,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Route<Object?> _loginDialogBuilder(
      BuildContext context, Object? arguments) {
        return RawDialogRoute<void>(
          pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              ) {
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
}

