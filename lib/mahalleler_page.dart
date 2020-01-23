import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:postakodubul/loading_page.dart';

class MahallelerPage extends StatefulWidget {
  MahallelerPage({Key key, this.secilenIlce}) : super(key: key);

  final Map<String, dynamic> secilenIlce;

  @override
  _MahallelerPageState createState() => _MahallelerPageState();
}

class _MahallelerPageState extends State<MahallelerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.secilenIlce['ilce']),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('mahalleler')
            .where('ilceKey', isEqualTo: widget.secilenIlce['ilceKey'])
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Hata: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return LoadingPage();
            default:
              return new ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return new ListTile(
                    title: new Text(document['mahalle']),
                    subtitle: new Text(document['postaKodu']),
                  );
                }).toList(),
              );
          }
        },
      ),
    );
  }
}
