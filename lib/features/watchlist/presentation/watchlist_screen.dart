import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_time_watchlist/features/home/data/providers/data_provider.dart';

class WatchlistScreen extends ConsumerStatefulWidget {
  const WatchlistScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WatchlistScreenState();
}

class _WatchlistScreenState extends ConsumerState<WatchlistScreen> {
  @override
  Widget build(BuildContext context) {
    final stockAsync = ref.watch(watchlistDataProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Watchlist'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              ref.refresh(watchlistDataProvider);
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
                  ? Center(
                      child: Text(
                        'No Data Available, Long Press on the Stocks to add to Watchlist',
                      ),
                    )
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
                          trailing: 
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              ref.read(removeFromWatchlistProvider(stocks[index].id));
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Removed from watchlist successfully',
                                    ),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            },
                          ),
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
                  ref.refresh(watchlistDataProvider);
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
