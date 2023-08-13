import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hookshot_app/pages/projects/bloc.dart';
import 'package:hookshot_app/pages/projects/event.dart';
import 'package:hookshot_app/pages/projects/state.dart';
import 'package:hookshot_app/repositories/project_repository.dart';
import 'package:hookshot_app/router.dart';
import 'package:hookshot_client/hookshot_client.dart';
import 'package:hookshot_ui/hookshot_ui.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectsBloc(
        context.read<ProjectRepository>(),
      )..add(ProjectsStarted()),
      child: const ProjectsView(),
    );
  }
}

class ProjectsView extends StatelessWidget {
  const ProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectsBloc, ProjectsState>(
      builder: (context, state) => switch (state) {
        ProjectsInitial() => _buildInitial(context, state),
        ProjectsLoading() => _buildLoading(context, state),
        ProjectsSuccess() => _buildSuccess(context, state),
        ProjectsFailure() => _buildFailure(context, state),
      },
    );
  }

  Widget _buildInitial(BuildContext context, ProjectsInitial state) {
    return const SizedBox();
  }

  Widget _buildLoading(BuildContext context, ProjectsLoading state) {
    return const Center(child: Text('Loading'));
  }

  Widget _buildSuccess(BuildContext context, ProjectsSuccess state) {
    final projects = state.projects;
    if (projects.isEmpty) {
      return Column(
        children: [
          const SizedBox(height: Spacing.medium),
          _buildHeader(context),
          const SizedBox(height: Spacing.medium),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(Spacing.medium),
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Radius.medium),
                  color: Colors.gray50,
                ),
                padding: const EdgeInsets.all(Spacing.extraLarge),
                child: const Text(
                  'No projects yet. Create a project to get started.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: FontSize.extraLarge,
                    color: Colors.gray200,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: Spacing.medium),
        ],
      );
    }
    return ListView(
      children: [
        const SizedBox(height: Spacing.medium),
        _buildHeader(context),
        const SizedBox(height: Spacing.medium),
        _buildProjects(context, projects),
        const SizedBox(height: Spacing.medium),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.medium),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Sizes.maxWidth),
          child: Row(
            children: [
              const Text(
                'Projects',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: FontSize.extraLarge,
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Create project',
                onTap: () => context.goNamed(Routes.createProject.name),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjects(BuildContext context, List<Project> projects) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.medium),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Sizes.maxWidth),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final rows = constraints.maxWidth ~/ 220;
              final columns = (projects.length / rows).ceil();
              return Column(
                children: [
                  for (var i = 0; i < columns; i++) ...[
                    if (i != 0) ...[
                      const SizedBox(height: Spacing.medium),
                    ],
                    Row(
                      children: [
                        for (var j = 0; j < rows; j++) ...[
                          if (j != 0) ...[
                            const SizedBox(width: Spacing.medium),
                          ],
                          Expanded(
                            child: i * rows + j < projects.length
                                ? AspectRatio(
                                    aspectRatio: rows > 1 ? 1 : 2,
                                    child: _buildProject(
                                      context,
                                      projects[i * rows + j],
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProject(BuildContext context, Project project) {
    return GestureDetector(
      onTap: () => context.goNamed(
        Routes.project.name,
        pathParameters: {'projectId': project.id},
      ),
      child: HoverableBuilder(
        builder: (context, isHovered) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Radius.medium),
            color: isHovered ? Colors.gray100 : Colors.gray50,
          ),
          alignment: Alignment.center,
          child: Text(project.name),
        ),
      ),
    );
  }

  Widget _buildFailure(BuildContext context, ProjectsFailure state) {
    return Center(child: Text(state.error));
  }
}
