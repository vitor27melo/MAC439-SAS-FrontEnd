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


class ObservationListPage extends StatefulWidget {
  const ObservationListPage({Key? key}) : super(key: key);

  @override
  State<ObservationListPage> createState() => _ObservationListPageState();
}


class _ObservationListPageState extends State<ObservationListPage> {
  List<int> index_list = [];
  List<dynamic> lista = [];

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

    print(response.statusCode);
    print(response.body);
    lista = jsonDecode(response.body);
    print(globals.cpf);

    for (var i = 0; i < lista.length; i++) {
      if (lista[i]['cpf'] == globals.cpf && (lista[i]['documento']['natureza'] == 'Reclamação' || lista[i]['documento']['natureza'] == 'Observação')) {
        index_list.insert(0, i);
      }
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

  String _nomeArquivo(index) {
    if (lista[index]["documento"]["anexo"]["tipo"] != "") {
      return lista[index]["documento"]["anexo"]["conteudo"].split("-filebegin-")[1];
    } else {
      return "";
    }
  }

  String _naturezaArquivo(index) {
    return "Natureza: " + lista[index]["documento"]["natureza"];
  }

  String _dataArquivo(index) {
    return "Data: " + lista[index]["data"].split(" ")[0];
  }

  String _obsArquivo(index) {
    return "Descrição: " + lista[index]["documento"]["obs"];
  }

  bool _possuiArquivo(index) {
    return lista[index]["documento"]["anexo"]["tipo"] != "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lista de observações/reclamações'),
        ),
        body:SingleChildScrollView(
        child:
        Center(
          child: Container(
            padding: const EdgeInsets.all(9.0),
            width: 350.0,
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
                            _nomeArquivo(index),
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                            ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                            "Status: em análise"
                        ),const SizedBox(height: 15),
                        Text(
                            _naturezaArquivo(index)
                        ),
                        const SizedBox(height: 15),
                        Text(
                            _dataArquivo(index)
                        ),
                        const SizedBox(height: 15),
                        Text(
                            _obsArquivo(index)
                        ),
                        const SizedBox(height: 15),
                        _possuiArquivo(index) ? ElevatedButton(
                          child: Text("Baixar"),
                          onPressed: () {
                            _download(context, index);
                          },
                        ) : Text(""),
                        const SizedBox(height: 40),
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