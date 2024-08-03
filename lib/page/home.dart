import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartplant/models/fitur_model.dart';
import 'package:smartplant/page/Bluedat.dart';
import 'package:smartplant/page/Info.dart';
import 'package:smartplant/page/blueset.dart';
import 'package:smartplant/page/weather.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<fiturModel> fitur = [];

  @override
  void initState() {
    super.initState();
    _getInitialInfo();
  }

  void _getInitialInfo() {
    fitur = fiturModel.getfiturModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          _buildFiturApp(),
          SizedBox(height: 40),
          _buildLogo(), // Add the logo here
        ],
      ),
    );
  }

  Widget _buildFiturApp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 22),
          child: Text(
            'Fitur',
            style: TextStyle(
              color: Color(0xFF205C35),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
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
                    decoration: BoxDecoration(
                      color: item.boxIsSelected
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: item.boxIsSelected
                          ? [
                              BoxShadow(
                                color: Color(0xFF1D1617).withOpacity(0.07),
                                offset: Offset(0, 10),
                                blurRadius: 40,
                                spreadRadius: 0,
                              )
                            ]
                          : [],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SvgPicture.asset(
                          item.iconpath,
                          width: 65,
                          height: 65,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.nama,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF205C35),
                                fontSize: 18,
                              ),
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
                  ),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Image.asset(
          'assets/icons/FloFinder_logo.png', // Replace with the actual path to your logo
          width: 150,
          height: 150,
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'FloFinder',
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
        onTap: () {
          _exitApp();
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
            color: Color(0xFFF7F8F8),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => Blueset(),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.all(10),
            width: 37,
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/icons/bluetooth-svgrepo-com.svg',
              height: 20,
              width: 20,
            ),
            decoration: BoxDecoration(
              color: Color(0xFFF7F8F8),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        )
      ],
    );
  }

  void _handleFeatureTap(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => WhPage(),
          ),
        );
        break;
      case 1:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => Bluedat(),
          ),
        );
        break;
      case 2:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => infodata(),
          ),
        );
        break;
    }
  }

  void _exitApp() {
    SystemNavigator.pop();
  }
}
