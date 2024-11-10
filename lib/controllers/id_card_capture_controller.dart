import 'package:get/get.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';

class IdCardCaptureController extends GetxController {
  late DocumentScanner documentScanner;
  RxList<String> documentFront = <String>[].obs;
  RxList<String> documentBack = <String>[].obs;
  RxBool isLoadingFront = false.obs;
  RxBool isLoadingBack = false.obs;

  DocumentScannerOptions documentOptions = DocumentScannerOptions(
    documentFormat: DocumentFormat.jpeg, // set output document format
    mode: ScannerMode.full, // to control what features are enabled
    pageLimit: 1, // setting a limit to the number of pages scanned
    isGalleryImport: true, // importing from the photo gallery
  );

  @override
  void onInit() {
    // TODO: implement onInit
    documentScanner = DocumentScanner(options: documentOptions);
    super.onInit();
  }

  void scanFront() async {
    isLoadingFront.value = true;
    documentFront.value = await scan();
    isLoadingFront.value = false;
  }

  void scanBack() async {
    isLoadingBack.value = true;
    documentBack.value = await scan();
    isLoadingBack.value = false;
  }

  Future<List<String>> scan() async {
    //print('starting scan');
    List<String> images = [];
    try {
      DocumentScanningResult result = await documentScanner.scanDocument();
      print('result=$result');
      //final pdf = result.pdf; // A PDF object.
      images = result.images; // A list with the paths to the images.
      //print(images);
    } on Exception catch (e) {
      // TODO
      print(e);
    }
    return images;
  }

  void clearFrontScan() {
    documentFront.clear();
  }

  void clearBackScan() {
    documentBack.clear();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    documentFront.clear();
    documentBack.clear();
    isLoadingFront.value = false;
    isLoadingBack.value = false;
    super.dispose();
  }
}
