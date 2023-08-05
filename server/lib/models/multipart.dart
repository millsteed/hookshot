import 'dart:typed_data';

import 'package:shelf/shelf.dart';
import 'package:shelf_multipart/form_data.dart';

class MultipartForm {
  MultipartForm(this.fields, this.files);

  final Map<String, String> fields;
  final List<MultipartFile> files;
}

class MultipartFile {
  MultipartFile(this.contentType, this.filename, this.data);

  final String contentType;
  final String? filename;
  final Uint8List data;
}

extension RequestToMultipart on Request {
  Future<MultipartForm> toMultipartForm() async {
    final fields = <String, String>{};
    final files = <MultipartFile>[];
    await for (final formData in multipartFormData) {
      final contentType = formData.part.headers['Content-Type'];
      if (contentType == null) {
        fields[formData.name] = await formData.part.readString();
      } else {
        final data = await formData.part.readBytes();
        files.add(MultipartFile(contentType, formData.filename, data));
      }
    }
    return MultipartForm(fields, files);
  }
}
