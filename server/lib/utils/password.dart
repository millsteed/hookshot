import 'dart:convert';
import 'dart:typed_data';

import 'package:hookshot_server/utils/uuid.dart';
import 'package:pointycastle/key_derivators/argon2_native_int_impl.dart';
import 'package:pointycastle/pointycastle.dart';

const _delimiter = r'$';

const _types = ['argon2d', 'argon2i', 'argon2id'];

String hashPassword(String password) {
  final parameters = Argon2Parameters(
    Argon2Parameters.DEFAULT_TYPE,
    base64Decode(uuid.v4().replaceAll('-', '')),
    desiredKeyLength: 24,
  );
  return _hashPassword(parameters, password);
}

String _hashPassword(Argon2Parameters parameters, String password) {
  final type = _types[parameters.type];
  final algorithmParameters = {
    'v': parameters.version,
  }.entries.map((e) => '${e.key}=${e.value}').join(',');
  final hashParameters = {
    'm': parameters.memory,
    't': parameters.iterations,
    'p': parameters.lanes,
  }.entries.map((e) => '${e.key}=${e.value}').join(',');
  final derivator = Argon2BytesGenerator()..init(parameters);
  final hash = derivator.process(Uint8List.fromList(password.codeUnits));
  return '$_delimiter${[
    type,
    algorithmParameters,
    hashParameters,
    base64Encode(parameters.salt),
    base64Encode(hash),
  ].join(_delimiter)}';
}

bool verifyPassword(String password, String hash) {
  final parameters = _decodeHash(hash);
  return _hashPassword(parameters, password) == hash;
}

Argon2Parameters _decodeHash(String hash) {
  final parts = hash.split(r'$');
  if (parts[0].isNotEmpty) {
    throw Exception();
  }
  final type = _types.indexOf(parts[1]);
  final algorithmParameters = _parseParameters(parts[2]);
  final version = int.parse(algorithmParameters['v']!);
  final hashParameters = _parseParameters(parts[3]);
  final memory = int.parse(hashParameters['m']!);
  final iterations = int.parse(hashParameters['t']!);
  final lanes = int.parse(hashParameters['p']!);
  final salt = base64Decode(parts[4]);
  final desiredKeyLength = base64Decode(parts[5]).length;
  return Argon2Parameters(
    type,
    salt,
    version: version,
    memory: memory,
    iterations: iterations,
    lanes: lanes,
    desiredKeyLength: desiredKeyLength,
  );
}

Map<String, String> _parseParameters(String parameters) {
  return Map.fromEntries(
    parameters
        .split(',')
        .map((e) => MapEntry(e.split('=').first, e.split('=').last)),
  );
}
