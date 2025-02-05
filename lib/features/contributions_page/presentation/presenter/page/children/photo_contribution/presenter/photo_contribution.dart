import 'package:fireguard_bo/features/contributions_page/presentation/presenter/page/children/photo_contribution/bloc/photo_contribution_bloc.dart';
import 'package:fireguard_bo/features/contributions_page/presentation/presenter/page/children/photo_contribution/presenter/widgets/loaded_gallery_photo_contribution.dart';
import 'package:fireguard_bo/features/contributions_page/presentation/presenter/page/children/photo_contribution/presenter/widgets/preview_photo_contribution.dart';
import 'package:fireguard_bo/features/contributions_page/presentation/presenter/page/children/photo_contribution/presenter/widgets/camera_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        if (state is PhotoContributionCameraInitializing ||
            state is PhotoContributionInitial ||
            state is PhotoContributionLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is PhotoContributionNoPermission) {
          return const Center(
            child: Text('WE must need permissions of gallery'),
          );
        }
        if (state is PhotoContributionFailure) {
          return Center(
            child: Text(state.error),
          );
        }
        if (state is PhotoContributionCameraReady) {
          return CameraView(controller: state.controller);
        }
        if (state is PhotoContributionPhotoPicked) {
          return PreviewPhotoContribution(photoPath: state.photoPath);
        }
        if (state is PhotoContributionSuccess) {
          return LoadedGalleryPhotoContribution(photos: state.photos);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
