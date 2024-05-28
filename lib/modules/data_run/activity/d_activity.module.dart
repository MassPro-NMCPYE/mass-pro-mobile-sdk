import 'package:d2_remote/modules/data_run/activity/queries/d_activity.query.dart';

class DActivityModule {
  static createTables() async {
    return await DActivityQuery().createTable();
  }

  DActivityQuery get activity => DActivityQuery();
}
