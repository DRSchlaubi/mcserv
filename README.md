CLI utility to manage MC server installations.

# Features

- Install required JDKs
- Download server files
- Generate start scripts (with optimized JVM flags)
- Update to the latest build

# Demo
[![asciicast](https://asciinema.org/a/0PHpU6CdGk57EKQk5Xja2Vc9j.svg)](https://asciinema.org/a/0PHpU6CdGk57EKQk5Xja2Vc9j)

# Installation

Linux: https://docs.mcserv.how/install/#linux
Windows: `winget install mcserv`

# Supported Platforms

| Platform | Supported |
| ------ | ----- |
| Windows | ✔ |
| Linux | ✔ |
| macOS¹ | 🚧 |

¹ In theory macOS should be supported, there are just no macOS specific implementations yet

# Supported Server Distributions

| Distribution | Install | Update | Metadata¹ |
| --- | --- | --- | --- |
| PaperMC | ✔ | ✔ | ✔ |
| Waterfall | ✔ | ✔ | ❌ |
| Travertine | ✔ | ✔ | ❌ |
| PurPur | ✔ | ✔ | ❌ |
| Velocity | ✔ | ✔ | ❌ |

¹ Metadata is required to ensure the correct Java version is installed and use proper JVM flags

# FAQ (Frequently asked Questions)

## Why is Spigot not supported?

Spigot still uses the ancient [Spigot BuildTools](https://www.spigotmc.org/wiki/buildtools/) to distribute itself,
because those take very long to run and only run in Git Bash (on Windows) we decided to not support Spigot

## Do you support ARM?

Whilst we generally support arm, we do not provide precompiled binaries for ARM (since GitHub actions doesn't support
ARM runners). However, you can compile the project yourself (See [Compiling from source](#compiling-from-source))

# For developers

**Note: Gradle requires a JDK, if you don't have one installed, we recommend installing it
via [sdkman](https://sdkman.io).**

If you are on a UNIX based OS you require the native chmod for the script generators. To compile that please run

```
./gradlew assemble
```

If you edit files that also use `json_serializable` or `retrofit` please run the following command

```
./gradlew dartGenerate
```

# Compiling from source

## Prerequisites

- JDK (Get from [SDKMAN!](https://sdkman.io) or [Adoptium](https://adoptium.net))
- Dart SDK (Get from [here](https://dart.dev/get-dart#install))
- CPP dev tools (Only if you're on Linux or macOS)
- [WIX Toolset](https://wixtoolset.org/releases/) (Only if you're on Windows)

If you installed the Dart SDK please add the path to the SDK into the `local.properties` file (if it doesn't exist,
create it)

```properties
# (this is when you did 'winget install dart'
dart.sdk=C:\\Program Files\\Dart\\dart-sdk
```

## Build on macOS and Linux

```
./gradlew assemble
```

## Build on Windows

```
gradlew assembleMsi
```

In both cases you will find your output in `build/distributions`
