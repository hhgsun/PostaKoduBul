import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:postakodubul/ilceler_page.dart';

class SehirlerPage extends StatefulWidget {
  SehirlerPage({Key key, this.sehirlerDocuments}) : super(key: key);

  final List<DocumentSnapshot> sehirlerDocuments;

  @override
  _SehirlerPageState createState() => _SehirlerPageState();
}

class _SehirlerPageState extends State<SehirlerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Şehir Seçiniz'),
      ),
      body: new ListView(
        children: widget.sehirlerDocuments.map((DocumentSnapshot document) {
          return new ListTile(
            title: new Text(document['sehir']),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => IlcelerPage(
                    secilenSehir: {
                      'sehir': document['sehir'],
                      'sehirKey': document.documentID
                    },
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
