# 0.2.4

`BaseModelApi` url changed to getter

# 0.2.3

Removed `const` keyword from `.empty()` pagination constructor

# 0.2.2

`insert`, `add` and `addAll` methods in `Pagination` class

# 0.2.1

`const` Pagination constructors

# 0.2.0

[BREAKING]

Field `id` in `BaseModel` become as named parameter in constructor to let you use super initializer from dart 2.17.

Also updated minimal sdk version.

# 0.1.10

Added Accept-Language header

# 0.1.9

Added `BaseConfig` and `BaseEnvironment` classes to manage production and development configurations

# 0.1.8

No longer clearing result list on `next` and `previous`

# 0.1.7

Fixed generic bug

# 0.1.6

Added `append` method to `Pagination`

# 0.1.5

Fixed `get` method in `BaseModelApi`

# 0.1.4

Added `onSendProgress` and `onReceiveProgress` to `BaseModelApi` methods

# 0.1.3

Added `onSendProgress` and `onReceiveProgress` to `BaseApiClient` methods

# 0.1.2

Fixed Store constructor bug

# 0.1.1

`BaseModelApi`s fields made public

# 0.1.0

**BREAKING CHANGES!**

`ApiClient` singleton is now deprecated.
Store constructor receives instance of `BaseApiClient`.

`fromJson` moved to `ModelParser` class.

`BaseApiClient` and `ModelParser` should be provided to `ModelApi` constructor.

# 0.0.17

Made `repos` as set

# 0.0.16

`registerRepos()` is now public

# 0.0.15

Updated dependencies

# 0.0.14

Added `forceUseReleaseHost` and `androidDegubHost` to `BaseStore`

# 0.0.13

Fixed apiClient path

# 0.0.12

Dynamic weboscket data

# 0.0.11

Optionional params in getBaseUri

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
