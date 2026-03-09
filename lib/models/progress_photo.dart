import 'package:isar/isar.dart';

part 'progress_photo.g.dart';

@collection
class ProgressPhoto {
  Id id = Isar.autoIncrement;

  late DateTime date;
  late String imageLocalPath;
}
