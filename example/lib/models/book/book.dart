import 'package:example/models/author/author.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shindenshin/shindenshin.dart';

part 'book.freezed.dart';
part 'book.g.dart';

@freezed
class Book extends BaseModel with _$Book {
  const factory Book({
    required dynamic id,
    required String name,
    required int? pageCount,
    required Author? author,
  }) = _Book;

  factory Book.fromJson(Map<String, Object?> json) => _$BookFromJson(json);
}
