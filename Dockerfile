# Build image

FROM ubuntu AS build

# Define arguments

ARG DATABASE_HOST
ARG DATABASE_PORT
ARG DATABASE_USER
ARG DATABASE_PASS
ARG DATABASE_NAME

ARG STORAGE_PATH
ARG WEB_PATH

ARG HOOKSHOT_API_URL
ARG HOOKSHOT_STORAGE_URL

ARG WIREDASH_API_URL
ARG WIREDASH_PROJECT
ARG WIREDASH_SECRET

# Install tooling

RUN apt-get update
RUN apt-get install -y curl git unzip
RUN git clone -b stable https://github.com/flutter/flutter.git
ENV PATH=$PATH:/flutter/bin
RUN dart --disable-analytics
RUN flutter --disable-telemetry
RUN flutter precache --web

# Download dependencies

WORKDIR /hookshot/protocol
COPY protocol/pubspec.yaml pubspec.yaml

WORKDIR /hookshot/client
COPY client/pubspec.yaml pubspec.yaml

WORKDIR /hookshot/ui
COPY ui/pubspec.yaml pubspec.yaml

WORKDIR /hookshot/server
COPY server/pubspec.yaml pubspec.yaml
COPY server/pubspec.lock pubspec.lock
RUN dart pub get

WORKDIR /hookshot/app
COPY app/pubspec.yaml pubspec.yaml
COPY app/pubspec.lock pubspec.lock
RUN dart pub get

# Build packages

WORKDIR /hookshot/protocol
COPY protocol/build.yaml build.yaml
COPY protocol/lib lib
RUN dart run build_runner build

WORKDIR /hookshot/server
COPY server/bin bin
COPY server/lib lib
RUN dart run build_runner build
RUN dart compile exe bin/server.dart -o bin/server \
    --define DATABASE_HOST=$DATABASE_HOST \
    --define DATABASE_PORT=$DATABASE_PORT \
    --define DATABASE_USER=$DATABASE_USER \
    --define DATABASE_PASS=$DATABASE_PASS \
    --define DATABASE_NAME=$DATABASE_NAME \
    --define STORAGE_PATH=$STORAGE_PATH \
    --define WEB_PATH=$WEB_PATH

WORKDIR /hookshot/client
COPY client/lib lib

WORKDIR /hookshot/ui
COPY ui/lib lib

WORKDIR /hookshot/app
COPY app/lib lib
COPY app/web web
RUN flutter build web --web-renderer canvaskit \
    --dart-define HOOKSHOT_API_URL=$HOOKSHOT_API_URL \
    --dart-define HOOKSHOT_STORAGE_URL=$HOOKSHOT_STORAGE_URL \
    --dart-define WIREDASH_API_URL=$WIREDASH_API_URL \
    --dart-define WIREDASH_PROJECT=$WIREDASH_PROJECT \
    --dart-define WIREDASH_SECRET=$WIREDASH_SECRET

# Runtime image

FROM scratch

# Copy artifacts

COPY --from=dart /runtime/ /
COPY --from=build /hookshot/server/bin/server server
COPY --from=build /hookshot/app/build/web web

# Runtime options

EXPOSE 8080
CMD ["/server"]
