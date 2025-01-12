part of 'photo_contribution_bloc.dart';

sealed class PhotoContributionEvent extends Equatable {
  const PhotoContributionEvent();

  @override
  List<Object> get props => [];
}

final class LoadGalleryPhotos extends PhotoContributionEvent {}

final class RequestGalleryPermission extends PhotoContributionEvent {}

final class SelectGalleryPhoto extends PhotoContributionEvent {
  final AssetEntity photo;

  const SelectGalleryPhoto(this.photo);

  @override
  List<Object> get props => [photo];
}

final class ClearSelectedPhoto extends PhotoContributionEvent {}

final class SubmitPhoto extends PhotoContributionEvent {
  final AssetEntity photo;

  const SubmitPhoto(this.photo);

  @override
  List<Object> get props => [photo];
}