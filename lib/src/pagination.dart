class Pagination<T> {
  final int page;
  final int total;
  final int pageSize;
  final int lastPage;
  final List<T> results;

  bool get isLastPage {
    return page == lastPage;
  }

  const Pagination({
    required this.page,
    required this.total,
    required this.pageSize,
    required this.lastPage,
    required this.results,
  });

  Pagination.fromJson(Map json, T Function(Map<String, Object?>) itemBuilder)
      : page = json['page'],
        total = json['total'],
        pageSize = json['page_size'],
        lastPage = json['last_page'],
        results = (json['results'] as List).map((e) => itemBuilder(e)).toList();

  Pagination.empty({this.pageSize = 20})
      : page = 1,
        total = 0,
        lastPage = 1,
        results = [];

  Pagination<T> next([int? value]) {
    int nextPage = value ?? page + 1;
    if (nextPage > lastPage || nextPage < 1) {
      nextPage = page;
    }

    return Pagination<T>(
      page: nextPage,
      total: total,
      pageSize: pageSize,
      lastPage: lastPage,
      results: results,
    );
  }

  Pagination<T> previous() {
    return Pagination<T>(
      page: page > 1 ? page - 1 : 1,
      total: total,
      pageSize: pageSize,
      lastPage: lastPage,
      results: results,
    );
  }

  Pagination<T> append(Pagination other) {
    return Pagination<T>(
      page: other.page,
      total: other.total,
      pageSize: other.pageSize,
      lastPage: other.lastPage,
      results: [
        ...results,
        ...other.results,
      ],
    );
  }

  Pagination<T> insert(int index, T obj) {
    final List<T> copyResults = results.toList();
    copyResults.insert(index, obj);
    return Pagination<T>(
      page: page,
      total: total,
      pageSize: pageSize,
      lastPage: lastPage,
      results: copyResults,
    );
  }

  Pagination<T> add(T obj) {
    final List<T> copyResults = results.toList();
    copyResults.add(obj);
    return Pagination<T>(
      page: page,
      total: total,
      pageSize: pageSize,
      lastPage: lastPage,
      results: copyResults,
    );
  }

  Pagination<T> addAll(Iterable<T> objs) {
    final List<T> copyResults = results.toList();
    copyResults.addAll(objs);
    return Pagination<T>(
      page: page,
      total: total,
      pageSize: pageSize,
      lastPage: lastPage,
      results: copyResults,
    );
  }
}
