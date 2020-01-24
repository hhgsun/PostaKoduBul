import 'package:flutter/material.dart';
import 'package:postakodubul/mahalleler_page.dart';

class IlcelerPage extends StatefulWidget {
  IlcelerPage({Key key, this.secilenSehir, this.ilceler, this.mahalleler})
      : super(key: key);

  final String secilenSehir;
  final List<Map> ilceler;
  final List<Map> mahalleler;

  @override
  _IlcelerPageState createState() => _IlcelerPageState();
}

class _IlcelerPageState extends State<IlcelerPage> {
  List<Map> ilceListesi = [];

  @override
  void initState() {
    widget.ilceler.forEach((f) {
      if (f['il'] == widget.secilenSehir) {
        ilceListesi.add(f);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.secilenSehir),
      ),
      body: ListView(
        children: ilceListesi.map((Map document) {
          return new ListTile(
            title: new Text(document['ilce']),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MahallelerPage(
                    secilenIlce: {
                      'ilce': document['ilce'],
                      'il': widget.secilenSehir
                    },
                    mahalleler: widget.mahalleler,
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
