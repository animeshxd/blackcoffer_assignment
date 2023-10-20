part of 'locations_cubit.dart';

sealed class LocationsState extends Equatable {
  const LocationsState();

  @override
  List<Object> get props => [];
}

final class LocationsInitial extends LocationsState {}
final class LocationsProcessing extends LocationsState {}

final class LocationPermanentlyDisabled extends LocationsState {}
final class LocationAskPermission extends LocationsState {}
final class LocationAskEnableService extends LocationsState {}
final class LocationGetSuccess extends LocationsState {
  final Position position;
  const LocationGetSuccess({required this.position});
}
