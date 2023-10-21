part of 'location_humanizer_cubit.dart';

sealed class LocationHumanizerState extends Equatable {
  @override
  List<Object> get props => [];
  const LocationHumanizerState();
}

final class LocationHumanizerInitial extends LocationHumanizerState {}

final class LocationHumanizerLoading extends LocationHumanizerState {}
final class LocationHumanizerFailed extends LocationHumanizerState {}

final class LocationHumanizerLoaded extends LocationHumanizerState {
  final String result;

  const LocationHumanizerLoaded({required this.result});
}
