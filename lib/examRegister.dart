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

class ExamPage extends StatefulWidget {
  const ExamPage({Key? key}) : super(key: key);

  @override
  State<ExamPage> createState() => _ExamRegisterPageState();
}


class _ExamRegisterPageState extends State<ExamPage> {
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

  Future<void> _register(BuildContext context) async {
    if (_selectedFile == null) {
      final snackBar = SnackBar(
        content: Text('É necessário anexar um documento!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    var url = Uri.parse(globals.api + '/user/upload-file');
    var request = http.MultipartRequest("POST", url);

    request.headers['Access-Control_Allow_Origin'] = '*';
    request.headers['Authorization'] = "Bearer ${globals.token}";

    request.fields['attachmentType'] = naturezaArquivo;
    request.fields['date'] = selectedDate.toString();
    request.fields['obs'] = obsController.text;
    request.files.add(await http.MultipartFile.fromBytes('file', _selectedFile!,
        contentType: new MediaType('application', 'octet-stream'),
        filename: nomeArquivo)
    );

    request.send().then((response) {
      if (response.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop();
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
    });
  }

  startWebFilePicker() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      nomeArquivo = uploadInput.files![0].name;
      final files = uploadInput.files;
      final file = files![0];
      final reader = new html.FileReader();

      reader.onLoadEnd.listen((e) {
        _handleResult(reader.result!);
      });
      reader.readAsDataUrl(file);
    });
  }

  void _handleResult(Object result) {
    setState(() {
      _bytesData = Base64Decoder().convert(result.toString().split(",").last);
      _selectedFile = _bytesData;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cadastro de exame/atestado'),
        ),
        body:SingleChildScrollView(
        child:
        Center(
          child: Container(
            padding: const EdgeInsets.all(9.0),
            width: 350.0,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(right: 0.0),
                    child: Text(
                      "Natureza",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.green
                      ),
                    ),
                  ),
                  DropdownButton<String>(
                    value: naturezaArquivo,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    underline: Container(
                      height: 2,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        naturezaArquivo = newValue!;
                      });
                    },
                    items: <String>['Exame', 'Atestado', 'Comprovante']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 50.0,),
                  const Padding(
                    padding: EdgeInsets.only(right: 0.0),
                    child: Text(
                      "Data do documento",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.green
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0,),
                  OutlinedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Selecione'),
                  ),
                  SizedBox(height: 5.0,),
                  Text("${selectedDate.toLocal()}".split(' ')[0]),
                  const SizedBox(height: 50.0,),
                  const Padding(
                    padding: EdgeInsets.only(right: 0.0),
                    child: Text(
                      "Observações",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.green
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: obsController,
                    maxLines: 5
                  ),
                  SizedBox(height: 50.0,),
                  const Padding(
                    padding: EdgeInsets.only(right: 0.0),
                    child: Text(
                      "Anexo",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.green
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0,),
                  OutlinedButton(
                    onPressed: () => startWebFilePicker(),
                    child: Text('Upload'),
                  ),
                  SizedBox(height: 5.0,),
                  Text("${nomeArquivo}"),
                  SizedBox(height: 40.0,),
                  OutlinedButton(
                    onPressed: () => _register(context),
                    child: Text('Cadastrar'),
                  ),
                ]
            )
          ),
        )
    )
    );
  }
}