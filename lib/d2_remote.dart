library d2_remote;

import 'dart:async';

import 'package:d2_remote/core/database/database_manager.dart';
import 'package:d2_remote/core/datarun/exception/exception.dart';
import 'package:d2_remote/core/datarun/logging/new_app_logging.dart';
import 'package:d2_remote/core/datarun/utilities/date_helper.dart';
import 'package:d2_remote/modules/auth/user/d_user.module.dart';
import 'package:d2_remote/modules/auth/user/entities/d_user.entity.dart';
import 'package:d2_remote/modules/auth/user/models/auth-token.model.dart';
import 'package:d2_remote/modules/auth/user/models/login-response.model.dart';
import 'package:d2_remote/modules/auth/user/queries/d_user.query.dart';
import 'package:d2_remote/modules/datarun/data_value/form_submission.module.dart';
import 'package:d2_remote/modules/datarun/form/form.module.dart';
import 'package:d2_remote/modules/datarun_shared/utilities/authenticated_user.dart';
import 'package:d2_remote/modules/metadatarun/activity/d_activity.module.dart';
import 'package:d2_remote/modules/metadatarun/assignment/d_assignment.module.dart';
import 'package:d2_remote/modules/metadatarun/project/d_project.module.dart';
import 'package:d2_remote/modules/metadatarun/teams/d_team.module.dart';
import 'package:d2_remote/modules/metadatarun/org_unit/org_unit.module.dart';
import 'package:d2_remote/shared/utilities/http_client.util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class D2Remote {
  static const String currentDatabaseNameKey = 'databaseName';

  ///
  static Future<void> initialize(
      {String? databaseName,
      bool? inMemory,
      DatabaseFactory? databaseFactory}) async {
    final newDatabaseName = databaseName ?? await D2Remote.getDatabaseName();
    if (newDatabaseName != null) {
      DatabaseManager(
          databaseName: newDatabaseName,
          inMemory: inMemory,
          databaseFactory: databaseFactory);

      await DatabaseManager.instance.database;
      await DUserModule.createTables();
      await OrgUnitModule.createTables();
      await DProjectModule.createTables();
      await DActivityModule.createTables();
      await DTeamModule.createTables();
      await DAssignmentModule.createTables();
      await FormModule.createTables();
      await FormSubmissionModule.createTables();
    }
  }

  static Future<bool> isAuthenticated(
      {Future<SharedPreferences>? sharedPreferenceInstance,
      bool? inMemory,
      DatabaseFactory? databaseFactory}) async {
    WidgetsFlutterBinding.ensureInitialized();
    final databaseName = await D2Remote.getDatabaseName(
        sharedPreferenceInstance: sharedPreferenceInstance);

    if (databaseName == null) {
      return false;
    }

    await D2Remote.initialize(
        databaseName: databaseName,
        inMemory: inMemory,
        databaseFactory: databaseFactory);

    DUser? user = await D2Remote.userModule.user.getOne();

    return user?.isLoggedIn ?? false;
  }

  static Future<String?> getDatabaseName(
      {Future<SharedPreferences>? sharedPreferenceInstance}) async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs =
        await (sharedPreferenceInstance ?? SharedPreferences.getInstance());
    return prefs.getString(currentDatabaseNameKey);
  }

  /// set the database name for the current user, which the app will
  /// use to store data until the user logs out.
  static Future<bool> setDatabaseName(
      {required String databaseName,
      Future<SharedPreferences>? sharedPreferenceInstance}) async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs =
        await (sharedPreferenceInstance ?? SharedPreferences.getInstance());
    return prefs.setString(currentDatabaseNameKey, databaseName);
  }

  static Future<AuthenticationResult> authenticate(
      {required String username,
      required String password,
      required String url,
      Future<SharedPreferences>? sharedPreferenceInstance,
      Duration? timeout,
      bool? inMemory,
      DatabaseFactory? databaseFactory,
      Dio? dioTestClient}) async {
    HttpResponse? userResponse;
    try {
      final timeoutDuration = timeout ?? Duration(seconds: 40);

      userResponse = await HttpClient.get('me',
              baseUrl: url,
              username: username,
              password: password,
              dioTestClient: dioTestClient)
          .timeout(timeoutDuration, onTimeout: () {
        throw TimeoutException('timeout connecting to $url', timeoutDuration);
      });

      if (userResponse.statusCode == 401) {
        throw AuthenticationException('Invalid Credentials',
            url: url,
            errorCode: DErrorCode.authInvalidCredentials,
            httpErrorCode: 401);
      }

      if (userResponse.statusCode == 500) {
        throw AuthenticationException(
            'AuthenticationException: ${userResponse.body.toString().substring(0, 255)}',
            username: username,
            url: url,
            errorCode: DErrorCode.apiError,
            stackTrace: StackTrace.current,
            httpErrorCode: userResponse.statusCode);
      }

      final uri = Uri.parse(url).host;
      final String databaseName = '${username}_$uri';

      await D2Remote.initialize(
          databaseName: databaseName,
          inMemory: inMemory,
          databaseFactory: databaseFactory);

      await D2Remote.setDatabaseName(
          databaseName: databaseName,
          sharedPreferenceInstance:
              sharedPreferenceInstance ?? SharedPreferences.getInstance());

      DUserQuery userQuery = DUserQuery();

      Map<String, dynamic> userData = userResponse.body;
      userData['password'] = password;
      userData['isLoggedIn'] = true;
      userData['checkWithServerTime'] = DateHelper.nowUtc();
      userData['username'] = username;
      userData['baseUrl'] = url;
      userData['authTye'] = 'basic';
      userData['dirty'] = true;

      final user = DUser.fromApi(userData);
      await userQuery.setData(user).save();

      return AuthenticationResult(success: true, sessionUser: user);
    } on TimeoutException catch (timeoutException) {
      throw AuthenticationException(
          'Authentication Timeout connecting to server',
          username: username,
          cause: timeoutException,
          url: url,
          errorCode: DErrorCode.networkTimeout,
          stackTrace: StackTrace.current,
          httpErrorCode: userResponse?.statusCode);
    } catch (e) {
      logError('$e', data: {"username": username, "url": url});
      rethrow;
    }
  }

  static Future<bool> logOut(
      {Future<SharedPreferences>? sharedPreferenceInstance}) async {
    WidgetsFlutterBinding.ensureInitialized();
    bool logOutSuccess = false;
    try {
      DUser? currentUser = await D2Remote.userModule.user.getOne();

      currentUser?.isLoggedIn = false;
      currentUser?.dirty = true;

      await D2Remote.userModule.user.setData(currentUser).save();

      // nmc
      SharedPreferences prefs =
          await (sharedPreferenceInstance ?? SharedPreferences.getInstance());
      prefs.remove(currentDatabaseNameKey);
      await DatabaseManager.instance.closeDatabase();

      // DatabaseManager
      logOutSuccess = true;
    } catch (e) {}
    return logOutSuccess;
  }

  static Future<LoginResponseStatus> setToken(
      {required String instanceUrl,
      required Map<String, dynamic> userObject,
      required Map<String, dynamic> tokenObject,
      Future<SharedPreferences>? sharedPreferenceInstance,
      bool? inMemory,
      DatabaseFactory? databaseFactory,
      Dio? dioTestClient}) async {
    final uri = Uri.parse(instanceUrl).host;
    final String databaseName = '$uri';
    await D2Remote.initialize(
        databaseName: databaseName,
        inMemory: inMemory,
        databaseFactory: databaseFactory);

    await D2Remote.setDatabaseName(
        databaseName: databaseName,
        sharedPreferenceInstance:
            sharedPreferenceInstance ?? SharedPreferences.getInstance());

    AuthToken token = AuthToken.fromJson(tokenObject);

    List<dynamic> authorities = [];

    userObject['token'] = token.accessToken;
    userObject['tokenType'] = token.tokenType;
    userObject['tokenExpiry'] = token.expiresIn;
    userObject['refreshToken'] = token.refreshToken;
    userObject['isLoggedIn'] = true;
    userObject['dirty'] = true;
    userObject['baseUrl'] = instanceUrl;
    userObject['authType'] = "token";
    userObject['authorities'] = authorities;

    final user = DUser.fromApi(userObject);
    await DUserQuery().setData(user).save();

    return LoginResponseStatus.ONLINE_LOGIN_SUCCESS;
  }

  static Future<List<Map>> rawQuery(
      {required String query, required List args}) async {
    final Database db = await DatabaseManager.instance.database;

    final List<Map> queryResult = await db.rawQuery(query.toString(), args);

    return queryResult;
  }

  static DUserModule userModule = DUserModule();

  static OrgUnitModule organisationUnitModuleD = OrgUnitModule();

  static DProjectModule projectModuleD = DProjectModule();

  static DActivityModule activityModuleD = DActivityModule();

  static DAssignmentModule assignmentModuleD = DAssignmentModule();

  static FormModule formModule = FormModule();

  static FormSubmissionModule formSubmissionModule = FormSubmissionModule();

  static DTeamModule teamModuleD = DTeamModule();
}
