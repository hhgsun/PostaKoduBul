import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:postakodubul/loading_page.dart';
import 'package:postakodubul/mahalleler_page.dart';

class IlcelerPage extends StatefulWidget {
  IlcelerPage({Key key, this.secilenSehir}) : super(key: key);

  final Map<String, dynamic> secilenSehir;

  @override
  _IlcelerPageState createState() => _IlcelerPageState();
}

class _IlcelerPageState extends State<IlcelerPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.secilenSehir['sehir']),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('ilceler')
            .where('sehirKey', isEqualTo: widget.secilenSehir['sehirKey'])
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
                    title: new Text(document['ilce']),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MahallelerPage(
                            secilenIlce: {
                              'ilce': document['ilce'],
                              'ilceKey': document.documentID
                            },
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
          }
        },
      ),
    );
  }
}
