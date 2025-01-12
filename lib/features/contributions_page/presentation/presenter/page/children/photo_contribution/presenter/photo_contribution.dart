import 'dart:io';
import 'dart:typed_data';

import 'package:fireguard_bo/features/contributions_page/presentation/presenter/page/children/photo_contribution/bloc/photo_contribution_bloc.dart';
import 'package:fireguard_bo/features/contributions_page/presentation/presenter/page/widgets/camera_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoContribution extends StatelessWidget {
  const PhotoContribution({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PhotoContributionBloc>(
      create: (_) => PhotoContributionBloc()..add(RequestGalleryPermission()),
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoContributionBloc, PhotoContributionState>(
      builder: (context, state) {
        if (state is PhotoContributionCameraInitializing) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is PhotoContributionCameraReady) {
          return CameraView(controller: state.controller);
        }
        if (state is PhotoContributionInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is PhotoContributionLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is PhotoContributionNoPermission) {
          return const Text('WE must need permissions of gallery');
        }
        if (state is PhotoContributionFailure) {
          return const Center(
              child: const Text('WE must need permissions of gallery'));
        }
        if (state is PhotoContributionFailure) {
          return Center(child: Text(state.error));
        }
        if (state is PhotoContributionPhotoTaken) {
          return Center(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.5,
              child: Image.file(File(state.photoPath)),
            ),
          );
        }
        if (state is PhotoContributionSuccess) {
          return SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close,
                          size: 24,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Update the Map',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                // Submit a Photo Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.35,
                    height: MediaQuery.sizeOf(context).width * 0.35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5FFE5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Submit a\nPhoto',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Photo Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: state.photos.length +
                        1, // Número de imágenes + botón de cámara
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return GestureDetector(
                          onTap: () {
                            context
                                .read<PhotoContributionBloc>()
                                .add(InitializeCamera());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        );
                      }
                      final AssetEntity elem = state.photos[index - 1];
                      return FutureBuilder<Uint8List?>(
                        future: elem.thumbnailDataWithSize(
                          const ThumbnailSize(
                              200, 200), // Tamaño de la miniatura
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError || snapshot.data == null) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.red,
                                  size: 24,
                                ),
                              ),
                            );
                          }

                          return GestureDetector(
                            onTap: () {
                              // Lógica para seleccionar esta foto
                              context.read<PhotoContributionBloc>().add(
                                    SelectGalleryPhoto(elem),
                                  );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[300],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
