# Hookshot

Hookshot is a feedback and survey SDK for Flutter apps, an accompanying backend to collect responses and a dashboard for your team to view them.

| Screenshots                    | 2023-08-14                     |
| :----------------------------: | :----------------------------: |
| Sign up                        | Projects                       |
| ![](.github/screenshots/1.png) | ![](.github/screenshots/2.png) |
| Feedback                       | Promoter score                 |
| ![](.github/screenshots/3.png) | ![](.github/screenshots/4.png) |

Since Wiredash is a popular, albeit expensive, feedback and survey service for the Flutter ecosystem, Hookshot is designed for compatability with the Wiredash SDK. Simply change your `pubspec.yaml` import to use our fork at https://github.com/millsteed/wiredash-sdk, which lets you supply a custom `host` to the `Wiredash` widget to point the SDK at Hookshot instead of Wiredash. Here's an example:

```yaml
dependencies:
  # ...
  wiredash:
    git: https://github.com/millsteed/wiredash-sdk.git
```

```dart
@override
Widget build(BuildContext context) {
  return Wiredash(
    host: 'https://app.hookshot.software/api/sdk',
    // host: http://localhost:8080/api/sdk,
    // host: https://hookshot.yourdomain.tld/api/sdk,
    projectId: wiredashProject,
    secret: wiredashSecret,
    child: App(),
  );
}
```

## Quickstart

Hookshot is built using Dart and Flutter and its only dependency is a PostgreSQL database. The easiest way to run it is with Docker Compose, which will bring up the database and server to serve the API and dashboard, but it's simple enough to run directly from VS Code or the command line.

### Docker Compose

Either you like to do things on easy mode or your don't have Flutter installed - right on. Make sure you have Docker installed and run the following:

```bash
docker compose up
```

Yeah, it's that easy, add the `-d` flag if you don't like walls of text. Give it a few minutes to build everything and then head on over to http://localhost:8080.

### Dart/Flutter

To get started you need Flutter and Postgres installed. Set up the database schema by executing [postgres/schema.sql](https://github.com/millsteed/hookshot/blob/main/postgres/schema.sql) in Postgres. By default the server will connect to the database at `postgres://postgres:postgres@localhost:5432/postgres`, but this can be configured with the following environment variables: `DATABASE_HOST`, `DATABASE_PORT`, `DATABASE_USER`, `DATABASE_PASS` and `DATABASE_NAME`. We have a Docker Compose file which will run Postgres with these settings and automatically apply the schema. You can run it with:

```bash
docker compose -f compose.dependencies.yaml up -d
```

Since we use [freezed](https://pub.dev/packages/freezed) to generate our models, codegen needs to be run for both the `protocol` and `server` packages. If you haven't used codegen in Dart before, you can do this by running the following in both package directories:

```bash
dart run build_runner build
```

Now bring up the server and the app with the following commands or run them directly from your IDE:

```bash
cd server && dart run bin/server.dart
```

```bash
cd app && flutter run -d chrome
```

You're all set up! If you ran the above from your IDE in debug mode you have hot reloading for both the server and app.

## License

Hookshot is released under the [GNU Affero General Public License](https://www.gnu.org/licenses/agpl-3.0.html) (AGPL). See [LICENSE](https://github.com/millsteed/hookshot/blob/main/LICENSE) for details.
