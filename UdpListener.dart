import 'dart:convert';
import 'dart:io';
import 'dart:async';

class UDPListener {
  static List deviceaddress = new List();
  static startListen(Function listener(List<String> data)) {
    RawDatagramSocket.bind(InternetAddress.ANY_IP_V4, 6666)
        .asStream()
        .listen((socket) {
      print('UDP Echo ready to receive');
      // print('${socket.address.address}:${socket.port}');
      socket.listen((RawSocketEvent e) {
        Datagram d = socket.receive();
        if (d == null) return;
        print(d.address.address);
        String message = new String.fromCharCodes(d.data);
        List<String> segmentedValue = message.split(',');
        print("data: ${segmentedValue}");
        listener(segmentedValue);
      });
    });
  }

  static getIPListener(Function listener(List<String> ipList)) {
    List<String> data = new List<String>();
    int i = 0;
    RawDatagramSocket.bind(InternetAddress.anyIPv4, 6666)
        .asStream()
        .listen((socket) {
      socket.listen((RawSocketEvent event) {
        Datagram device = socket.receive();
        if (device == null) return;
        String message = new String.fromCharCodes(device.data);
        List<String> _m = message.split(',');
        String type = _m[0] == "01" ? "BB" : "TB";
        String value = device.address.address.toString() + " : " + type;
        // String value = device.address.address.toString();
        // UDPListener.useTCP(value,(data){});
        int length = data.length;
        if (!(data.contains(value))) {
          data.add(value);
        }
        if (data.length == length && i > 10) {
          socket.close();
        }
        print(data);
        i++;
        listener(data);
      });
    });
  }

  static useTCP(String socketS) {
    // Sstring address = new
    try {
      Socket.connect(socketS, 5100).then((socket) {
        print("connected");
        socket.listen((event) {
          String value = utf8.decode(event);
          print(value);
          print("----------");
	  print("Masukkan data");
	  var message = stdin.readLineSync();
	  socket.add(utf8.encode(message));
        });
        print("----------");
	  print("Masukkan data");
	  var message = stdin.readLineSync();
	  socket.add(utf8.encode(message));
      });
    } catch (e) {
      print("cant connected");
    }
  }
}

main() {
//   UDPListener.getIPListener((data) {
//     print(data);
//   });
	UDPListener.useTCP("192.168.1.7");
}

