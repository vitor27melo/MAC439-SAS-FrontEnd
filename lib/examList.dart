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
  List<int>? _selectedFile;
  Uint8List? _bytesData;

  String naturezaArquivo = 'Exame';
  String nomeArquivo = '';
  DateTime selectedDate = DateTime.now();

  final obsController = TextEditingController();


  @override
  void dispose() {
    obsController.dispose();
    super.dispose();
  }

  Future<void> _download(BuildContext context) async {
    final file = File("teste.pdf");

    var url = Uri.parse('http://localhost:1323/user/download-file');
    var request = http.MultipartRequest("GET", url);

    request.headers['Access-Control_Allow_Origin'] = '*';
    request.headers['Authorization'] = "Bearer ${globals.token}";


    var response = await request.send();
    if(response.statusCode == 200) {

      Uint8List data = await response.stream.toBytes();

      final content = base64Encode(data);
      final anchor = webFile.AnchorElement(
          href: "data:application/octet-stream;charset=utf-16le;base64,$content")
        ..setAttribute("download", "file.jpg")
        ..click();

      // var dir = await getApplicationDocumentsDirectory();
      // print(dir);

      // final file = File('banana.jpg');
      // file.writeAsBytes(data).asStream();
      // print(data);
      // var blob = webFile.Blob(data, 'image/jpeg', 'native');
      // print(blob);
      // var anchorElement = webFile.AnchorElement(
      //   href: webFile.Url.createObjectUrlFromBlob(blob).toString(),
      // )..setAttribute("download", "teste.jpg")..click();

      // html.File file = await File('./image.pdf').create();
      // file.writeAsBytesSync(data);

      // print(data);
      // var sysFile = File('file.pdf');
      // sysFile.writeAsBytes(data);
      //
      // print(response);
      // print(response.contentLength);
      // print(response.stream);
      // var file = File('teste.pdf');
      // var sink = file.openWrite();
      // await response.stream.pipe(sink);
      // sink.close();


      final snackBar = SnackBar(
        content: Text('Documento cadastrado com sucesso!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        content: Text('Houve um erro ao cadastrar o documento. Tente novamente!'),
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
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () => _download(context),
                    child: Text('Download'),
                  ),
                ]
            )
          ),
        )
    );
  }
}