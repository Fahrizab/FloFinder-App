import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'home.dart';

class Bluedat extends StatefulWidget {
  const Bluedat({Key? key}) : super(key: key);

  @override
  State<Bluedat> createState() => _BluedatState();
}

class _BluedatState extends State<Bluedat> {
  BluetoothConnection? connection;
  bool isConnected = false;
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _selectedDevice;

  // State variables for sensor data
  String _rekomendasi = 'N/A';
  String _soilTemperature = 'N/A';
  String _soilMoisture = 'N/A';
  String _soilPH = 'N/A';
  String _soilEC = 'N/A';

  @override
  void initState() {
    super.initState();
    _checkBluetoothAndFetchDevices();
  }

  Future<void> _checkBluetoothAndFetchDevices() async {
    bool? isBluetoothEnabled = await FlutterBluetoothSerial.instance.isEnabled;
    if (!isBluetoothEnabled!) {
      await FlutterBluetoothSerial.instance.requestEnable();
    }
    await _getPairedDevices();
  }

  Future<void> _getPairedDevices() async {
    List<BluetoothDevice> devices = [];
    try {
      devices = await FlutterBluetoothSerial.instance.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    setState(() {
      _devicesList = devices;
    });
  }

  Future<void> _connectToBluetoothDevice(BluetoothDevice device) async {
    try {
      await BluetoothConnection.toAddress(device.address).then((_connection) {
        connection = _connection;
        isConnected = true;
        connection!.input!.listen(_onDataReceived).onDone(() {
          if (isConnected) {
            print('Disconnected remotely!');
          } else {
            print('Disconnected locally!');
          }
          if (mounted) {
            setState(() {
              isConnected = false;
            });
          }
        });
        setState(() {});
      }).catchError((error) {
        print('Cannot connect, exception occurred');
        print(error);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _onDataReceived(Uint8List data) {
    String dataString = String.fromCharCodes(data);
    List<String> values = dataString.split(',');

    if (values.length >= 5) {
      setState(() {
        _rekomendasi = values[0];
        _soilTemperature = values[1];
        _soilMoisture = values[2];
        _soilPH = values[3];
        _soilEC = ((double.tryParse(values[4]) ?? 0) * 10).toString();
      });
    }
  }

  @override
  void dispose() {
    if (isConnected) {
      connection?.dispose();
      connection = null;
    }
    super.dispose();
  }

  void _showDeviceSelectionDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Bluetooth Device'),
        content: Container(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: _devicesList.length,
            itemBuilder: (context, index) {
              BluetoothDevice device = _devicesList[index];
              return ListTile(
                title: Text(device.name ?? "Unknown Device"),
                subtitle: Text(device.address),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _selectedDevice = device;
                  });
                  _connectToBluetoothDevice(device);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _enableBluetooth() async {
    bool? isBluetoothEnabled = await FlutterBluetoothSerial.instance.isEnabled;
    if (!isBluetoothEnabled!) {
      await FlutterBluetoothSerial.instance.requestEnable();
    }
    await _getPairedDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await _enableBluetooth();
                  _showDeviceSelectionDialog();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  primary: Colors.blueAccent,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  'Select Bluetooth Device',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (_selectedDevice != null)
                Column(
                  children: [
                    Text(
                      'Connected to: ${_selectedDevice!.name ?? _selectedDevice!.address}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueGrey,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      isConnected
                          ? 'Status: Connected'
                          : 'Status: Not Connected',
                      style: TextStyle(
                        fontSize: 16,
                        color: isConnected ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 20),
              _buildRekomendasiCard('Rekomendasi Tanaman :', _rekomendasi),
              SizedBox(height: 20),
              Expanded(child: _buildSensorIndicators()),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Pengukuran Tanah',
        style: TextStyle(
          color: Color.fromARGB(255, 77, 193, 255),
          fontSize: 26,
          fontWeight: FontWeight.w900,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildRekomendasiCard(String label, String value) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white.withOpacity(0.8),
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              SizedBox(height: 10),
              Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSensorIndicators() {
    return ListView(
      children: [
        _buildLinearGaugeIndicator(
            'Suhu Tanah:', _soilTemperature, 0, 100, ' °C'),
        _buildLinearGaugeIndicator(
            'Kelembapan Tanah:', _soilMoisture, 0, 100, ' %'),
        _buildLinearGaugeIndicator('pH Tanah:', _soilPH, 3, 9),
        _buildECIndicator('EC Tanah:', _soilEC, 0, 2000, ' mS/cm'),
      ],
    );
  }

  Widget _buildLinearGaugeIndicator(
      String label, String value, double min, double max,
      [String unit = '']) {
    double valueDouble = double.tryParse(value) ?? min;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Colors.blueGrey,
              ),
            ),
            SfLinearGauge(
              minimum: min,
              maximum: max,
              interval: (max - min) / 5,
              ranges: <LinearGaugeRange>[
                LinearGaugeRange(
                  startValue: min,
                  endValue: max,
                  color: Colors.blueAccent,
                ),
              ],
              markerPointers: <LinearMarkerPointer>[
                LinearShapePointer(
                  value: valueDouble,
                  color: Colors.redAccent,
                ),
              ],
              barPointers: <LinearBarPointer>[
                LinearBarPointer(
                  value: valueDouble,
                  color: Colors.green,
                ),
              ],
              orientation: LinearGaugeOrientation.horizontal,
              axisLabelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey,
              ),
              majorTickStyle: LinearTickStyle(
                length: 10,
                color: Colors.blueGrey,
              ),
              minorTickStyle: LinearTickStyle(
                length: 5,
                color: Colors.blueGrey,
              ),
            ),
            Text(
              '$value$unit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildECIndicator(
      String label, String value, double min, double max, String unit) {
    double valueDouble = double.tryParse(value) ?? min;
    String ecClassification = _getECClassification(valueDouble);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Colors.blueGrey,
              ),
            ),
            SfLinearGauge(
              minimum: min,
              maximum: max,
              interval: (max - min) / 5,
              ranges: <LinearGaugeRange>[
                LinearGaugeRange(
                  startValue: min,
                  endValue: max,
                  color: Colors.blueAccent,
                ),
              ],
              markerPointers: <LinearMarkerPointer>[
                LinearShapePointer(
                  value: valueDouble,
                  color: Colors.redAccent,
                ),
              ],
              barPointers: <LinearBarPointer>[
                LinearBarPointer(
                  value: valueDouble,
                  color: Colors.green,
                ),
              ],
              orientation: LinearGaugeOrientation.horizontal,
              axisLabelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey,
              ),
              majorTickStyle: LinearTickStyle(
                length: 10,
                color: Colors.blueGrey,
              ),
              minorTickStyle: LinearTickStyle(
                length: 5,
                color: Colors.blueGrey,
              ),
            ),
            Text(
              '$value$unit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(
              ecClassification,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: ecClassification == 'Subur'
                    ? Colors.green
                    : Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getECClassification(double ecValue) {
    if (ecValue < 500) {
      return 'Kurang Subur';
    } else if (ecValue <= 1250) {
      return 'Subur';
    } else if (ecValue > 1760) {
      return 'Kurang Subur';
    } else {
      return 'Cukup Subur';
    }
  }
}
