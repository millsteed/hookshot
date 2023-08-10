import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hookshot_app/pages/sign_in/bloc.dart';
import 'package:hookshot_app/pages/sign_in/event.dart';
import 'package:hookshot_app/pages/sign_in/state.dart';
import 'package:hookshot_app/repositories/account_repository.dart';
import 'package:hookshot_app/router.dart';
import 'package:hookshot_ui/hookshot_ui.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInBloc(
        context.read<AccountRepository>(),
      )..add(SignInStarted()),
      child: const SignInView(),
    );
  }
}

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  var _email = '';
  var _password = '';

  void _handleStateChange(BuildContext context, SignInState state) {
    switch (state) {
      case SignInFailure():
        ErrorDialog.show(context, state.error);
      case SignInSuccess():
        context.goNamed(Routes.home.name);
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: _handleStateChange,
      child: Padding(
        padding: const EdgeInsets.all(Spacing.extraLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildForm(context),
            const SizedBox(height: Spacing.medium),
            _buildSignUpButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.gray50),
          borderRadius: BorderRadius.circular(Radius.extraLarge),
        ),
        padding: const EdgeInsets.all(Spacing.extraLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const HookshotLogo.medium(),
            const SizedBox(height: Spacing.extraLarge),
            _buildEmailField(context),
            const SizedBox(height: Spacing.medium),
            _buildPasswordField(context),
            const SizedBox(height: Spacing.medium),
            _buildSignInButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return TextField.email(
      label: 'Email',
      onChanged: (value) => _email = value,
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return TextField.password(
      label: 'Password',
      onChanged: (value) => _password = value,
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    final bloc = context.watch<SignInBloc>();
    return IndexedStack(
      alignment: Alignment.center,
      sizing: StackFit.passthrough,
      index: bloc.state is SignInLoading ? 1 : 0,
      children: [
        PrimaryButton(
          label: 'Sign in',
          onTap: () => bloc.add(SignInSubmitted(_email, _password)),
        ),
        _buildLoadingLabel(context),
      ],
    );
  }

  Widget _buildLoadingLabel(BuildContext context) {
    return const Text(
      'Signing in...',
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: FontSize.medium,
        color: Colors.black,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return LinkButton(
      label: 'Need an account? Sign up',
      onTap: () => context.goNamed(Routes.signUp.name),
    );
  }
}
