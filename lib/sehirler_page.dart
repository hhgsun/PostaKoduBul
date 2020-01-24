import 'package:flutter/material.dart';
import 'package:postakodubul/ilceler_page.dart';

class SehirlerPage extends StatefulWidget {
  SehirlerPage({Key key, this.sehirler, this.ilceler, this.mahalleler})
      : super(key: key);

  final List<String> sehirler;
  final List<Map> ilceler;
  final List<Map> mahalleler;

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
        children: widget.sehirler.map((String sehir) {
          return new ListTile(
            title: new Text(sehir),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => IlcelerPage(secilenSehir: sehir, ilceler: widget.ilceler, mahalleler: widget.mahalleler),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
