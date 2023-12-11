// ignore: file_names
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagein/constants/colors.dart';
import 'package:image/image.dart' as img;

class PhotoEditPage extends StatefulWidget {
  final XFile image;

  const PhotoEditPage({
    super.key,
    required this.image,
  });

  @override
  State<PhotoEditPage> createState() => _PhotoEditPageState();
}

class _PhotoEditPageState extends State<PhotoEditPage> {
  img.Image? originalImage;

  double contrastValue = 1.0;
  double initContrastValue = 1.0;
  double initBlurLevel = 0.0;
  double luminanceThreshold = 0.5; // Initial luminance threshold value
// Initial blur level
  // Initial contrast value

  @override
  void initState() {
    _loadImage();
    super.initState();
  }

  void _loadImage() async {
    final File imageFile = File(widget.image.path);
    final List<int> bytes = await imageFile.readAsBytes();

    final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
    final img.Image resized = img.copyResize(image, width: 450);

    setState(() {
      originalImage = resized;
    });
  }

  void applyLuminanceThreshold() {
    if (originalImage != null) {
      final img.Image thresholdedImage = img.luminanceThreshold(originalImage!);
      setState(() {
        originalImage = thresholdedImage;
      });
    }
  }

  void changeContrast(double value) {
    if (originalImage != null) {
      final img.Image adjustedImage =
          img.contrast(originalImage!, contrast: (value * 100).toInt());
      setState(() {
        contrastValue = value;
        originalImage = adjustedImage;
      });
    }
  }

  void invertColors() {
    if (originalImage != null) {
      final img.Image adjustedImage = img.invert(originalImage!);

      setState(() {
        originalImage = adjustedImage;
      });
    }
  }

  void applyNoiseReduction() {
    if (originalImage != null) {
      final img.Image denoisedImage = img.gaussianBlur(originalImage!,
          radius: 3); // Adjust the blur radius as needed
      setState(() {
        originalImage = denoisedImage;
      });
    }
  }

  void applyGrayscale() {
    if (originalImage != null) {
      final img.Image grayscaleImage = img.grayscale(originalImage!);
      setState(() {
        originalImage = grayscaleImage;
      });
    }
  }

  void resetChanges() {
    _loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: resetChanges,
              icon: const Icon(Icons.cached),
            ),
            IconButton(
              onPressed: () {
                applyNoiseReduction();
              },
              icon: const Icon(
                Icons.blur_on_rounded,
              ),
            ),
            IconButton(
              onPressed: () {
                applyGrayscale();
              },
              icon: const Icon(
                Icons.join_left,
              ),
            ),
            IconButton(
                onPressed: () {
                  applyLuminanceThreshold();
                },
                icon: const Icon(Icons.compare_arrows_rounded)),
            IconButton(
                onPressed: () {
                  changeContrast(150);
                },
                icon: const Icon(Icons.flaky)),
            IconButton(
                onPressed: () {
                  invertColors();
                },
                icon: const Icon(Icons.invert_colors))
          ],
        ),
        toolbarHeight: MediaQuery.of(context).size.height * 0.065,
        backgroundColor: scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: primaryColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              originalImage != null
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            image: MemoryImage(
                              Uint8List.fromList(
                                img.encodePng(originalImage!),
                              ),
                            ) // Placeholder image
                            ),
                      ),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
