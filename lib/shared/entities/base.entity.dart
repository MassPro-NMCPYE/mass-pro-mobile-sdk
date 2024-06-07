import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/shared/utilities/dhis_uid_generator.util.dart';

// @AnnotationReflectable
class BaseEntity {
  @PrimaryColumn()
  late String? id;

  @Column(nullable: true)
  late String? uid;

  @Column()
  bool dirty;

  @Column(nullable: true)
  String? lastUpdated;

  @Column(nullable: true)
  String? created;

  BaseEntity(
      {this.id,
      this.uid,
      required this.dirty,
      this.created,
      this.lastUpdated}) {
    this.id = this.id ?? DhisUidGenerator.generate();

    /// Added for DataRun
    this.uid = this.uid ?? DhisUidGenerator.generate();

    this.created =
        this.created ?? DateTime.now().toIso8601String().split('.')[0];
    this.lastUpdated = this.lastUpdated ?? this.created;
  }

  static fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
