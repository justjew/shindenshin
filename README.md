## Basics

This package includes all necessary basics to make comunications between UI, BL and Data layers.

Used dependencies:

- dio
- hive
- bloc
- equatable

## ApiClient

This is a singleton class that contains basic REST methods and a little auth logic.

It **should be initialized** before used.

`ApiClient` inits itself automatically in `Store` constructor _(see below)_.

`init` method has the following arguments:

- `releaseBaseHost` - URI which will be used in release build;
- `forceUseReleaseHost` - tells it to use release uri even in debug mode _(default false)_;
- `androidDegubHost` - URI for Android Emulator in debug mode _(default 10.0.2.2)_

## BaseModel and BaseModalApi

These two are useful for mapping backend entities to your flutter application.

`BaseModelApi` can request a `list` _(or `paginatedList`)_ of items, `retreive` a single item by id, `create` a new item and `update` or `delete` an existing one.

You should implement `fromJson` method and the `url` field which is a relative path _(e.g. 'products', 'orders' etc.)_.

`rootList` parameter set to true is needed if response's data doesn't have a pagination.

## BaseStore

Is needed to create a centralized `Store` which contains all the repositories.

`BaseStore` is `Subscriptable` so you can call `subscribe(fn)` and `notify(event)` methods to help repos communicate with each other.

## BaseRepo

This class is needed to create your repositories. It's also `Subscriptable`.

All the repos should be initialized in `Store`'s constructor and pass `Store` instance to `super`.
