import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/helpers.dart';

class ImagePickerService extends GetxController {
  final cloudinary = CloudinaryPublic('duoqdpodl', 'Mudi_upload');
  final ImagePicker _picker = ImagePicker();

  Rx<XFile?> selectedImage = Rx<XFile?>(null);
  RxString selectedImagePath = ''.obs;
  RxString uploadedImageUrl = ''.obs;
  RxBool isUploading = false.obs;

  /// Pick an image from gallery
  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        selectedImage.value = pickedFile;
        selectedImagePath.value = pickedFile.path;
        uploadedImageUrl.value = ''; // Clear previous upload
      }
    } catch (e) {
      Helpers.showErrorSnackbar('Error', 'Failed to pick image: $e');
    }
  }

  /// Upload image to Cloudinary
  Future<String?> uploadImageToCloudinary() async {
    if (selectedImage.value == null) {
      Helpers.showErrorSnackbar('Error', 'Please select an image first');
      return null;
    }

    try {
      isUploading.value = true;

      final CloudinaryResponse response;
      
      if (kIsWeb) {
        // For web, read as bytes
        final bytes = await selectedImage.value!.readAsBytes();
        response = await cloudinary.uploadFile(
          CloudinaryFile.fromBytesData(
            bytes,
            identifier: selectedImage.value!.name,
            folder: 'medical_app',
            resourceType: CloudinaryResourceType.Image,
          ),
        );
      } else {
        // For mobile/desktop, use file path
        final file = File(selectedImagePath.value);
        response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            file.path,
            folder: 'medical_app',
            resourceType: CloudinaryResourceType.Image,
          ),
        );
      }

      uploadedImageUrl.value = response.secureUrl;
      Helpers.showSuccessSnackbar('Success', 'Image uploaded successfully');
      
      return response.secureUrl;
    } catch (e) {
      Helpers.showErrorSnackbar('Error', 'Failed to upload image: $e');
      return null;
    } finally {
      isUploading.value = false;
    }
  }

  /// Clear selected image
  void clearImage() {
    selectedImage.value = null;
    selectedImagePath.value = '';
    uploadedImageUrl.value = '';
  }

  /// Pick and upload image in one go
  Future<String?> pickAndUploadImage() async {
    await pickImage();
    
    if (selectedImagePath.value.isEmpty) {
      return null;
    }

    return await uploadImageToCloudinary();
  }
}
