// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class studentDashboard extends StatefulWidget {
  const studentDashboard({super.key});

  @override
  State<studentDashboard> createState() => _studentDashboardState();
}

class _studentDashboardState extends State<studentDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "IIUM ERRAND RUNNER",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 8, 164, 92),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Dashboard', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Container(
                width: 400,
                height: 400,
                color: Color.fromARGB(255, 8, 164, 92),
                // This one for inside the containers
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                      Container(
                        height: 150,
                        width: 150,
                        color: Colors.white,
                        child: Text('Assign Errand'),
                      ),
                      Container(
                        height: 150,
                        width: 150,
                        color: Colors.white,
                        child: Text('Errand Progress'),
                      )
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          color: Colors.white,
                          child: Text('Apply as runner'),
                        ),
                        Container(
                          height: 150,
                          width: 150,
                          color: Colors.white,
                          child: Text('Personal Information'),
                        )
                      ],
                    )
                  ],
                )),
          ),
          Text('Notifications', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          Container(
            width: 300,
            color: Color.fromARGB(255, 8, 196, 236),
            child: Text(
              'Yay! We have found you a runner. Check "Errand Progress" to check status',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
