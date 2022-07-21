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


class ExamListPage extends StatefulWidget {
  const ExamListPage({Key? key}) : super(key: key);

  @override
  State<ExamListPage> createState() => _ExamListPageState();
}


class _ExamListPageState extends State<ExamListPage> {
  List<String> lista = [];

  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _loadDocuments(context));
  }

  Future<void> _loadDocuments(BuildContext context) async {
    var url = Uri.parse(globals.api + '/user/files-list');
    var response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Access-Control_Allow_Origin": "*",
          "Authorization": "Bearer ${globals.token}"
        },
    );


    List<dynamic> user_json = jsonDecode(response.body);

    for (var i = 0; i < user_json.length; i++) {
      if (user_json[i]['cpf'] == globals.cpf) {
        lista.insert(0, user_json[i]["exame"]["anexo"]["conteudo"]);
      }
    }
    setState((){});
  }

  Future<void> _download(BuildContext context, String filename) async {
    var url = Uri.parse(globals.api + '/user/download-file/' + filename);
    var request = http.MultipartRequest("GET", url);

    request.headers['Access-Control_Allow_Origin'] = '*';
    request.headers['Authorization'] = "Bearer ${globals.token}";


    var response = await request.send();
    if(response.statusCode == 200) {

      Uint8List data = await response.stream.toBytes();

      final content = base64Encode(data);
      final anchor = webFile.AnchorElement(
          href: "data:application/octet-stream;charset=utf-16le;base64,$content")
        ..setAttribute("download", filename)
        ..click();
    } else {
      final snackBar = SnackBar(
        content: Text('Houve um erro ao fazer o download. Tente novamente!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cadastro de exame/atestado'),
        ),
        body:
        Center(
          child: Container(
            padding: const EdgeInsets.all(9.0),
            width: 350.0,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: lista.map((String data) {
                  return ElevatedButton(
                    child: Text(data),
                    onPressed: () {
                      _download(context, data);
                    },
                  );
                  // ElevatedButton(
                  //   child: Text(data),
                  //   onPressed: () {
                  //     print(data);
                  //   },
                  // );
                }).toList(),

            )
          ),
        )
    );
  }
}