import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:postakodubul/loading_page.dart';
import 'package:postakodubul/sehirler_page.dart';

void main() => runApp(PostaKoduBulApp());

class PostaKoduBulApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posta Kodu Bul',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('sehirler').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return LoadingPage();
            default:
              return SehirlerPage(sehirlerDocuments: snapshot.data.documents);
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  void _incrementCounter() {
    /* Firestore.instance.collection('sehirler').getDocuments().then((onValue) {
      onValue.documents.forEach((f) {
        print(f.data);
      });
    }); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Şehirler"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('sehirler').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return new ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return new ListTile(
                    title: new Text(document['sehir']),
                  );
                }).toList(),
              );
          }
        },
      ),
    );
  }
}
