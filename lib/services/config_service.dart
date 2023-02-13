import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ConfigService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/phone.txt');
  }

  Future<File> writePhone(String phone) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(phone);
  }

  Future<String> readPhone() async {
    try {
      final file = await _localFile;
      // Read the file
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      // If encountering an error, return empty
      // Default value
      writePhone("08001114357");
      return '';
    }
  }
}
