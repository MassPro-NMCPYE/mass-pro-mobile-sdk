import 'package:d2_remote/core/annotations/nmc/query.annotation.dart';
import 'package:d2_remote/core/annotations/reflectable.annotation.dart';
import 'package:d2_remote/modules/datarun/itns/entities/itns_village.entity.dart';
import 'package:d2_remote/shared/queries/base.query.dart';
import 'package:sqflite/sqflite.dart';

@AnnotationReflectable
@Query(type: QueryType.METADATA)
class ItnsVillageQuery extends BaseQuery<ItnsVillage> {
  ItnsVillageQuery({Database? database}) : super(database: database);
}
