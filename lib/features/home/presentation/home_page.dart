import 'dart:async';

import 'package:flutter/material.dart';
import 'package:real_time_watchlist/features/home/data/repo/database_service.dart';
import 'package:real_time_watchlist/features/home/data/repo/dummy_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    // DatabaseService().getData('');
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        DatabaseService().getLiveData('Silver');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RealTime Watchlist')),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListView.builder(
            itemCount: DummyData.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Item ${DummyData[index].name}'),
                subtitle: Text(
                  'Price: ${DatabaseService().getLiveData(DummyData[index].name)}',
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
