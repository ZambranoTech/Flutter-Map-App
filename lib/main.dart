import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/presentation/bloc/blocs.dart';
import 'package:maps_app/presentation/screens/screens.dart';
import 'package:maps_app/shared/services/services.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => GpsBloc(),),
      BlocProvider(create: (context) => LocationBloc(),),
      BlocProvider(create: (context) => MapBloc(BlocProvider.of<LocationBloc>(context)),),
      BlocProvider(create: (context) => SearchBloc(trafficService: TrafficService()),),
    ], 
    child: const MapsApp()
  ));
}

class MapsApp extends StatelessWidget {
  const MapsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingScreen()
    );
  }
}
