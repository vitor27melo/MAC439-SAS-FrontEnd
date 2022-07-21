import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'globals.dart' as globals;
import 'package:http_parser/http_parser.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:html' as webFile;


class CourseSchedulePage extends StatefulWidget {
  const CourseSchedulePage({Key? key}) : super(key: key);

  @override
  State<CourseSchedulePage> createState() => _CourseSchedulePageState();
}


class _CourseSchedulePageState extends State<CourseSchedulePage> {
  List<int> index_list = [];
  List<dynamic> lista = [];

  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _loadDocuments(context));
  }

  Future<void> _loadDocuments(BuildContext context) async {
    var url = Uri.parse(globals.api + '/user/course-schedule');
    var response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Access-Control_Allow_Origin": "*",
          "Authorization": "Bearer ${globals.token}"
        },
    );

    print(response.statusCode);
    print(response.body);
    lista = jsonDecode(response.body);

    for (var i = 0; i < lista.length; i++) {
        index_list.insert(0, i);
    }
    setState((){});
  }

  Future<void> _download(BuildContext context, int index) async {
    var string = globals.api + '/user/download-file/${lista[index]["documento"]["anexo"]["conteudo"]}';
    var url = Uri.parse(string);
    var request = http.MultipartRequest("GET", url);

    request.headers['Access-Control_Allow_Origin'] = '*';
    request.headers['Authorization'] = "Bearer ${globals.token}";


    var response = await request.send();
    if(response.statusCode == 200) {

      Uint8List data = await response.stream.toBytes();

      final content = base64Encode(data);
      final anchor = webFile.AnchorElement(
          href: "data:application/octet-stream;charset=utf-16le;base64,$content")
        ..setAttribute("download", lista[index]["documento"]["anexo"]["conteudo"].split("-filebegin-")[1])
        ..click();
    } else {
      final snackBar = SnackBar(
        content: Text('Houve um erro ao fazer o download. Tente novamente!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  String _nomeDisciplina(index) {
    return lista[index]["sigla"] + " - " + lista[index]["nome"];
  }

  String _horarioDisciplina(index) {
    return lista[index]["dia_semana"] + " " + lista[index]["inicio"] + "-" + lista[index]["fim"];
  }

  bool _disciplinaAgora(index) {
    var map = {
      "SEG": 1,
      "TER": 2,
      "QUA": 3,
      "QUI": 4,
      "SEX": 5,
      "SAB": 6,
      "DOM": 7,
    };
    DateTime now = new DateTime.now();

    var inicio = int.parse(lista[index]["inicio"].split(":")[0]);
    var fim = int.parse(lista[index]["fim"].split(":")[0]);

    if (now.weekday == map[lista[index]["dia_semana"]] && now.hour > inicio - 1 && now.hour < fim + 1 ){
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Grade Horária'),
        ),
        body:SingleChildScrollView(
        child:
        Center(
          child: Container(
            padding: const EdgeInsets.all(9.0),
            width: 400.0,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: index_list.map((int index) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Divider(
                            color: Colors.black
                        ),
                        Text(
                            _nomeDisciplina(index),
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                            ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                            _horarioDisciplina(index)
                        ),
                        const SizedBox(height: 15),
                        _disciplinaAgora(index) ?
                          ElevatedButton(
                            child: Text("Estou presente!"),
                            onPressed: () {
                              _download(context, index);
                            },
                          )
                          :
                          ElevatedButton(
                            child: Text("Estou presente!"),
                            onPressed: null,
                          ),
                        const SizedBox(height: 20),
                      ]
                  );
                }).toList(),

            )
          ),
        )
    )
    );
  }
}