import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartplant/page/Info.dart';

class pHinfo extends StatefulWidget {
  pHinfo({Key? key}) : super(key: key);

  @override
  State<pHinfo> createState() => _pHinfoState();
}

class _pHinfoState extends State<pHinfo> {
  void _exitApp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => infodata()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'pH Tanah',
          style: TextStyle(
            color: Color(0xFF205C35),
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: _exitApp,
          child: Container(
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/icons/Arrow - Left 2.svg',
              height: 20,
              width: 20,
            ),
            decoration: BoxDecoration(
              color: Color(0xFFF7F8F8),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.lightGreenAccent.withOpacity(0.5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInfoCard(
                'pH Tanah adalah sebuah parameter penting dalam pengukuran kandungan tanah berupa tingkat keasaman dan juga kebasaan tanah, skala pH antara 0 - 14, yang mana semakin rendah maka tanah semakin asam dan jika nilai semakin tinggi maka tanah semakin basa. Tingkat pH tanah ini berefek pada tingkat nutrisi dan zat kimia terlarut pada tanah. Biasanya jumlah nutrisi dan zat terlarut pada tanah paling banyak di pH netral rentang 5,5 - 7,5',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String text) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: pHinfo(),
  ));
}
