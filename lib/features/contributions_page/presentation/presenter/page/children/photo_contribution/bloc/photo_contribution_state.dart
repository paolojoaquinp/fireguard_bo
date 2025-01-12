part of 'photo_contribution_bloc.dart';

sealed class PhotoContributionState extends Equatable {
  const PhotoContributionState();
  
  @override
  List<Object> get props => [];
}

final class PhotoContributionInitial extends PhotoContributionState {}

final class PhotoContributionLoading extends PhotoContributionState {}

final class PhotoContributionNoPermission extends PhotoContributionState {}

final class PhotoContributionFailure extends PhotoContributionState {
  final String error;

  const PhotoContributionFailure(this.error);

  @override
  List<Object> get props => [error];
}

final class PhotoContributionSuccess extends PhotoContributionState {
  final List<AssetEntity> photos;
  final AssetEntity? selectedPhoto;

  const PhotoContributionSuccess({
    required this.photos,
    this.selectedPhoto,
  });

  PhotoContributionSuccess copyWith({
    List<AssetEntity>? photos,
    AssetEntity? selectedPhoto,
  }) {
    return PhotoContributionSuccess(
      photos: photos ?? this.photos,
      selectedPhoto: selectedPhoto ?? this.selectedPhoto,
    );
  }

  @override
  List<Object> get props => [photos, if (selectedPhoto != null) selectedPhoto!];
}

final class PhotoContributionCameraInitializing extends PhotoContributionState {}

class PhotoContributionCameraReady extends PhotoContributionState {
  final CameraController controller;

  const PhotoContributionCameraReady(this.controller);

  @override
  List<Object> get props => [controller];
}

final class PhotoContributionPhotoTaken extends PhotoContributionState {
  final String photoPath;

  const PhotoContributionPhotoTaken(this.photoPath);

  @override
  List<Object> get props => [photoPath];
}