import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartplant/page/Info.dart';

class Suhuinfo extends StatefulWidget {
  Suhuinfo({Key? key}) : super(key: key);

  @override
  State<Suhuinfo> createState() => _SuhuinfoState();
}

class _SuhuinfoState extends State<Suhuinfo> {
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
          'Suhu Tanah',
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
                'Suhu tanah dipengaruhi oleh jumlah serapan radiasi matahari oleh permukaan tanah. Oleh karena itu terdapat perbedaan suhu tanah pada siang dan malam hari. Penambahan suhu tanah akan berpengaruh terhadap penyerapan air. Semakin rendah suhu, maka sedikit air yang yang diserap oleh akar, oleh karena itu penurunan suhu tanah mendadak dapat menyebabkan kelayuan tanaman.',
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
    home: Suhuinfo(),
  ));
}
