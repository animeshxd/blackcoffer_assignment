import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../repository/reverse_geocode_client.dart';

part 'location_humanizer_state.dart';

class LocationHumanizerCubit extends Cubit<LocationHumanizerState> {
  LocationHumanizerCubit(this.client) : super(LocationHumanizerInitial());

  final ReverseGeocodeClient client;

  void invoke(Position position) async {
    emit(LocationHumanizerLoading());

    try {
      var result =
          await client.postionReverse(XPosition.fromPosition(position));
      emit(LocationHumanizerLoaded(result: result));
    } catch (_) {
      return emit(LocationHumanizerFailed());
    }
  }
}
