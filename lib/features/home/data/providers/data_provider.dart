import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_time_watchlist/features/home/data/repo/database_service.dart';

final dataService = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

final liveDataProvider = FutureProvider.family<double, String>((ref, instrumentName) async {
  final databaseService = ref.watch(dataService);

  return databaseService.getLiveData(instrumentName);
});

final dayHighProvider = FutureProvider.family<double, String>((ref, instrumentName) async {
  final databaseService = ref.watch(dataService);
  final instrument = await databaseService.getData(instrumentName);
  return instrument.maxPrice;
});