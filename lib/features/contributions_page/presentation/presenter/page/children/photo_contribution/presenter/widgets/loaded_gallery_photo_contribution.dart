import 'dart:typed_data';

import 'package:fireguard_bo/features/contributions_page/presentation/presenter/page/children/photo_contribution/bloc/photo_contribution_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

class LoadedGalleryPhotoContribution extends StatelessWidget {
  const LoadedGalleryPhotoContribution({
    super.key,
    required this.photos,
  });

  final List<AssetEntity> photos;

  @override
  Widget build(BuildContext context) {
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: photos.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _goToCameraButton(context);
                }
                final AssetEntity elem = photos[index - 1];
                return FutureBuilder<Uint8List?>(
                  future: elem.thumbnailDataWithSize(
                    const ThumbnailSize(
                      200,
                      200,
                    ),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError || snapshot.data == null) {
                      return _errorImageOnLoadWidget();
                    }
                    return GestureDetector(
                      onTap: () {
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
  }

  Container _errorImageOnLoadWidget() {
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

  Widget _goToCameraButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<PhotoContributionBloc>().add(InitializeCamera());
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
}
