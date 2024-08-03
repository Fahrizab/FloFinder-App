import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smartplant/models/info_model.dart';
import 'package:smartplant/page/EC.dart';
import 'package:smartplant/page/Hum.dart';
import 'package:smartplant/page/Suhu.dart';
import 'package:smartplant/page/pH.dart';
import 'home.dart';

class infodata extends StatefulWidget {
  infodata({Key? key}) : super(key: key);

  @override
  State<infodata> createState() => _infodataState();
}

class _infodataState extends State<infodata> {
  List<infoModel> fitur = [];

  void _getInitialInfo() {
    fitur = infoModel.getinfoModel();
  }

  @override
  Widget build(BuildContext context) {
    _getInitialInfo();
    return Scaffold(
      appBar: AppBarinfo(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.lightGreenAccent.withOpacity(0.5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: [
            infofitur(),
          ],
        ),
      ),
    );
  }

  Column infofitur() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 22),
        ),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: fitur.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: GestureDetector(
                  onTap: () {
                    _handleFeatureTap(index);
                  },
                  child: Container(
                    height: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SvgPicture.asset(
                          item.iconpath,
                          width: 25,
                          height: 25,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.nama,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontSize: 18),
                            )
                          ],
                        ),
                        SvgPicture.asset(
                          'assets/icons/button.svg',
                          width: 30,
                          height: 30,
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: item.boxIsSelected
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: item.boxIsSelected
                          ? [
                              BoxShadow(
                                color: Color(0xff1D1617).withOpacity(0.07),
                                offset: Offset(0, 10),
                                blurRadius: 40,
                                spreadRadius: 0,
                              )
                            ]
                          : [],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  AppBar AppBarinfo(BuildContext context) {
    return AppBar(
      title: Text(
        'INFORMASI',
        style: TextStyle(
            color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => HomePage()));
        },
        child: Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/icons/Arrow - Left 2.svg',
            height: 20,
            width: 20,
          ),
          decoration: BoxDecoration(
              color: Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  void _handleFeatureTap(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => pHinfo(),
          ),
        );
        break;
      case 1:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => Suhuinfo(),
          ),
        );
        break;
      case 2:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => Huminfo(),
          ),
        );
        break;
      case 3:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => ECinfo(),
          ),
        );
        break;
    }
  }
}
