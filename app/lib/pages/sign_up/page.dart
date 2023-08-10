import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hookshot_app/pages/sign_up/bloc.dart';
import 'package:hookshot_app/pages/sign_up/event.dart';
import 'package:hookshot_app/pages/sign_up/state.dart';
import 'package:hookshot_app/repositories/account_repository.dart';
import 'package:hookshot_app/router.dart';
import 'package:hookshot_ui/hookshot_ui.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(
        context.read<AccountRepository>(),
      )..add(SignUpStarted()),
      child: const SignUpView(),
    );
  }
}

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  var _name = '';
  var _email = '';
  var _password = '';

  void _handleStateChange(BuildContext context, SignUpState state) {
    switch (state) {
      case SignUpFailure():
        ErrorDialog.show(context, state.error);
      case SignUpSuccess():
        context.goNamed(Routes.home.name);
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: _handleStateChange,
      child: Padding(
        padding: const EdgeInsets.all(Spacing.extraLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildForm(context),
            const SizedBox(height: Spacing.medium),
            _buildSignInButton(context),
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
            _buildNameField(context),
            const SizedBox(height: Spacing.medium),
            _buildEmailField(context),
            const SizedBox(height: Spacing.medium),
            _buildPasswordField(context),
            const SizedBox(height: Spacing.medium),
            _buildSignUpButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField(BuildContext context) {
    return TextField.name(
      label: 'Name',
      onChanged: (value) => _name = value,
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

  Widget _buildSignUpButton(BuildContext context) {
    final bloc = context.watch<SignUpBloc>();
    return IndexedStack(
      alignment: Alignment.center,
      sizing: StackFit.passthrough,
      index: bloc.state is SignUpLoading ? 1 : 0,
      children: [
        PrimaryButton(
          label: 'Sign up',
          onTap: () => bloc.add(SignUpSubmitted(_name, _email, _password)),
        ),
        _buildLoadingLabel(context),
      ],
    );
  }

  Widget _buildLoadingLabel(BuildContext context) {
    return const Text(
      'Signing up...',
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: FontSize.medium,
        color: Colors.black,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return LinkButton(
      label: 'Have an account? Sign in',
      onTap: () => context.goNamed(Routes.signIn.name),
    );
  }
}
