CLI utility to manage MC server installations.

# For developers

If you are on a UNIX based OS you require the native chmod for the script generators. To compile that please run

```
make build_native
```

If you edit files that also use `json_serializable` or `retrofit` please run the following command

```
make generate
```
