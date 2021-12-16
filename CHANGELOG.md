# 0.0.10

Restored Store link in Repo

# 0.0.9

Added Repo getter from Store. Changed Store initialization.

```dart
class Store extends BaseStore {
    Store() : super([
        ARepo.new,
        BRepo.new,
    ], releaseBaseHost: '');
}

final ARepo aRepo = store.get<ARepo>();
final BRepo bRepo = store<BRepo>();
```

Removed Store from Repo

# 0.0.8

Export Hive
Added ApiConfig

# 0.0.7

Updated example

# 0.0.6

Added side packages exports

# 0.0.5

Added example

# 0.0.4

Renamed subscript function to subscribe

# 0.0.3

Added generic type for BaseStore in BaseRepo

## 0.0.2

Fixed entry file

## 0.0.1

Initial release.
