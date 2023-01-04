import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:socket_io_client/socket_io_client.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double value = 5.0;
  late Socket socket;

  socket_io() {
    print("socket_io called");
    socket = io(
        'http://192.168.227.122:3000',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .setExtraHeaders({'foo': 'bar'}) // optional
            .build());

    socket.on('ack', (data) => print('data: $data'));

    socket.onError((data) => print('socket error; $data'));
    socket.connect();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socket_io();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    socket.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: RatingStars(
            value: value,
            onValueChanged: (v) {
              setState(() {
                value = v;
                Map<String, dynamic> ratingData = Map();
                ratingData['user_id'] = 1;
                ratingData['rating'] = v;

                socket.emit('submit-rating', jsonEncode(ratingData));

                print('socket submit');
              });
            },
            starBuilder: (index, color) => Icon(
              Icons.star,
              color: color,
            ),
            starCount: 5,
            starSize: 50,
            valueLabelColor: const Color(0xff9b9b9b),
            valueLabelTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 12.0),
            valueLabelRadius: 10,
            maxValue: 5,
            starSpacing: 5,
            maxValueVisibility: true,
            valueLabelVisibility: true,
            animationDuration: Duration(milliseconds: 500),
            valueLabelPadding:
            const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
            valueLabelMargin: const EdgeInsets.only(right: 8),
            starOffColor: const Color(0xffe7e8ea),
            starColor: Colors.yellow,
          ),
        ),
      ),
    );
  }
}
