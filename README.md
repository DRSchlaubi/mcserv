CLI utility to manage MC server installations.

# For developers

**Note: Gradle requires a JDK, if you don't have one installed, we recommend installing it via [sdkman](https://sdkman.io).**

If you are on a UNIX based OS you require the native chmod for the script generators. To compile that please run

```
./gradlew assemble
```

If you edit files that also use `json_serializable` or `retrofit` please run the following command

```
./gradlew dartGenerate
```
