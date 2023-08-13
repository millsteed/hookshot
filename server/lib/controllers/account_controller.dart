import 'dart:convert';

import 'package:hookshot_protocol/hookshot_protocol.dart';
import 'package:hookshot_server/repositories/user_repository.dart';
import 'package:shelf/shelf.dart';

class AccountController {
  AccountController(this.userRepository);

  final UserRepository userRepository;

  Future<Response> handleSignUp(Request request) async {
    final body = await request.readAsString();
    final SignUpRequest data;
    try {
      data = SignUpRequest.fromJson(body.toJson());
    } on Exception {
      return Response.badRequest(body: 'Failed to parse request body.');
    }
    if (data.name.isEmpty) {
      return Response.badRequest(body: 'Name cannot be empty.');
    }
    if (data.email.isEmpty) {
      return Response.badRequest(body: 'Email cannot be empty.');
    }
    if (data.password.length < 8) {
      return Response.badRequest(
        body: 'Password must be at least 8 characters.',
      );
    }
    final existingUser = await userRepository.getUserWithEmail(
      email: data.email,
    );
    if (existingUser != null) {
      return Response.badRequest(body: 'Email is already taken.');
    }
    final user = await userRepository.createUser(
      name: data.name,
      email: data.email,
      password: data.password,
    );
    final sessionToken = await userRepository.createSession(userId: user.id);
    final response = SignUpResponse(user: user, sessionToken: sessionToken);
    return Response.ok(jsonEncode(response));
  }

  Future<Response> handleSignIn(Request request) async {
    final body = await request.readAsString();
    final SignInRequest data;
    try {
      data = SignInRequest.fromJson(body.toJson());
    } on Exception {
      return Response.badRequest(body: 'Failed to parse request body.');
    }
    if (data.email.isEmpty) {
      return Response.badRequest(body: 'Email cannot be empty.');
    }
    if (data.password.isEmpty) {
      return Response.badRequest(body: 'Password cannot be empty.');
    }
    final user = await userRepository.getUserWithEmail(email: data.email);
    if (user == null) {
      return Response.badRequest(body: 'Invalid email or password.');
    }
    final isPasswordValid = await userRepository.checkPassword(
      userId: user.id,
      password: data.password,
    );
    if (!isPasswordValid) {
      return Response.badRequest(body: 'Invalid email or password.');
    }
    final sessionToken = await userRepository.createSession(userId: user.id);
    final response = SignUpResponse(user: user, sessionToken: sessionToken);
    return Response.ok(jsonEncode(response));
  }
}
