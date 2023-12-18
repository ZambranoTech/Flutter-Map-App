import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/presentation/bloc/blocs.dart';

class GpsAccessScreen extends StatelessWidget {
  const GpsAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:  BlocBuilder<GpsBloc, GpsState>(
          builder: (context, state) {
            print(state);
            return (state.isGpsEnable)
            ? _AccessButton()
            : _EnableGpsMessage();
          },)
        // _AccessButton()
      ),
    );
  }
}

class _AccessButton extends StatelessWidget {
  const _AccessButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Es necesario el acceso al GPS'),
        FilledButton.tonal(onPressed: () => context.read<GpsBloc>().askGpsAccess(), child: Text('Solicitar acceso'))
      ],
    );
  }
}

class _EnableGpsMessage extends StatelessWidget {
  const _EnableGpsMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text('Debe de habilitar el GPS', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),);
  }
}