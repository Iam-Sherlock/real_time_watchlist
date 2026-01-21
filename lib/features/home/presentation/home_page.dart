import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_time_watchlist/features/home/data/providers/data_provider.dart';
import 'package:real_time_watchlist/features/home/data/repo/database_service.dart';
import 'package:real_time_watchlist/features/home/data/repo/dummy_data.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    // DatabaseService().getData('');
    // _startTimer();
    super.initState();
  }

  // void _startTimer() {
  //   Timer.periodic(Duration(seconds: 3), (timer) {
  //     setState(() {
  //       DatabaseService().getLiveData('Silver');
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final stockAsync = ref.watch(liveDataProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('RealTime Watchlist'),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {
              context.push('/watchlist');
            },
          ),
        ],
      ),
      body: stockAsync.when(
        data: (stocks) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: (stocks.isEmpty)
                  ? Center(child: Text('No Data Available'))
                  : ListView.builder(
                      itemCount: stocks.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            '${index + 1}) ${stocks[index].name.toUpperCase()}',
                          ),
                          subtitle: Text(
                            'Price: ${stocks[index].price} Day High: ${stocks[index].dayHigh} DayLow: ${stocks[index].dayLow}  ',
                          ),
                          onLongPress: () async {
                            try {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Adding to watchlist...'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                              await ref
                                  .read(dataService)
                                  .addToWatchlist(stocks[index].id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Added to watchlist successfully',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to add: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                        );
                      },
                    ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: $error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  ref.refresh(liveDataProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
