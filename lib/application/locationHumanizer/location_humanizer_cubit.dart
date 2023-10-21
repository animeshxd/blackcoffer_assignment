import 'package:blackcoffer_assignment/repository/reverse_geocode_client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

part 'location_humanizer_state.dart';

class LocationHumanizerCubit extends Cubit<LocationHumanizerState> {
  LocationHumanizerCubit(this.client) : super(LocationHumanizerInitial());

  final ReverseGeocodeClient client;

  void invoke(Position position) async {
    emit(LocationHumanizerLoading());
    var result = await client.postionReverse(XPosition.fromPosition(position));
    
    emit(LocationHumanizerLoaded(result: result));
  }
}
