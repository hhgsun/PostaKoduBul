import 'package:flutter/material.dart';

class MahallelerPage extends StatefulWidget {
  MahallelerPage({Key key, this.secilenIlce, this.mahalleler})
      : super(key: key);

  final Map<String, dynamic> secilenIlce;
  final List<Map> mahalleler;

  @override
  _MahallelerPageState createState() => _MahallelerPageState();
}

class _MahallelerPageState extends State<MahallelerPage> {
  List<Map> mahalleListesi = [];

  @override
  void initState() {
    widget.mahalleler.forEach((f) {
      if (f['ilce'] == widget.secilenIlce['ilce']) {
        mahalleListesi.add(f);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.secilenIlce['ilce']),
      ),
      body: ListView(
        children: mahalleListesi.map((Map document) {
          return new ListTile(
            title: new Text(document['mahalle']),
            subtitle: new Text(document['postaKodu']),
          );
        }).toList(),
      ),
    );
  }
}
