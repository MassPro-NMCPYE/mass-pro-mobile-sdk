import 'dart:convert';

import 'package:d2_remote/core/annotations/column.annotation.dart';
import 'package:d2_remote/core/annotations/entity.annotation.dart';
import 'package:d2_remote/core/annotations/reflectable.annotation.dart';
import 'package:d2_remote/modules/datarun/form/models/geometry.dart';
import 'package:d2_remote/modules/datarun_shared/entities/syncable.entity.dart';
import 'package:d2_remote/shared/enumeration/assignment_status.dart';

@AnnotationReflectable
@Entity(tableName: 'dataSubmission', apiResourceName: 'dataSubmission')
class DataFormSubmission extends SyncableEntity {
  // @OneToMany(table: DataValue)
  // List<DataValue>? dataValues;

  // @OneToMany(table: RepeatInstance)
  // List<RepeatInstance>? repeatInstances;

  @Column(nullable: true, type: ColumnType.TEXT)
  final Map<String, dynamic> formData = {};

  DataFormSubmission({
    String? id,
    String? uid,
    String? name,
    String? code,
    Map<String, dynamic> formData = const {},
    String? createdDate,
    String? lastModifiedDate,
    // this.dataValues,
    // this.repeatInstances,

    /// Syncable
    required int version,
    String? form,
    required dynamic formVersion,
    bool? deleted,
    bool? synced,
    bool? syncFailed,
    String? lastSyncDate,
    String? lastSyncMessage,
    String? startEntryTime,
    String? finishedEntryTime,
    // dynamic activity,
    String? orgUnit,
    dynamic team,
    String? assignment,
    AssignmentStatus? status,
    bool isFinal = false,
    String? rescheduledDate,
    String? reassignedToTeam,
    Geometry? geometry,
    required dirty,
  }) : super(
          id: id,
          uid: uid,
          name: name,
          code: code,
          createdDate: createdDate,
          lastModifiedDate: lastModifiedDate,

          /// Syncable
          formVersion: formVersion,
          form: form,
          version: version,
          deleted: deleted,
          synced: synced,
          syncFailed: syncFailed,
          lastSyncDate: lastSyncDate,
          lastSyncMessage: lastSyncMessage,
          startEntryTime: startEntryTime,
          finishedEntryTime: finishedEntryTime,
          // activity: activity,
          orgUnit: orgUnit,
          team: team,
          assignment: assignment,
          status: status,
          rescheduledDate: rescheduledDate,
          reassignedToTeam: reassignedToTeam,
          geometry: geometry,
          isFinal: isFinal,
          dirty: dirty,
        ) {
    this.formData.addAll(formData);
  }

  // From JSON string (Database and API)
  factory DataFormSubmission.fromJson(Map<String, dynamic> json) {
    final status = AssignmentStatus.getType(json['status']);

    final Geometry? geometry = json["geometry"] != null
        ? Geometry.fromJson(json["geometry"].runtimeType == String
            ? jsonDecode(json["geometry"])
            : json["geometry"])
        : null;

    Map<String, dynamic> parseFormData(dynamic data) {
      if (data == null || (data is String && data.isEmpty)) {
        return {};
      }
      return Map<String, dynamic>.from(
          data is String ? jsonDecode(data) : data);
    }

    final formVersion = json['formVersion'];
    final List<String> formAndVersion = formVersion is String
        ? formVersion.split('_')
        : json['formVersion']['uid'].split('_');

    return DataFormSubmission(
      id: json['id'].toString(),
      uid: json['uid'],
      code: json['code'],
      name: json['name'],
      createdDate: json['createdDate'],
      lastModifiedDate: json['lastModifiedDate'],
      // dataValues: (json['dataValues'] ?? [])
      //     .map<DataValue>((dataValue) => DataValue.fromJson({
      //           ...dataValue,
      //           'dataSubmission': json['uid'] ?? json['id'],
      //           'dirty': false
      //         }))
      //     .toList(),
      // repeatInstances: (json['repeatInstances'] ?? [])
      //     .map<DataValue>((repeatInstance) => DataValue.fromJson({
      //           ...repeatInstance,
      //           'dataSubmission': json['uid'] ?? json['id'],
      //           'dirty': false
      //         }))
      //     .toList(),
      formData: parseFormData(json['formData']),

      /// Syncable
      formVersion: json['formVersion'],
      form: formAndVersion[0],
      version: int.tryParse(formAndVersion[1])!,
      deleted: json['deleted'],
      synced: json['synced'],
      isFinal: json['isFinal'] ?? true,
      syncFailed: json['syncFailed'],
      lastSyncDate: json['lastSyncDate'],
      lastSyncMessage: json['lastSyncMessage'],
      startEntryTime: json['startEntryTime'],
      finishedEntryTime: json['finishedEntryTime'],
      rescheduledDate: json['rescheduledDate'],
      reassignedToTeam: json['reassignedToTeam'],
      assignment: json['assignment'],
      orgUnit: json['orgUnit'],
      // activity: activity,
      team: json['team'] != null
          ? json['team'] is String
              ? json['team']
              : json['team']['uid']
          : null,
      status: status,
      // orgUnit:
      //     json['orgUnit'] is String ? json['orgUnit'] : json['orgUnit']?['uid'],
      geometry: geometry,

      dirty: json['dirty'] ?? false,
    );
  }

