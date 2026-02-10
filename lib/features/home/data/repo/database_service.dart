import 'package:real_time_watchlist/features/home/domain/models/instrument_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final supabase = Supabase.instance.client;
  // final ValueNotifier<double> dayHigh = ValueNotifier(double.minPositive);
  // final ValueNotifier<double> dayLow = ValueNotifier(double.maxFinite);

  Stream<List<InstrumentModel>> getLiveData() {
    return supabase.from('stocks').stream(primaryKey: ['id']).order('name').map(
      (maps) {
        final instruments = maps
            .map<InstrumentModel>((map) => InstrumentModel.fromMap(map))
            .toList();
        return instruments;
      },
    );
  }

  Future<void> addToWatchlist(int productId) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final userEmail = user.email;
    final userId = supabase.auth.currentUser!.id;

    print('Adding to watchlist: $userEmail, Product ID: $productId');
    final response = await supabase.from('users_watchlist').insert({
      'users': userEmail,
      'user_id': userId,
      'stock_id': productId,
    }).select();
    print('Insert response: $response');
    print('Added to watchlist successfully');
  }

  Stream<List<InstrumentModel>> getWatchlistLiveData() {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final userId = user.id;

    // Fetch stock IDs once (as a Future), then convert to stream
    final stockIdsFuture = supabase
        .from("users_watchlist")
        .select('stock_id')
        .eq('user_id', userId)
        .then((value) {
          final stockIds = value.map((map) => map['stock_id'] as int).toList();
          print('Stock IDs from watchlist: $stockIds');
          return stockIds;
        });

    // Convert the Future to a Stream and then expand it to stream stock data
    return Stream.fromFuture(stockIdsFuture).asyncExpand((stockIds) {
      if (stockIds.isEmpty) {
        print('No stocks in watchlist');
        return Stream.value(<InstrumentModel>[]);
      }

      // Stream the stock data for these IDs (live price updates)
      return supabase
          .from("stocks")
          .stream(primaryKey: ['id'])
          .inFilter('id', stockIds) // Use inFilter for multiple IDs
          .map((maps) {
            final instruments = maps
                .map<InstrumentModel>((map) => InstrumentModel.fromMap(map))
                .toList();
            print('Streaming ${instruments.length} stocks');
            return instruments;
          });
    });
  }

  Future<void> removeFromWatchlist(int productId) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final userId = user.id;
    try {
      await supabase
          .from('users_watchlist')
          .delete()
          .eq('user_id', userId)
          .eq('stock_id', productId);
    } on Exception catch (e) {
      print(e);
    }
  }
}
