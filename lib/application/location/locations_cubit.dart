import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

part 'locations_state.dart';

class LocationsCubit extends Cubit<LocationsState> {
  LocationsCubit() : super(LocationsInitial());

  void getLocation() async {
    emit(LocationsProcessing());
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return emit(LocationAskEnableService());

    final permission = await Geolocator.checkPermission();

    var state = switch (permission) {
      LocationPermission.denied => LocationAskPermission(),
      LocationPermission.deniedForever ||
      LocationPermission.unableToDetermine =>
        LocationPermanentlyDisabled(),
      LocationPermission.always ||
      LocationPermission.whileInUse =>
        LocationGetSuccess(
          position: await Geolocator.getCurrentPosition(),
        ),
    };
    emit(state);
  }

  void askPermission() async {
    emit(LocationsProcessing());

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return emit(LocationAskEnableService());
    final permission = await Geolocator.requestPermission();
    var state = switch (permission) {
      LocationPermission.denied => LocationAskPermission(),
      LocationPermission.deniedForever ||
      LocationPermission.unableToDetermine =>
        LocationPermanentlyDisabled(),
      LocationPermission.always ||
      LocationPermission.whileInUse =>
        LocationGetSuccess(
          position: await Geolocator.getCurrentPosition(),
        ),
    };
    emit(state);
  }
}
