import 'package:camera/camera.dart';
import 'package:fireguard_bo/core/helpers/camera_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:photo_manager/photo_manager.dart';

part 'photo_contribution_event.dart';
part 'photo_contribution_state.dart';

class PhotoContributionBloc extends Bloc<PhotoContributionEvent, PhotoContributionState> {
  PhotoContributionBloc() : super(PhotoContributionInitial()) {
    on<LoadGalleryPhotos>(_onLoadGalleryPhotos);
    on<RequestGalleryPermission>(_onRequestPermission);
    on<SelectGalleryPhoto>(_onSelectPhoto);
    on<ClearSelectedPhoto>(_onClearSelectedPhoto);
    on<SubmitPhoto>(_onSubmitPhoto);

    on<InitializeCamera>(_onInitializeCamera);
    on<TakePhoto>(_onTakePhoto);
    on<CloseCamera>(_onCloseCamera);
  }

  final _cameraHelper = CameraHelper();


  Future<void> _onLoadGalleryPhotos(
    LoadGalleryPhotos event,
    Emitter<PhotoContributionState> emit,
  ) async {
    try {
      emit(PhotoContributionLoading());

      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );

      if (albums.isEmpty) {
        emit(const PhotoContributionSuccess(photos: []));
        return;
      }

      final recentAlbum = albums.first;
      final assets = await recentAlbum.getAssetListRange(
        start: 0,
        end: 10, // Limitar a 100 fotos para mejor rendimiento
      );

      emit(PhotoContributionSuccess(photos: assets));
    } catch (error) {
      emit(PhotoContributionFailure(error.toString()));
    }
  }

  Future<void> _onRequestPermission(
    RequestGalleryPermission event,
    Emitter<PhotoContributionState> emit,
  ) async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend(
      requestOption: const PermissionRequestOption(
        androidPermission:
            AndroidPermission(type: RequestType.image, mediaLocation: true),
      ),
    );
    
    if (ps.isAuth) {
      add(LoadGalleryPhotos());
    } else {
      emit(PhotoContributionNoPermission());
    }
  }

  Future<void> _onSelectPhoto(
    SelectGalleryPhoto event,
    Emitter<PhotoContributionState> emit,
  ) async {
    if (state is PhotoContributionSuccess) {
      final currentState = state as PhotoContributionSuccess;
      emit(currentState.copyWith(selectedPhoto: event.photo));
    }
  }

  void _onClearSelectedPhoto(
    ClearSelectedPhoto event,
    Emitter<PhotoContributionState> emit,
  ) {
    if (state is PhotoContributionSuccess) {
      final currentState = state as PhotoContributionSuccess;
      emit(currentState.copyWith(selectedPhoto: null));
    }
  }

  Future<void> _onSubmitPhoto(
    SubmitPhoto event,
    Emitter<PhotoContributionState> emit,
  ) async {
    try {
      emit(PhotoContributionLoading());
      
      final file = await event.photo.file;
      if (file != null) {
        // Aquí implementarías la lógica para subir la foto
        // Por ejemplo:
        // await photoRepository.uploadPhoto(file);
        
        // Una vez subida, podrías volver al estado de éxito
        if (state is PhotoContributionSuccess) {
          final currentState = state as PhotoContributionSuccess;
          emit(currentState.copyWith(selectedPhoto: null));
        }
      }
    } catch (error) {
      emit(PhotoContributionFailure(error.toString()));
    }
  }

   Future<void> _onInitializeCamera(
    InitializeCamera event,
    Emitter<PhotoContributionState> emit,
  ) async {
    try {
      emit(PhotoContributionCameraInitializing());
      
      await _cameraHelper.initialize();
      
      if (_cameraHelper.isInitialized) {
        emit(PhotoContributionCameraReady(_cameraHelper.controller!));
      } else {
        emit(const PhotoContributionFailure('Failed to initialize camera'));
      }
    } catch (error) {
      emit(PhotoContributionFailure(error.toString()));
    }
  }

  Future<void> _onTakePhoto(
    TakePhoto event,
    Emitter<PhotoContributionState> emit,
  ) async {
    try {
      emit(PhotoContributionLoading());
      
      final photoPath = await _cameraHelper.takePhoto();
      
      if (photoPath != null) {
        emit(PhotoContributionPhotoTaken(photoPath));
      } else {
        emit(const PhotoContributionFailure('Failed to take photo'));
      }
    } catch (error) {
      emit(PhotoContributionFailure(error.toString()));
    }
  }

  Future<void> _onCloseCamera(
    CloseCamera event,
    Emitter<PhotoContributionState> emit,
  ) async {
    _cameraHelper.dispose();
    emit(PhotoContributionInitial());
  }

  @override
  Future<void> close() {
    _cameraHelper.dispose();
    return super.close();
  }
}