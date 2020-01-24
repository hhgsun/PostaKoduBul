import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:postakodubul/sehirler_page.dart';

import 'loading_page.dart';

void main() => runApp(PostaKoduBulApp());

class PostaKoduBulApp extends StatefulWidget {
  @override
  _PostaKoduBulAppState createState() => _PostaKoduBulAppState();
}

class _PostaKoduBulAppState extends State<PostaKoduBulApp> {
  List<String> _sehirler = [];
  List<Map> _ilceler = [];
  List<Map> _mahalleler = [];

  Future<bool> loadAsset() async {
    return await rootBundle
        .loadString('assets/files/tumdata.json')
        .then((stack) {
      print("convert start");
      convertToList(stack);
      print("convert finish " + this._sehirler.length.toString());
      return true;
    });
  }

  void convertToList(String stack) {
    var allItems = json.decode(stack)['Sheet1'];
    for (var item in allItems) {
      String _il = item['il'].toString().trim();
      String _ilce = item['ilçe'].toString().trim();
      String _mahalle = item['Mahalle'].toString().trim();
      String _postaKodu = item['PK'].toString().trim();

      // sehir
      if (_sehirler.contains(_il) == false) {
        _sehirler.add(_il);
      }

      // ilce
      bool found = false;
      for (var ilce in _ilceler) {
        if (ilce['ilce'] == _ilce && ilce['il'] == _il) {
          found = true;
        }
      }
      if (!found) {
        _ilceler.add({'ilce': _ilce, 'il': _il});
      }

      // mahalle
      _mahalleler.add({
        'ilce': _ilce,
        'il': _il,
        'mahalle': _mahalle,
        'postaKodu': _postaKodu
      });
    }
  }

  @override
  void initState() {
    this.loadAsset();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posta Kodu Bul',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: this.loadAsset(),
        builder: (context, snapshot) {
          print(this._sehirler.length);
          if (this._sehirler.length == 0) {
            return LoadingPage();
          } else if (this._sehirler.length > 0) {
            return SehirlerPage(
                sehirler: this._sehirler,
                ilceler: this._ilceler,
                mahalleler: this._mahalleler);
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
