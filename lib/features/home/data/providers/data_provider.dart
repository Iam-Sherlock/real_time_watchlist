import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_time_watchlist/features/home/data/repo/database_service.dart';
import 'package:real_time_watchlist/features/home/domain/models/instrument_model.dart';

final dataService = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

final liveDataProvider = StreamProvider<List<InstrumentModel>>((ref) {
  final databaseService = ref.watch(dataService);
  return databaseService.getLiveData();
});

// final addToWatchlistProvider = FutureProvider.family<void, int>((ref, productId) async {
//   final databaseService = ref.watch(dataService);
//   return databaseService.addToWatchlist(productId);
// });

final removeFromWatchlistProvider = FutureProvider.family<void, int>((
  ref,
  productId,
) async {
  final databaseService = ref.watch(dataService);
  return databaseService.removeFromWatchlist(productId);
});

final watchlistDataProvider = StreamProvider<List<InstrumentModel>>((ref) {
  final databaseService = ref.watch(dataService);
  return databaseService.getWatchlistLiveData();
});

final addToWatchlistProvider = FutureProvider.family<void, int>((
  ref,
  productId,
) async {
  final databaseService = ref.watch(dataService);
  return databaseService.addToWatchlist(productId);
});

// final dayHighProvider = Provider<double>((ref) {
//   final databaseService = ref.watch(dataService);
//   return databaseService.dayHigh.value;
// });

// final dayLowProvider = Provider<double>((ref) {
//   final databaseService = ref.watch(dataService);
//   return databaseService.dayLow.value;
// });

// final dayHighProvider = FutureProvider.family<double, String>((ref, instrumentName) async {
//   final databaseService = ref.watch(dataService);
//   final instrument = await databaseService.getData(instrumentName);
//   return instrument.maxPrice;
// });
