import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/presentation/bloc/gps_bloc/gps_bloc.dart';
import 'package:maps_app/presentation/screens/screens.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => GpsBloc(),)
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
