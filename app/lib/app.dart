import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookshot_app/router.dart';
import 'package:hookshot_client/hookshot_client.dart';
import 'package:hookshot_ui/hookshot_ui.dart';
import 'package:wiredash/wiredash.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.hookshotClient,
    required this.wiredashApiUrl,
    required this.wiredashProject,
    required this.wiredashSecret,
  });

  final HookshotClient hookshotClient;

  final String wiredashApiUrl;
  final String wiredashProject;
  final String wiredashSecret;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: hookshotClient,
      child: Wiredash(
        host: wiredashApiUrl,
        projectId: wiredashProject,
        secret: wiredashSecret,
        child: ColoredBox(
          color: Colors.white,
          child: IconTheme(
            data: const IconThemeData(
              size: IconSize.medium,
              color: Colors.black,
            ),
            child: WidgetsApp.router(
              color: Colors.black,
              textStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: FontSize.medium,
                color: Colors.black,
              ),
              routerConfig: router,
            ),
          ),
        ),
      ),
    );
  }
}
