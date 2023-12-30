import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/config/helpers/helpers.dart';
import 'package:maps_app/presentation/bloc/blocs.dart';

class ManualMarker extends StatelessWidget {
  const ManualMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {

        return state.displayManualMarker 
        ? const _ManualMarkerBody()
        : const SizedBox();

      },
    );
  }
}

class _ManualMarkerBody extends StatelessWidget {
  const _ManualMarkerBody();

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height,
      child:  Stack(
        children: [

          const Positioned(
            top: 70,
            left: 20,
            child: _BtnBack()
          ),

          Transform.translate(
            offset: const Offset(0, -22),
            child: Center(
              child: BounceInDown(from: 100, child: const Icon(Icons.location_on_rounded, size: 60,)),
            ),
          ),

          // Boton de confirmar
          Positioned(
            bottom: 70,
            left: 40,
            child: FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: FilledButton(
                onPressed: () async {
                  final searchBloc = context.read<SearchBloc>();
                  final locationBloc = context.read<LocationBloc>();
                  final mapBloc = context.read<MapBloc>();

                  // TODO: loading

                  final start = locationBloc.state.lastKnownLocation;
                  if (start == null) return;
                  final end = mapBloc.mapCenter;
                  if (end == null) return;

                  final destination = await searchBloc.getCoorsStartToEnd(start, end);


                  if (context.mounted) showLoadingMessage(context);
                  
                  await mapBloc.drawRoutePolyline(destination).then(
                    (value) {
                      searchBloc.add(DesactivateManualMarker());
                      Navigator.pop(context);
                    }
                  );
                  

                }, 
                style: ButtonStyle(
                  minimumSize:  MaterialStatePropertyAll(Size(size.width -120, 50)),
                  backgroundColor: const MaterialStatePropertyAll(Colors.black)
                ),
                child: const Text('Confirmar destino', style: TextStyle(fontWeight: FontWeight.w300),),
                
              ),
            )
          )


        ],
      ),
    );
  }
}

class _BtnBack extends StatelessWidget {
  const _BtnBack();

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 300),
      child: FloatingActionButton(
        onPressed: () => context.read<SearchBloc>().add(DesactivateManualMarker()),
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
        elevation: 0,
        child: const Icon(Icons.arrow_back_ios),
      ),
    );
  }
}