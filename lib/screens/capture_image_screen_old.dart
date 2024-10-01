import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_dashboard.dart';

class CaptureImageScreenOld extends StatefulWidget {
  const CaptureImageScreenOld({super.key});

  @override
  State<CaptureImageScreenOld> createState() => _CaptureImageScreenOldState();
}

class _CaptureImageScreenOldState extends State<CaptureImageScreenOld> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _mediaFileList;
  dynamic _pickImageError;
  String? _retrieveDataError;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScaffoldDashboard(
        isLoading: false,
        pageTitle: Text('Image'),
        bodyWidget: Center(
          child: Center(),
        ));
  }

  /* @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  isLoading: false,
      // pageTitle: 'Capture Image',
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final XFile? photo =
              await _picker.pickImage(source: ImageSource.camera);
          //_onImageButtonPressed(ImageSource.camera, context: context);
        },
        child: Text(
          'Click',
          style: Get.textTheme.displayMedium,
        ),
      ),
      body: Center(
        child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
            ? FutureBuilder<void>(
                future: retrieveLostData(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Text(
                        'You have not yet picked an image.',
                        textAlign: TextAlign.center,
                        style: Get.textTheme.displayLarge,
                      );
                    case ConnectionState.done:
                      return _handlePreview();
                    case ConnectionState.active:
                      if (snapshot.hasError) {
                        return Text(
                          'Pick image/video error: ${snapshot.error}}',
                          style: Get.textTheme.displayLarge,
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return Text(
                          'You have not yet picked an image.',
                          style: Get.textTheme.displayLarge,
                          textAlign: TextAlign.center,
                        );
                      }
                  }
                },
              )
            : _handlePreview(),
      ),
    );
  }
*/
  Future<void> _onImageButtonPressed(
    ImageSource source, {
    required BuildContext context,
    bool isMultiImage = false,
    bool isMedia = false,
  }) async {
    if (context.mounted) {
      if (isMedia) {
        await _displayPickImageDialog(context, false, (double? maxWidth,
            double? maxHeight, int? quality, int? limit) async {
          try {
            final List<XFile> pickedFileList = <XFile>[];
            final XFile? media = await _picker.pickMedia(
              maxWidth: 100,
              maxHeight: 100,
              imageQuality: quality,
            );
            if (media != null) {
              pickedFileList.add(media);
              setState(() {
                _mediaFileList = pickedFileList;
              });
            }
          } catch (e) {
            setState(() {
              _pickImageError = e;
            });
          }
        });
      } else {
        await _displayPickImageDialog(context, false, (double? maxWidth,
            double? maxHeight, int? quality, int? limit) async {
          try {
            final XFile? pickedFile = await _picker.pickImage(
              source: source,
              maxWidth: 300,
              maxHeight: 300,
              imageQuality: quality,
            );
            setState(() {
              _setImageFileListFromFile(pickedFile);
            });
          } catch (e) {
            setState(() {
              _pickImageError = e;
            });
          }
        });
      }
    }
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, bool isMulti, OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add optional parameters'),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text('PICK'),
                  onPressed: () {
                    onPick;
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  Widget _handlePreview() {
    {
      return _previewImages();
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      {
        setState(() {
          if (response.files == null) {
            _setImageFileListFromFile(response.file);
          } else {
            _mediaFileList = response.files;
          }
        });
      }
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  void _setImageFileListFromFile(XFile? value) {
    _mediaFileList = value == null ? null : <XFile>[value];
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_mediaFileList != null) {
      return Semantics(
        label: 'image_picker_example_picked_images',
        child: ListView.builder(
          key: UniqueKey(),
          itemBuilder: (BuildContext context, int index) {
            final String? mime = lookupMimeType(_mediaFileList![index].path);

            // Why network for web?
            // See https://pub.dev/packages/image_picker_for_web#limitations-on-the-web-platform
            return Semantics(
              label: 'image_picker_example_picked_image',
              child: kIsWeb
                  ? Image.network(_mediaFileList![index].path)
                  /*: (mime == null || mime.startsWith('image/')
                      ?*/
                  : Image.file(
                      File(_mediaFileList![index].path),
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return const Center(
                            child: Text('This image type is not supported'));
                      },
                    ) /*: (_buildInlineVideoPlayer(index)))*/,
            );
          },
          itemCount: _mediaFileList!.length,
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality, int? limit);
