import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shindenshin/shindenshin.dart';

part 'author.freezed.dart';
part 'author.g.dart';

@freezed
class Author extends BaseModel with _$Author {
  const factory Author({
    required dynamic id,
  }) = _Author;

  factory Author.fromJson(Map<String, Object?> json) => _$AuthorFromJson(json);
}
