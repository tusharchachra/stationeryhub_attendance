import 'package:get/get.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';

class IdCardCaptureController extends GetxController {
  late DocumentScanner documentScanner;
  List<String>? documents;

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

  void scan() async {
    //print('starting scan');
    DocumentScanningResult result = await documentScanner.scanDocument();
    //final pdf = result.pdf; // A PDF object.
    final images = result.images; // A list with the paths to the images.
    //print(images);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
