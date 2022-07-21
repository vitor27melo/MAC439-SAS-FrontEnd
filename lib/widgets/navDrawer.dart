import 'package:flutter/material.dart';
import '../main.dart' as mainPage;
import '../globals.dart' as globals;
import '../examList.dart' as examList;
import '../observationList.dart' as observationList;
import '../courseSchedule.dart' as courseSchedule;


class NavDrawer extends StatefulWidget {
  NavDrawerPage createState()=> NavDrawerPage();
}

class NavDrawerPage extends State<NavDrawer>{
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text(
              '',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/usp.png'))),
          ),
          ListTile(
            leading: Icon(Icons.line_weight),
            title: Text('Grade Horária'),
            onTap: () => {
              Navigator.of(context).pop(),
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const courseSchedule.CourseSchedulePage()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.line_weight),
            title: Text('Meus exames/certificados'),
            onTap: () => {
              Navigator.of(context).pop(),
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const examList.ExamListPage()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.line_weight_rounded),
            title: Text('Minhas observações/reclamações'),
            onTap: () => {
              Navigator.of(context).pop(),
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const observationList.ObservationListPage()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sair'),
            onTap: () => {
              setState(() {
                globals.usuarioLogado = false;
                globals.token = '';
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => mainPage.MyApp()), // this mymainpage is your page to refresh
                      (Route<dynamic> route) => false,
                );
              }),

            },
          ),
        ],
      ),
    );
  }
}