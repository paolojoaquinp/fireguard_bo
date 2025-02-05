import 'package:camera/camera.dart';
import 'package:fireguard_bo/features/contributions_page/presentation/presenter/page/children/photo_contribution/bloc/photo_contribution_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraView extends StatelessWidget {
  final CameraController controller;

  const CameraView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(controller),
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    context.read<PhotoContributionBloc>().add(CloseCamera());
                  },
                ),
                FloatingActionButton(
                  onPressed: () {
                    context.read<PhotoContributionBloc>().add(TakePhoto());
                  },
                  child: const Icon(Icons.camera),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}