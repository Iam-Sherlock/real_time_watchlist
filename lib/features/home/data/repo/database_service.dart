import 'dart:math';

import 'package:real_time_watchlist/features/home/data/repo/dummy_data.dart';
import 'package:real_time_watchlist/features/home/domain/models/instrument_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<InstrumentModel> getData(String instrumentName) async {
    final collection = FirebaseFirestore.instance.collection('instruments');
    final docSnapshot = await collection.doc().get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      print(data.toString());
      return InstrumentModel.fromMap(data);
    }
    throw Exception('Data not found');
  }

  double getLiveData(String instrumentName){
    InstrumentModel instrument = DummyData.firstWhere(
        (inst) => inst.name.toLowerCase() == instrumentName.toLowerCase(),
        orElse: () => throw Exception('Instrument not found'));
    // Simulate live data by returning a random price within the min and max range
    final random = Random();
    double livePrice =
        instrument.minPrice +
        random.nextDouble() * (instrument.maxPrice - instrument.minPrice);
    print('Live price for $instrumentName: $livePrice');
    return livePrice;
  }

  
}
