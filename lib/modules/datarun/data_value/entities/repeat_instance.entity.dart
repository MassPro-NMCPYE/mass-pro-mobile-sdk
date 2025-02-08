import 'package:d2_remote/core/annotations/index.dart';
import 'package:d2_remote/modules/datarun/data_value/entities/data_form_submission.entity.dart';
import 'package:d2_remote/modules/datarun/data_value/entities/data_value.entity.dart';
import 'package:d2_remote/shared/entities/identifiable.entity.dart';

@AnnotationReflectable
@Entity(tableName: 'repeatInstance', apiResourceName: 'repeatInstances')
class RepeatInstance extends IdentifiableEntity {
  @ManyToOne(table: DataFormSubmission, joinColumnName: 'submission')
  dynamic submission;

  /// path of the Repeat in the FormTemplate
  @Column(nullable: false, type: ColumnType.TEXT)
  String templatePath;

  // /// the nearest repeat Instance in ancestry
  // @Column(nullable: false, type: ColumnType.TEXT)
  // String parent;
  // @ManyToOne(table: RepeatInstance, joinColumnName: 'parent')
  /// the nearest repeat item Instance in ancestry or null
  @Column(nullable: true, type: ColumnType.TEXT)
  String? parent;

  /// for order and identity within a repeat row
  /// not necessarily successive in case of delete
  @Column(nullable: false, type: ColumnType.INTEGER)
  int repeatIndex;

  @OneToMany(table: DataValue)
  List<DataValue>? dataValues;

  RepeatInstance(
      {String? id,
      String? createdDate,
      String? lastModifiedDate,
      required this.submission,
      required this.repeatIndex,
      this.parent,
      required this.templatePath,
      this.dataValues,
      required dirty})
      : super(
            id: id,
            uid: id,
            createdDate: createdDate,
            lastModifiedDate: lastModifiedDate,
            dirty: dirty);

  factory RepeatInstance.fromJson(Map<String, dynamic> json) {
    return RepeatInstance(
        id: json['id'],
        lastModifiedDate: json['lastModifiedDate'],
        createdDate: json['createdDate'],
        submission: json['dataSubmission'],
        repeatIndex: json['repeatIndex'],
        templatePath: json['templatePath'],
        dataValues: (json['dataValues'] ?? [])
            .map<DataValue>((dataValue) => DataValue.fromJson({
                  ...dataValue,
                  'parent': json['uid'] ?? json['id'],
                  'dataSubmission': json['dataSubmission'],
                  'templatePath':
                      '${json['templatePath']}.${json['dataElement']}',
                  'dirty': false
                }))
            .toList(),
        parent: json['parent'],
        dirty: json['dirty'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'uid': this.id,
      'templatePath': this.templatePath,
      'dataSubmission': this.submission,
      'parent': this.parent,
      'repeatIndex': this.repeatIndex,
      'createdDate': this.createdDate,
      'lastModifiedDate': this.lastModifiedDate,
      'dataValues': this.dataValues,
      'dirty': this.dirty
    };
  }
}
