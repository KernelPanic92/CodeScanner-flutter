import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

extension CameraImageToInputImage on CameraImage {
  Uint8List getBytes() {
    final allBytes = WriteBuffer();
    for (final Plane plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  InputImage toInputImage(CameraDescription camera) {
    final totalBytesPerRow = planes.fold(
      0,
      (totalBytesPerRow, plane) => totalBytesPerRow + plane.bytesPerRow,
    );

    final inputImageData = InputImageMetadata(
      size: Size(width.toDouble(), height.toDouble()),
      rotation:
          InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
              InputImageRotation.rotation0deg,
      format: InputImageFormatValue.fromRawValue(format.raw) ??
          InputImageFormat.nv21,
      bytesPerRow: totalBytesPerRow,
    );
    return InputImage.fromBytes(bytes: getBytes(), metadata: inputImageData);
  }
}

class CameraImageData {
  final CameraImage image;
  final CameraDescription description;
  CameraImageData(this.image, this.description);
}

/*
TODO: -= Image Crop =- (To prevent the scanner to scan too many pixels)

extension InputImageCrop on InputImage {
  InputImage crop(int x, int y, int width, int height) {
    final croppedData = InputImageData(
      size: inputImageData!.size,
      imageRotation: inputImageData!.imageRotation,
      inputImageFormat: inputImageData!.inputImageFormat,
      planeData: inputImageData!.planeData!.map((InputImagePlaneMetadata planeData) => InputImagePlaneMetadata(
        bytesPerRow: width * planeData.bytesPerRow ~/ planeData.width!,
        height: height,
        width: width,
      )).toList(),
    );
    
    final croppedBytes = Uint8List.fromList(bytes!.map((byte) => byte).toList());
    
    return InputImage.fromBytes(
      bytes: croppedBytes,
      inputImageData: croppedData,
    );
  }
}
*/