  factory DataFormSubmission.fromApi(Map<String, dynamic> json) {
    final status = AssignmentStatus.getType(json['status']);

    final Geometry? geometry = json["geometry"] != null
        ? Geometry.fromJson(json["geometry"].runtimeType == String
            ? jsonDecode(json["geometry"])
            : json["geometry"])
        : null;

    Map<String, dynamic> parseFormData(dynamic data) {
      if (data == null || (data is String && data.isEmpty)) {
        return {};
      }
      return Map<String, dynamic>.from(
          data is String ? jsonDecode(data) : data);
    }

    return DataFormSubmission(
      id: json['id'].toString(),
      uid: json['uid'],
      code: json['code'],
      name: json['name'],
      createdDate: json['createdDate'],
      lastModifiedDate: json['lastModifiedDate'],
      formData: parseFormData(json['formData']),

      /// Syncable
      formVersion: '${json['form']}_${json['version']}',
      form: json['form'],
      version: json['version'],
      deleted: json['deleted'],
      synced: json['synced'],
      syncFailed: json['syncFailed'],
      lastSyncDate: json['lastSyncDate'],
      lastSyncMessage: json['lastSyncMessage'],
      startEntryTime: json['startEntryTime'],
      finishedEntryTime: json['finishedEntryTime'],
      // activity: activity,
      team: json['team'] != null
          ? json['team'] is String
              ? json['team']
              : json['team']['uid']
          : null,
      status: status,
      rescheduledDate: json['rescheduledDate'],
      reassignedToTeam: json['reassignedToTeam'],
      assignment: json['assignment'],
      orgUnit: json['orgUnit'],
      geometry: geometry,

      dirty: json['dirty'] ?? false,
    );
  }

  /// To JSON string for Database and API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'code': code,
      'name': name,
      'createdDate': createdDate,
      'lastModifiedDate': lastModifiedDate,
      'formData': jsonEncode(formData),

      /// Syncable
      'formVersion': formVersion,
      'form': form,
      'version': version,
      'deleted': this.deleted,
      'synced': this.synced,
      'syncFailed': this.syncFailed,
      'lastSyncDate': this.lastSyncDate,
      'lastSyncMessage': this.lastSyncMessage,
      'startEntryTime': this.startEntryTime,
      'finishedEntryTime': this.finishedEntryTime,
      // 'activity': activity,
      'team': team,
      'rescheduledDate': rescheduledDate,
      'reassignedToTeam': reassignedToTeam,
      'assignment': assignment,
      'orgUnit': orgUnit,
      'status': this.status?.name,
      'isFinal': this.isFinal,
      'geometry': this.geometry != null
          ? jsonEncode(this.geometry?.geometryData)
          : null,
      'dirty': this.dirty,
    };
  }

  @override
  Map<String, dynamic> toUpload() {
    Map<String, dynamic> syncableToUpload = super.toUpload();

    syncableToUpload.addAll({
      'formData': formData,
    });

    return syncableToUpload;
  }
}
