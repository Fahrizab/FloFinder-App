import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartplant/page/Info.dart';

class Huminfo extends StatefulWidget {
  Huminfo({Key? key}) : super(key: key);

  @override
  State<Huminfo> createState() => _HuminfoState();
}

class _HuminfoState extends State<Huminfo> {
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
          'Kelembapan Tanah',
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
                'Kelembaban tanah seara definisi yaitu jumlah air yang tersimpan diantara pori - pori tanah. Kelembaban tanah ini dapat memberikan peranan yang sangat penting dalam pertanian, dimana akan menentukan ketersedian air dalam tanah bagi pertumbuhan tanaman. Terdapat beberapa faktor yang menentukan kelembaban tanah antara lain curah hujan dan jenis tanah. ',
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
    home: Huminfo(),
  ));
}
