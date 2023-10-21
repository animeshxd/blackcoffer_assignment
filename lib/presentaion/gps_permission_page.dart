import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../application/location_cubit/locations_cubit.dart';
import 'consts.dart';
import 'widgets/main_app_body.dart';
import 'widgets/rounded_elevated_button.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: mainThemeData,
      home: BlocProvider(
        create: (context) => LocationsCubit(),
        child: const GPSPermissionPage(),
      ),
    );
  }
}

class GPSPermissionPage extends StatelessWidget {
  const GPSPermissionPage({super.key});
  static const path = '/gps';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MainAppBody(
        body: BlocConsumer<LocationsCubit, LocationsState>(
          builder: (context, state) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: RoundedElevatedTextButton(
                  text: 'Allow GPS Permisson',
                  onPressed: () => onAllowGPSPermissionRequested(context),
                ),
              ),
            );
          },
          listener: (context, state) {
            var messenger = ScaffoldMessenger.maybeOf(context);
            if (state is LocationGetSuccess) {
              Navigator.of(context).pop(state.position);
            }
            if (state is LocationGetSuccess) return;
            var snackbarContent = switch (state) {
              LocationPermanentlyDisabled() => 'Unable to determine location',
              LocationAskPermission() => 'Please Allow GPS Permission',
              LocationAskEnableService() => 'Please enable location service',
              LocationGetSuccess(position: var position) =>
                'Location $position',
              LocationsProcessing() => 'Checking location',
              _ => 'Unknown location'
            };
            messenger?.showSnackBar(SnackBar(content: Text(snackbarContent)));
          },
        ),
      ),
    );
  }

  void onAllowGPSPermissionRequested(BuildContext context) =>
      context.read<LocationsCubit>().askPermission();
}
