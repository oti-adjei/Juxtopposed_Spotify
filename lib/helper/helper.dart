import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

Future<Color> getDominantColor(String assetPath) async {
  // Load the image as a byte array
  ByteData imageData = await rootBundle.load(assetPath);
  Uint8List values = imageData.buffer.asUint8List(); // Correct conversion

  // Decode the image
  img.Image? image = img.decodeImage(values);
  if (image == null) throw Exception("Image decoding failed!");

  // Calculate the average color
  int red = 0, green = 0, blue = 0, count = 0;
  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      int pixel = image.getPixel(x, y); // Ensure getPixel returns an int
      // Explicitly cast to int
      red += img.getRed(pixel);
      green += img.getGreen(pixel);
      blue += img.getBlue(pixel);
      count++;
    }
  }

  return Color.fromARGB(255, red ~/ count, green ~/ count, blue ~/ count);
}
