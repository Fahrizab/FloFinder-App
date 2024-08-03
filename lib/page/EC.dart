import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartplant/page/Info.dart';

class ECinfo extends StatefulWidget {
  ECinfo({Key? key}) : super(key: key);

  @override
  State<ECinfo> createState() => _ECinfoState();
}

class _ECinfoState extends State<ECinfo> {
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
          'Electronic Conductivity',
          style: TextStyle(
            color: Color(0xFF205C35),
            fontSize: 20,
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
      body: SingleChildScrollView(
        // Wrap Column in SingleChildScrollView
        child: Container(
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
                  'Nilai EC tanah memiliki korelasi dengan beberapa parameter seperti kandungan air tanah, tekstur tanah, kandungan liat tanah, kapasitas tukar kation, dan kandungan bahan organik didalam tanah. Nilai EC tanah ini juga terpengaruhi dengan tingkat PH didalam tanah, tak hanya itu nilai EC tanah juga secara bersamaan memiliki korelasi dengan kadar air, kepadatan tanah dan juga kandungan pupuk N,P, dan K. Nilai EC tanah ini juga memiliki korelasi kuat terhadap hasil panen dimana tanaman yang ditanam di tingkat nilai EC yang tinggi memiliki hasil panen dan tingkat pertumbuhan yang tinggi dibanding ditanam di tanah yang memiliki nilai tingkat EC yang lebih rendah. Tingkat kesuburan dapat terlihat dari nilai EC dengan rentang salinitas rendah (< 500 mS/cm), sedang (500 – 1.250 mS/cm), dan tinggi (> 1.250 mS/cm), serta EC optimum untuk kebanyakan tanaman adalah 500 hingga 1.250 mS/cm  ',
                ),
              ],
            ),
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
    home: ECinfo(),
  ));
}
