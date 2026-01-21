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

    return supabase
        .from('users_watchlist')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId) // ✅ user_id, not email
        .asyncMap((watchlistRows) async {
          // ✅ Extract STOCK IDs (not watchlist row IDs)
          final stockIds = watchlistRows
              .map((row) => row['stock_id'])
              .where((id) => id != null)
              .toList();

          if (stockIds.isEmpty) {
            return <InstrumentModel>[];
          }

          // Fetch stock details
          final response = await supabase
              .from('stocks')
              .select()
              .inFilter('id', stockIds);

          return response
              .map<InstrumentModel>((map) => InstrumentModel.fromMap(map))
              .toList();
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

  //   }
  //   throw Exception('Data not found');
  // }

  // double getLiveData(String instrumentName) {
  //   InstrumentModel instrument = DummyData.firstWhere(
  //       (inst) => inst.name.toLowerCase() == instrumentName.toLowerCase(),
  //       orElse: () => throw Exception('Instrument not found'));
  //   // Simulate live data by returning a random price within the min and max range
  //   final random = Random();
  //   double livePrice =
  //       instrument.minPrice +
  //       random.nextDouble() * (instrument.maxPrice - instrument.minPrice);
  //   print('Live price for $instrumentName: $livePrice');
  //   return livePrice;
  // }
}
