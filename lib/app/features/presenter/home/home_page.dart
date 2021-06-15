import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Modular.get<HomeController>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('APOD'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 50.0,
            ),
            child: Text(
              'Welcome to Astronomy Picture of the Day!',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: MaterialButton(
                minWidth: size.width * 0.5,
                height: size.height * 0.065,
                color: Colors.indigoAccent,
                child: Text(
                  'SELECT DATETIME',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                onPressed: () => controller.selectData(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
