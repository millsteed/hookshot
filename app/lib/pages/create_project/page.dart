import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hookshot_app/pages/create_project/bloc.dart';
import 'package:hookshot_app/pages/create_project/event.dart';
import 'package:hookshot_app/pages/create_project/state.dart';
import 'package:hookshot_app/repositories/project_repository.dart';
import 'package:hookshot_app/router.dart';
import 'package:hookshot_ui/hookshot_ui.dart';

class CreateProjectPage extends StatelessWidget {
  const CreateProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateProjectBloc(
        context.read<ProjectRepository>(),
      )..add(CreateProjectStarted()),
      child: const CreateProjectView(),
    );
  }
}

class CreateProjectView extends StatefulWidget {
  const CreateProjectView({super.key});

  @override
  State<CreateProjectView> createState() => _CreateProjectViewState();
}

class _CreateProjectViewState extends State<CreateProjectView> {
  var _name = '';

  void _handleStateChange(BuildContext context, CreateProjectState state) {
    switch (state) {
      case CreateProjectFailure():
        ErrorDialog.show(context, state.error);
      case CreateProjectSuccess():
        context.goNamed(
          Routes.project.name,
          pathParameters: {'projectId': state.projectId},
        );
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateProjectBloc, CreateProjectState>(
      listener: _handleStateChange,
      child: Padding(
        padding: const EdgeInsets.all(Spacing.extraLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildForm(context),
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
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(icon: Icons.arrow_back, onTap: context.pop),
                ),
                const Text(
                  'Create project',
                  style: TextStyle(fontSize: FontSize.large),
                ),
              ],
            ),
            const SizedBox(height: Spacing.extraLarge),
            _buildEmailField(context),
            const SizedBox(height: Spacing.medium),
            _buildCreateButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return TextField.name(
      label: 'Name',
      onChanged: (value) => _name = value,
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    final bloc = context.watch<CreateProjectBloc>();
    return IndexedStack(
      alignment: Alignment.center,
      sizing: StackFit.passthrough,
      index: bloc.state is CreateProjectLoading ? 1 : 0,
      children: [
        PrimaryButton(
          label: 'Create',
          onTap: () => bloc.add(CreateProjectSubmitted(_name)),
        ),
        _buildLoadingLabel(context),
      ],
    );
  }

  Widget _buildLoadingLabel(BuildContext context) {
    return const Text(
      'Creating project...',
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: FontSize.medium,
        color: Colors.black,
      ),
      textAlign: TextAlign.center,
    );
  }
}
