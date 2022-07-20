import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({Key? key}) : super(key: key);

  @override
  State<ExamPage> createState() => _ExamRegisterPageState();
}


class _ExamRegisterPageState extends State<ExamPage> {
  String dropdownValue = 'Exame';

  final obsController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    obsController.dispose();
    super.dispose();
  }

  Future<void> _selectFile(BuildContext context) async {
    if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        print('-=-----=');
        print(result.files);
      }

    }
    else if (defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS || defaultTargetPlatform == TargetPlatform.windows) {
      // Some desktop specific code there
    }
    else {
      // Some web specific code there
    }
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
        body:
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
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    underline: Container(
                      height: 2,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
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
                    onPressed: () => _selectFile(context),
                    child: Text('Upload'),
                  ),
                ]
            )
          ),
        )
    );
  }
}