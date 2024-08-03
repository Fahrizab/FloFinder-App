// import 'dart:convert';
// import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';

import 'home.dart';

void main() => runApp(const Blueset());

class Blueset extends StatelessWidget {
  const Blueset({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BluetoothApp(),
    );
  }
}

class BluetoothApp extends StatefulWidget {
  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<BluetoothApp> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  BluetoothConnection? connection;

  bool get isConnected => connection != null && connection!.isConnected;

  List<BluetoothDevice> _deviceList = [];
  List<BluetoothDevice> _newDevicesList = [];
  BluetoothDevice? _device;
  BluetoothDevice? _newDevice;
  // bool _connected = false;
  // bool _isButtonUnavailable = false;
  // int _deviceState = 0;
  // String _receivedData = ''; // Variable to store received data

  @override
  void initState() {
    super.initState();
    requestPermissions();
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    enableBluetooth();

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        getPairedDevices();
      });
    });
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      if (await Permission.bluetooth.isDenied) {
        await Permission.bluetooth.request();
      }
      if (await Permission.bluetoothScan.isDenied) {
        await Permission.bluetoothScan.request();
      }
      if (await Permission.bluetoothConnect.isDenied) {
        await Permission.bluetoothConnect.request();
      }
      if (await Permission.bluetoothAdvertise.isDenied) {
        await Permission.bluetoothAdvertise.request();
      }
      if (await Permission.location.isDenied) {
        await Permission.location.request();
      }
    }
  }

  Future<void> enableBluetooth() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
    } else {
      await getPairedDevices();
    }
  }

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _deviceList = devices;
    });
  }

  Future<void> scanForDevices() async {
    setState(() {
      _newDevicesList.clear();
    });

    _bluetooth.startDiscovery().listen((r) {
      print('Discovered device: ${r.device.name} (${r.device.address})');
      setState(() {
        final device = r.device;
        if (!_deviceList.contains(device) &&
            !_newDevicesList.contains(device)) {
          _newDevicesList.add(device);
        }
      });
    }).onError((error) {
      print('Error during device discovery: $error');
    });
  }

  void pairWithNewDevice(BluetoothDevice newDevice) async {
    try {
      bool? bonded = await FlutterBluetoothSerial.instance
          .bondDeviceAtAddress(newDevice.address);
      if (bonded != null && bonded) {
        show('Paired with ${newDevice.name}');
        setState(() {
          _deviceList.add(newDevice);
          _newDevicesList.remove(newDevice);
        });
      } else {
        show('Pairing with ${newDevice.name} failed');
      }
    } catch (e) {
      print('Error pairing with device: $e');
      show('Error pairing with ${newDevice.name}');
    }
  }

  // void _connect() async {
  //   if (_device == null) {
  //     show('No device selected');
  //   } else {
  //     if (!isConnected) {
  //       await BluetoothConnection.toAddress(_device!.address)
  //           .then((_connection) {
  //         print('Connected to the device');
  //         connection = _connection;
  //         setState(() {
  //           _connected = true;
  //         });

  //         }).onDone(() {
  //           if (isConnected) {
  //             print('Disconnected remotely!');
  //           } else {
  //             print('Disconnected locally!');
  //           }
  //           if (mounted) {
  //             setState(() {});
  //           }
  //         });
  //       }).catchError((error) {
  //         print('Cannot connect, exception occurred');
  //         print(error);
  //       });
  //       show('Device connected');
  //     }
  //   }
  // }

  // void _disconnection!.input!.listen((Uint8List data) {
  //           String received = ascii.decode(data);
  //           print('Data received: $received');
  //           setState(() {
  //             _receivedData = received;
  //           });connect() async {
  //   await connection?.close();
  //   show('Device disconnected');

  //   if (!connection!.isConnected) {
  //     setState(() {
  //       _connected = false;
  //       _deviceState = 0;
  //     });
  //   }
  // }

  void show(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    if (isConnected) {
      connection?.dispose();
      connection = null;
    }
    super.dispose();
  }

  // void _sendOnMessageToBluetooth() async {
  //   connection!.output.add(Uint8List.fromList(utf8.encode("1\r\n")));
  //   await connection!.output.allSent;
  //   show('Device Turned On');
  //   setState(() {
  //     _deviceState = 1;
  //   });
  // }

  // void _sendOffMessageToBluetooth() async {
  //   connection!.output.add(Uint8List.fromList(utf8.encode("0\r\n")));
  //   await connection!.output.allSent;
  //   show('Device Turned Off');
  //   setState(() {
  //     _deviceState = -1;
  //   });
  // }

  Widget _buildDeviceList(List<BluetoothDevice> devices,
      BluetoothDevice? selectedDevice, Function(BluetoothDevice) onTap) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: devices.length,
      itemBuilder: (BuildContext context, int index) {
        BluetoothDevice device = devices[index];
        return ListTile(
          title: Text(device.name ?? device.address),
          subtitle: Text(device.address),
          onTap: () {
            onTap(device);
          },
          trailing: selectedDevice == device
              ? Icon(Icons.check, color: Colors.green)
              : null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bluetooth Setting',
          style: TextStyle(
              color: Color.fromARGB(255, 13, 2, 133),
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => HomePage()));
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _bluetoothState == BluetoothState.STATE_ON
                  ? 'Bluetooth Aktif'
                  : 'Bluetooth Tidak Aktif',
            ),
            ElevatedButton(
              onPressed: _bluetoothState == BluetoothState.STATE_ON
                  ? () async {
                      await FlutterBluetoothSerial.instance.requestDisable();
                      setState(() {});
                    }
                  : enableBluetooth,
              child: Text(
                _bluetoothState == BluetoothState.STATE_ON
                    ? 'Matikan Bluetooth'
                    : 'Aktifkan Bluetooth',
              ),
            ),
            Expanded(
              child: _buildDeviceList(_deviceList, _device, (device) {
                setState(() {
                  _device = device;
                });
              }),
            ),
            // ElevatedButton(
            //   onPressed: _isButtonUnavailable
            //       ? null
            //       : _connected
            //           ? _disconnect
            //           : _connect,
            //   child: Text(_connected ? 'Disconnect' : 'Connect'),
            // ),
            // ElevatedButton(
            //   onPressed: _connected ? _sendOnMessageToBluetooth : null,
            //   child: Text('Turn On Device'),
            // ),
            // ElevatedButton(
            //   onPressed: _connected ? _sendOffMessageToBluetooth : null,
            //   child: Text('Turn Off Device'),
            // ),
            // Text(
            //   _deviceState == 1
            //       ? 'Device is On'
            //       : _deviceState == -1
            //           ? 'Device is Off'
            //           : 'Device is Idle',
            // ),
            // SizedBox(height: 20),
            // Text('Received Data: $_receivedData'),
            ElevatedButton(
              onPressed: scanForDevices,
              child: Text('Scan for New Devices'),
            ),
            Expanded(
              child: _buildDeviceList(_newDevicesList, _newDevice, (device) {
                setState(() {
                  _newDevice = device;
                });
              }),
            ),
            ElevatedButton(
              onPressed: _newDevice != null
                  ? () {
                      pairWithNewDevice(_newDevice!);
                    }
                  : null,
              child: Text('Pair with Selected Device'),
            ),
          ],
        ),
      ),
    );
  }
}
