import 'dart:convert';
import 'lookup_models.dart';

// ==================== API RESPONSE WRAPPER ====================

class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final String? error;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.error,
    this.statusCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
      'error': error,
      'statusCode': statusCode,
    };
  }
}

class PaginatedApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final SubmissionMeta? meta;
  final String? error;
  final int? statusCode;

  PaginatedApiResponse({
    required this.success,
    this.message,
    this.data,
    this.meta,
    this.error,
    this.statusCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
      'meta': meta?.toJson(),
      'error': error,
      'statusCode': statusCode,
    };
  }
}

// ==================== FOLDER MODELS ====================

class FolderItem {
  final int id;
  final String name;
  final String? iconUrl;

  FolderItem({
    required this.id,
    required this.name,
    this.iconUrl,
  });

  factory FolderItem.fromJson(Map<String, dynamic> json) {
    print('🔍 Parsing FolderItem from: $json');
    final item = FolderItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      iconUrl: json['iconUrl'],
    );
    print('🔍 Created FolderItem: ${item.name} (ID: ${item.id}, Icon: ${item.iconUrl})');
    return item;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconUrl': iconUrl,
    };
  }
}

class FolderResponse {
  final List<FolderItem> items;

  FolderResponse({required this.items});

  factory FolderResponse.fromJson(Map<String, dynamic> json) {
    print('🔍 Parsing FolderResponse from JSON: $json');
    final items = json['items'] as List<dynamic>? ?? [];
    print('🔍 Found ${items.length} items in response');
    
    final folderItems = items.map((item) {
      print('🔍 Parsing item: $item');
      return FolderItem.fromJson(item);
    }).toList();
    
    print('🔍 Created ${folderItems.length} FolderItem objects');
    return FolderResponse(items: folderItems);
  }
}

class DropboxResponse {
  final List<DropboxItem> items;

  DropboxResponse({required this.items});

  factory DropboxResponse.fromJson(Map<String, dynamic> json) {
    final items = json['items'] as List<dynamic>? ?? [];
    return DropboxResponse(
      items: items.map((item) => DropboxItem.fromJson(item)).toList(),
    );
  }
}

class DropboxItem {
  final String? url;

  DropboxItem({this.url});

  factory DropboxItem.fromJson(Map<String, dynamic> json) {
    return DropboxItem(
      url: json['url'],
    );
  }
}

// ==================== LOGIN MODELS ====================

class LoginResponse {
  final int? status;
  final LoginData? data;
  final String? error;

  LoginResponse({this.status, this.data, this.error});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    // Handle both old format (success) and new format (status)
    final status = json['status'] ?? (json['success'] == true ? 200 : null);
    
    return LoginResponse(
      status: status is int ? status : int.tryParse(status?.toString() ?? '200'),
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
      error: json['error']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.toJson(),
      'error': error,
    };
  }
}

class LoginData {
  final UserDetail? userDetail;
  final String? email;
  final String? token;
  final String? expiry;

  LoginData({this.userDetail, this.email, this.token, this.expiry});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      userDetail: json['userDetail'] != null ? UserDetail.fromJson(json['userDetail']) : null,
      email: json['email']?.toString(),
      token: json['token']?.toString(),
      expiry: json['expiry']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userDetail': userDetail?.toJson(),
      'email': email,
      'token': token,
      'expiry': expiry,
    };
  }
}

class UserDetail {
  final int? id;
  final String? name;
  final String? email;
  final String? userName;
  final String? username; // New field from API
  final String? fullName;
  final String? firstName; // New field from API
  final String? lastName; // New field from API
  final String? select2Text; // New field from API
  final String? errorMessage; // New field from API
  final bool? isValidationEnabled; // New field from API
  final List<String>? roles;
  final String? role;
  final bool? isApproved;
  final String? accessCode;
  final String? formattedAccessCode;
  final Contractor? contractor;
  final Company? company;
  final bool? changePassword;
  final bool? canAddLogs;
  final String? formattedCanAddLogs;
  final bool? disableNotifications;
  final String? formattedDisableNotifications;
  final String? activeStatus;
  final String? formattedStatus;
  final List<Association>? associations;

  UserDetail({
    this.id, this.name, this.email, this.userName, this.username, this.fullName, 
    this.firstName, this.lastName, this.select2Text, this.errorMessage, this.isValidationEnabled,
    this.roles, this.role, this.isApproved, this.accessCode, this.formattedAccessCode, 
    this.contractor, this.company, this.changePassword, this.canAddLogs, this.formattedCanAddLogs, 
    this.disableNotifications, this.formattedDisableNotifications, this.activeStatus, 
    this.formattedStatus, this.associations,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      userName: json['userName']?.toString() ?? json['username']?.toString(), // Support both
      username: json['username']?.toString(),
      fullName: json['fullName']?.toString(),
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      select2Text: json['select2Text']?.toString(),
      errorMessage: json['errorMessage']?.toString(),
      isValidationEnabled: json['isValidationEnabled'] ?? false,
      roles: (json['roles'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      role: json['role']?.toString(),
      isApproved: json['isApproved'] ?? false,
      accessCode: json['accessCode']?.toString(),
      formattedAccessCode: json['formattedAccessCode']?.toString(),
      contractor: json['contractor'] != null ? Contractor.fromJson(json['contractor']) : null,
      company: json['company'] != null ? Company.fromJson(json['company']) : null,
      changePassword: json['changePassword'] ?? false,
      canAddLogs: json['canAddLogs'] ?? false,
      formattedCanAddLogs: json['formattedCanAddLogs']?.toString(),
      disableNotifications: json['disableNotifications'] ?? false,
      formattedDisableNotifications: json['formattedDisableNotifications']?.toString(),
      activeStatus: json['activeStatus']?.toString(),
      formattedStatus: json['formattedStatus']?.toString(),
      associations: (json['associations'] as List<dynamic>?)
          ?.map((e) => Association.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, 'name': name, 'email': email, 'userName': userName ?? username, 
      'username': username, 'fullName': fullName, 'firstName': firstName, 'lastName': lastName,
      'select2Text': select2Text, 'errorMessage': errorMessage, 'isValidationEnabled': isValidationEnabled,
      'roles': roles, 'role': role, 'isApproved': isApproved, 'accessCode': accessCode,
      'formattedAccessCode': formattedAccessCode, 'contractor': contractor?.toJson(),
      'company': company?.toJson(), 'changePassword': changePassword, 'canAddLogs': canAddLogs,
      'formattedCanAddLogs': formattedCanAddLogs, 'disableNotifications': disableNotifications,
      'formattedDisableNotifications': formattedDisableNotifications, 'activeStatus': activeStatus,
      'formattedStatus': formattedStatus, 'associations': associations?.map((e) => e.toJson()).toList(),
    };
  }
}

class Contractor {
  final int? id;
  final String? name;

  Contractor({this.id, this.name});

  factory Contractor.fromJson(Map<String, dynamic> json) {
    return Contractor(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class Company {
  final int? id;
  final String? name;

  Company({this.id, this.name});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class Association {
  final Department? department;
  final Unit? unit;

  Association({this.department, this.unit});

  factory Association.fromJson(Map<String, dynamic> json) {
    return Association(
      department: json['department'] != null ? Department.fromJson(json['department']) : null,
      unit: json['unit'] != null ? Unit.fromJson(json['unit']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'department': department?.toJson(),
      'unit': unit?.toJson(),
    };
  }
}

class Department {
  final int? id;
  final String? name;

  Department({this.id, this.name});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class Unit {
  final int? id;
  final String? name;

  Unit({this.id, this.name});

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

// ==================== NOTIFICATION MODELS ====================

class NotificationData {
  final List<NotificationItem>? items;
  final List<dynamic>? links;
  final NotificationMeta? meta;

  NotificationData({this.items, this.links, this.meta});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      links: json['_links'] as List<dynamic>?,
      meta: json['_meta'] != null ? NotificationMeta.fromJson(json['_meta']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items?.map((e) => e.toJson()).toList(),
      '_links': links,
      '_meta': meta?.toJson(),
    };
  }
}

class NotificationMeta {
  final int? currentPage;
  final int? perPage;
  final int? totalCount;
  final int? pageCount;

  NotificationMeta({
    this.currentPage, this.perPage, this.totalCount, this.pageCount,
  });

  factory NotificationMeta.fromJson(Map<String, dynamic> json) {
    return NotificationMeta(
      currentPage: json['currentPage'] is int 
          ? json['currentPage'] 
          : int.tryParse(json['currentPage']?.toString() ?? '1'),
      perPage: json['perPage'] is int 
          ? json['perPage'] 
          : int.tryParse(json['perPage']?.toString() ?? '15'),
      totalCount: json['totalCount'] is int 
          ? json['totalCount'] 
          : int.tryParse(json['totalCount']?.toString() ?? '0'),
      pageCount: json['pageCount'] is int 
          ? json['pageCount'] 
          : int.tryParse(json['pageCount']?.toString() ?? '1'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage, 'perPage': perPage, 'totalCount': totalCount, 'pageCount': pageCount,
    };
  }
}

class NotificationItem {
  final String? id;
  final int? logId;
  final String? sendTo; // Changed from int to String
  final String? title;
  final String? subject;
  final NotificationMessage? message; // Changed from dynamic to NotificationMessage
  final dynamic user;
  final String? type;
  final int? entityId;
  final String? entityType;
  final String? eventType;
  final String? identifierKey;
  final String? identifierValue;
  final int? departmentId;
  final String? department;
  final int? unitId;
  final String? unit;
  final int? requestorId;
  final String? requestor;
  final int? approverId;
  final String? approver;
  final String? createdOn;
  final String? formattedCreatedOn;
  final bool? isReadStatus; // Added read status field

  NotificationItem({
    this.id, this.logId, this.sendTo, this.title, this.subject, this.message, this.user, this.type,
    this.entityId, this.entityType, this.eventType, this.identifierKey, this.identifierValue,
    this.departmentId, this.department, this.unitId, this.unit, this.requestorId, this.requestor,
    this.approverId, this.approver, this.createdOn, this.formattedCreatedOn, this.isReadStatus,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id']?.toString(),
      logId: json['logId'] is int ? json['logId'] : int.tryParse(json['logId']?.toString() ?? '0'),
      sendTo: json['sendTo']?.toString(),
      title: json['title']?.toString(),
      subject: json['subject']?.toString(),
      message: _parseMessage(json['message']), // Use helper method
      user: json['user'],
      type: json['type']?.toString(),
      entityId: json['entityId'] is int ? json['entityId'] : int.tryParse(json['entityId']?.toString() ?? '0'),
      entityType: json['entityType']?.toString(),
      eventType: json['eventType']?.toString(),
      identifierKey: json['identifierKey']?.toString(),
      identifierValue: json['identifierValue']?.toString(),
      departmentId: json['departmentId'] is int ? json['departmentId'] : int.tryParse(json['departmentId']?.toString() ?? '0'),
      department: json['department']?.toString(),
      unitId: json['unitId'] is int ? json['unitId'] : int.tryParse(json['unitId']?.toString() ?? '0'),
      unit: json['unit']?.toString(),
      requestorId: json['requestorId'] is int ? json['requestorId'] : int.tryParse(json['requestorId']?.toString() ?? '0'),
      requestor: json['requestor']?.toString(),
      approverId: json['approverId'] is int ? json['approverId'] : int.tryParse(json['approverId']?.toString() ?? '0'),
      approver: json['approver']?.toString(),
      createdOn: json['createdOn']?.toString(),
      formattedCreatedOn: json['formattedCreatedOn']?.toString(),
      isReadStatus: json['isRead'] ?? false, // Parse read status, default to false
    );
  }

  // Helper method to parse message field which can be String or Map
  static NotificationMessage? _parseMessage(dynamic messageData) {
    if (messageData == null) return null;
    
    try {
      if (messageData is Map<String, dynamic>) {
        // Already parsed as Map
        return NotificationMessage.fromJson(messageData);
      } else if (messageData is String) {
        // Parse JSON string
        final Map<String, dynamic> parsed = jsonDecode(messageData);
        return NotificationMessage.fromJson(parsed);
      }
    } catch (e) {
      print('Error parsing notification message: $e');
    }
    
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'logId': logId,
      'sendTo': sendTo,
      'title': title,
      'subject': subject,
      'message': message?.toJson(),
      'user': user,
      'type': type,
      'entityId': entityId,
      'entityType': entityType,
      'eventType': eventType,
      'identifierKey': identifierKey,
      'identifierValue': identifierValue,
      'departmentId': departmentId,
      'department': department,
      'unitId': unitId,
      'unit': unit,
      'requestorId': requestorId,
      'requestor': requestor,
      'approverId': approverId,
      'approver': approver,
      'createdOn': createdOn,
      'formattedCreatedOn': formattedCreatedOn,
      'isRead': isReadStatus,
    };
  }

  // Helper methods to extract data from message
  String? get messageTitle => message?.title;

  String? get messageText => message?.messageText;

  // Get display title (prefer message title over notification title)
  String? get displayTitle {
    return messageTitle ?? title ?? 'Notification';
  }

  // Get display message
  String? get displayMessage {
    return messageText ?? subject ?? 'No message available';
  }

  // Check if notification is read
  bool get isRead {
    return isReadStatus ?? false;
  }
}

class NotificationMessage {
  final int? logId;
  final int? entityId;
  final String? entityType;
  final int? logType;
  final String? messageText;
  final String? title;

  NotificationMessage({
    this.logId,
    this.entityId,
    this.entityType,
    this.logType,
    this.messageText,
    this.title,
  });

  factory NotificationMessage.fromJson(Map<String, dynamic> json) {
    return NotificationMessage(
      logId: json['LogId'] is int
          ? json['LogId']
          : int.tryParse(json['LogId']?.toString() ?? '0'),
      entityId: json['EntityId'] is int
          ? json['EntityId']
          : int.tryParse(json['EntityId']?.toString() ?? '0'),
      entityType: json['EntityType']?.toString(),
      logType: json['LogType'] is int
          ? json['LogType']
          : int.tryParse(json['LogType']?.toString() ?? '0'),
      messageText: json['Message']?.toString(),
      title: json['Title']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'LogId': logId,
      'EntityId': entityId,
      'EntityType': entityType,
      'LogType': logType,
      'Message': messageText,
      'Title': title,
    };
  }
}

// ==================== SUBMISSIONS MODELS ====================

// Common Models for Submissions
class Employee {
  final String? name;
  final String? email;
  final String? errorMessage;
  final bool? isValidationEnabled;
  final int? id;

  Employee({this.name, this.email, this.errorMessage, this.isValidationEnabled, this.id});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      errorMessage: json['errorMessage']?.toString(),
      isValidationEnabled: json['isValidationEnabled'] ?? false,
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'errorMessage': errorMessage, 'isValidationEnabled': isValidationEnabled, 'id': id};
  }
}

// TOT Log Models
class TOTLogData {
  final List<TOTLogItem>? items;
  final List<dynamic>? links;
  final SubmissionMeta? meta;

  TOTLogData({this.items, this.links, this.meta});

  factory TOTLogData.fromJson(Map<String, dynamic> json) {
    return TOTLogData(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => TOTLogItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      links: json['_links'] as List<dynamic>?,
      meta: json['_meta'] != null ? SubmissionMeta.fromJson(json['_meta']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items?.map((e) => e.toJson()).toList(),
      '_links': links,
      '_meta': meta?.toJson(),
    };
  }
}

class TOTLogItem {
  final int? id;
  final String? date;
  final String? formattedDate;
  final String? createdOn;
  final String? formattedCreatedOn;
  final String? formattedCreatedTime;
  final String? formattedCreatedDate;
  final String? permitNo;
  final String? delayDescription;
  final String? workScope;
  final String? twr;
  final TWRModel? twrModel;
  final double? manHours;
  final String? startOfWork;
  final String? formattedStartOfWork;
  final String? timeRequested;
  final String? formattedTimeRequested;
  final String? timeSigned;
  final String? formattedTimeSigned;
  final String? comment;
  final String? reasonForRequest;
  final String? jobDescription;
  final int? manPowerAffected;
  final double? totalHours;
  final String? equipmentNo;
  final double? hoursDelayed;
  final Department? department;
  final Unit? unit;
  final Contractor? contractor;
  final DelayType? startOfWorkDelay;
  final DelayType? ongoingWorkDelay;
  final DelayType? shiftDelay;
  final DelayType? reworkDelay;
  final PermitType? permitType;
  final Shift? shift;
  final DelayType? delayType;
  final String? delayReason;
  final Company? company;
  final List<dynamic>? possibleApprovers;
  final String? foreman;
  final String? permittingIssue;
  final bool? isUnauthenticatedApproval;
  final String? notificationId;
  final String? status;
  final bool? isEditRestricted;
  final bool? isArchived;
  final String? formattedStatus;
  final String? loggedInUserRole;
  final int? loggedInUserId;
  final bool? canProcess;
  final bool? canUpdate;
  final bool? canDelete;
  final String? formattedStatusForView;
  final Approver? approver;
  final Employee? employee;
  final int? activeStatus;

  TOTLogItem({
    this.id, this.date, this.formattedDate, this.createdOn, this.formattedCreatedOn,
    this.formattedCreatedTime, this.formattedCreatedDate, this.permitNo, this.delayDescription,
    this.workScope, this.twr, this.twrModel, this.manHours, this.startOfWork, this.formattedStartOfWork,
    this.timeRequested, this.formattedTimeRequested, this.timeSigned, this.formattedTimeSigned,
    this.comment, this.reasonForRequest, this.jobDescription, this.manPowerAffected, this.totalHours,
    this.equipmentNo, this.hoursDelayed, this.department, this.unit, this.contractor,
    this.startOfWorkDelay, this.ongoingWorkDelay, this.shiftDelay, this.reworkDelay,
    this.permitType, this.shift, this.delayType, this.delayReason, this.company,
    this.possibleApprovers, this.foreman, this.permittingIssue, this.isUnauthenticatedApproval,
    this.notificationId, this.status, this.isEditRestricted, this.isArchived, this.formattedStatus,
    this.loggedInUserRole, this.loggedInUserId, this.canProcess, this.canUpdate, this.canDelete,
    this.formattedStatusForView, this.approver, this.employee, this.activeStatus,
  });

  factory TOTLogItem.fromJson(Map<String, dynamic> json) {
    return TOTLogItem(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      date: json['date']?.toString(),
      formattedDate: json['formattedDate']?.toString(),
      createdOn: json['createdOn']?.toString(),
      formattedCreatedOn: json['formattedCreatedOn']?.toString(),
      formattedCreatedTime: json['formattedCreatedTime']?.toString(),
      formattedCreatedDate: json['formattedCreatedDate']?.toString(),
      permitNo: json['permitNo']?.toString(),
      delayDescription: json['delayDescription']?.toString(),
      workScope: json['workScope']?.toString(),
      twr: json['twr']?.toString(),
      twrModel: json['twrModel'] != null ? TWRModel.fromJson(json['twrModel']) : null,
      manHours: json['manHours'] is double ? json['manHours'] : double.tryParse(json['manHours']?.toString() ?? '0.0'),
      startOfWork: json['startOfWork']?.toString(),
      formattedStartOfWork: json['formattedStartOfWork']?.toString(),
      timeRequested: json['timeRequested']?.toString(),
      formattedTimeRequested: json['formattedTimeRequested']?.toString(),
      timeSigned: json['timeSigned']?.toString(),
      formattedTimeSigned: json['formattedTimeSigned']?.toString(),
      comment: json['comment']?.toString(),
      reasonForRequest: json['reasonForRequest']?.toString(),
      jobDescription: json['jobDescription']?.toString(),
      manPowerAffected: json['manPowerAffected'] is int ? json['manPowerAffected'] : int.tryParse(json['manPowerAffected']?.toString() ?? '0'),
      totalHours: json['totalHours'] is double ? json['totalHours'] : double.tryParse(json['totalHours']?.toString() ?? '0.0'),
      equipmentNo: json['equipmentNo']?.toString(),
      hoursDelayed: json['hoursDelayed'] is double ? json['hoursDelayed'] : double.tryParse(json['hoursDelayed']?.toString() ?? '0.0'),
      department: json['department'] != null ? Department.fromJson(json['department']) : null,
      unit: json['unit'] != null ? Unit.fromJson(json['unit']) : null,
      contractor: json['contractor'] != null ? Contractor.fromJson(json['contractor']) : null,
      startOfWorkDelay: json['startOfWorkDelay'] != null ? DelayType.fromJson(json['startOfWorkDelay']) : null,
      ongoingWorkDelay: json['ongoingWorkDelay'] != null ? DelayType.fromJson(json['ongoingWorkDelay']) : null,
      shiftDelay: json['shiftDelay'] != null ? DelayType.fromJson(json['shiftDelay']) : null,
      reworkDelay: json['reworkDelay'] != null ? DelayType.fromJson(json['reworkDelay']) : null,
      permitType: json['permitType'] != null ? PermitType.fromJson(json['permitType']) : null,
      shift: json['shift'] != null ? Shift.fromJson(json['shift']) : null,
      delayType: json['delayType'] != null ? DelayType.fromJson(json['delayType']) : null,
      delayReason: json['delayReason']?.toString(),
      company: json['company'] != null ? Company.fromJson(json['company']) : null,
      possibleApprovers: json['possibleApprovers'] is List 
          ? json['possibleApprovers'] as List<dynamic>?
          : null,
      foreman: json['foreman']?.toString(),
      permittingIssue: json['permittingIssue']?.toString(),
      isUnauthenticatedApproval: json['isUnauthenticatedApproval'] ?? false,
      notificationId: json['notificationId']?.toString(),
      status: json['status']?.toString(),
      isEditRestricted: json['isEditRestricted'] ?? false,
      isArchived: json['isArchived'] ?? false,
      formattedStatus: json['formattedStatus']?.toString(),
      loggedInUserRole: json['loggedInUserRole']?.toString(),
      loggedInUserId: json['loggedInUserId'] is int ? json['loggedInUserId'] : int.tryParse(json['loggedInUserId']?.toString() ?? '0'),
      canProcess: json['canProcess'] ?? false,
      canUpdate: json['canUpdate'] ?? false,
      canDelete: json['canDelete'] ?? false,
      formattedStatusForView: json['formattedStatusForView']?.toString(),
      approver: json['approver'] != null ? Approver.fromJson(json['approver']) : null,
      employee: json['employee'] != null ? Employee.fromJson(json['employee']) : null,
      activeStatus: json['activeStatus'] is int ? json['activeStatus'] : int.tryParse(json['activeStatus']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, 'date': date, 'formattedDate': formattedDate, 'createdOn': createdOn,
      'formattedCreatedOn': formattedCreatedOn, 'formattedCreatedTime': formattedCreatedTime,
      'formattedCreatedDate': formattedCreatedDate, 'permitNo': permitNo, 'delayDescription': delayDescription,
      'workScope': workScope, 'twr': twr, 'twrModel': twrModel?.toJson(), 'manHours': manHours,
      'startOfWork': startOfWork, 'formattedStartOfWork': formattedStartOfWork, 'timeRequested': timeRequested,
      'formattedTimeRequested': formattedTimeRequested, 'timeSigned': timeSigned, 'formattedTimeSigned': formattedTimeSigned,
      'comment': comment, 'reasonForRequest': reasonForRequest, 'jobDescription': jobDescription,
      'manPowerAffected': manPowerAffected, 'totalHours': totalHours, 'equipmentNo': equipmentNo,
      'hoursDelayed': hoursDelayed, 'department': department?.toJson(), 'unit': unit?.toJson(),
      'contractor': contractor?.toJson(), 'startOfWorkDelay': startOfWorkDelay?.toJson(),
      'ongoingWorkDelay': ongoingWorkDelay?.toJson(), 'shiftDelay': shiftDelay?.toJson(),
      'reworkDelay': reworkDelay?.toJson(), 'permitType': permitType?.toJson(), 'shift': shift?.toJson(),
      'delayType': delayType?.toJson(), 'delayReason': delayReason, 'company': company?.toJson(),
      'possibleApprovers': possibleApprovers, 'foreman': foreman, 'permittingIssue': permittingIssue,
      'isUnauthenticatedApproval': isUnauthenticatedApproval, 'notificationId': notificationId,
      'status': status, 'isEditRestricted': isEditRestricted, 'isArchived': isArchived,
      'formattedStatus': formattedStatus, 'loggedInUserRole': loggedInUserRole,
      'loggedInUserId': loggedInUserId, 'canProcess': canProcess, 'canUpdate': canUpdate,
      'canDelete': canDelete, 'formattedStatusForView': formattedStatusForView,
      'approver': approver?.toJson(), 'employee': employee?.toJson(), 'activeStatus': activeStatus,
    };
  }
}

// Override Log Models
class OverrideLogData {
  final List<OverrideLogItem>? items;
  final List<dynamic>? links;
  final SubmissionMeta? meta;

  OverrideLogData({this.items, this.links, this.meta});

  factory OverrideLogData.fromJson(Map<String, dynamic> json) {
    return OverrideLogData(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => OverrideLogItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      links: json['_links'] as List<dynamic>?,
      meta: json['_meta'] != null ? SubmissionMeta.fromJson(json['_meta']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items?.map((e) => e.toJson()).toList(),
      '_links': links,
      '_meta': meta?.toJson(),
    };
  }
}

class OverrideLogItem {
  final int? id;
  final String? createdOn;
  final String? formattedCreatedOn;
  final String? formattedCreatedTime;
  final String? formattedCreatedDate;
  final String? workCompletedDate;
  final String? formattedDateOfWorkCompleted;
  final double? totalCost;
  final double? totalHours;
  final double? totalHeadCount;
  final String? description;
  final String? workScope;
  final int? poNumber;
  final String? overrideCategory;
  final Unit? unit;
  final Shift? shift;
  final String? reasonForRequest;
  final CraftRate? craftRate;
  final String? delayReason;
  final DelayType? startOfWorkDelay;
  final DelayType? shiftDelay;
  final DelayType? reworkDelay;
  final DelayType? delayType;
  final Company? company;
  final List<OverrideCost>? costs;
  final double? totalSTHours;
  final double? totalOTHours;
  final double? totalDTHours;
  final Department? department;
  final String? reason;
  final List<dynamic>? possibleApprovers;
  final String? employeeNames;
  final String? clippedEmployeesUrl;
  final String? domainUrl;
  final String? formattedClippedEmployeeUrl;
  final String? comment;
  final bool? isUnauthenticatedApproval;
  final String? notificationId;
  final String? status;
  final bool? isEditRestricted;
  final bool? isArchived;
  final String? formattedStatus;
  final String? loggedInUserRole;
  final int? loggedInUserId;
  final bool? canProcess;
  final bool? canUpdate;
  final bool? canDelete;
  final String? formattedStatusForView;
  final Approver? approver;
  final Employee? employee;
  final int? activeStatus;

  OverrideLogItem({
    this.id, this.createdOn, this.formattedCreatedOn, this.formattedCreatedTime,
    this.formattedCreatedDate, this.workCompletedDate, this.formattedDateOfWorkCompleted,
    this.totalCost, this.totalHours, this.totalHeadCount, this.description, this.workScope,
    this.poNumber, this.overrideCategory, this.unit, this.shift, this.reasonForRequest,
    this.craftRate, this.delayReason, this.startOfWorkDelay, this.shiftDelay, this.reworkDelay,
    this.delayType, this.company, this.costs, this.totalSTHours, this.totalOTHours,
    this.totalDTHours, this.department, this.reason, this.possibleApprovers, this.employeeNames,
    this.clippedEmployeesUrl, this.domainUrl, this.formattedClippedEmployeeUrl, this.comment,
    this.isUnauthenticatedApproval, this.notificationId, this.status, this.isEditRestricted,
    this.isArchived, this.formattedStatus, this.loggedInUserRole, this.loggedInUserId,
    this.canProcess, this.canUpdate, this.canDelete, this.formattedStatusForView,
    this.approver, this.employee, this.activeStatus,
  });

  factory OverrideLogItem.fromJson(Map<String, dynamic> json) {
    return OverrideLogItem(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      createdOn: json['createdOn']?.toString(),
      formattedCreatedOn: json['formattedCreatedOn']?.toString(),
      formattedCreatedTime: json['formattedCreatedTime']?.toString(),
      formattedCreatedDate: json['formattedCreatedDate']?.toString(),
      workCompletedDate: json['workCompletedDate']?.toString(),
      formattedDateOfWorkCompleted: json['formattedDateOfWorkCompleted']?.toString(),
      totalCost: json['totalCost'] is double ? json['totalCost'] : double.tryParse(json['totalCost']?.toString() ?? '0.0'),
      totalHours: json['totalHours'] is double ? json['totalHours'] : double.tryParse(json['totalHours']?.toString() ?? '0.0'),
      totalHeadCount: json['totalHeadCount'] is double ? json['totalHeadCount'] : double.tryParse(json['totalHeadCount']?.toString() ?? '0.0'),
      description: json['description']?.toString(),
      workScope: json['workScope']?.toString(),
      poNumber: json['poNumber'] is int ? json['poNumber'] : int.tryParse(json['poNumber']?.toString() ?? '0'),
      overrideCategory: json['overrideCategory']?.toString(),
      unit: json['unit'] != null ? Unit.fromJson(json['unit']) : null,
      shift: json['shift'] != null ? Shift.fromJson(json['shift']) : null,
      reasonForRequest: json['reasonForRequest']?.toString(),
      craftRate: json['craftRate'] != null ? CraftRate.fromJson(json['craftRate']) : null,
      delayReason: json['delayReason']?.toString(),
      startOfWorkDelay: json['startOfWorkDelay'] != null ? DelayType.fromJson(json['startOfWorkDelay']) : null,
      shiftDelay: json['shiftDelay'] != null ? DelayType.fromJson(json['shiftDelay']) : null,
      reworkDelay: json['reworkDelay'] != null ? DelayType.fromJson(json['reworkDelay']) : null,
      delayType: json['delayType'] != null ? DelayType.fromJson(json['delayType']) : null,
      company: json['company'] != null ? Company.fromJson(json['company']) : null,
      costs: (json['costs'] as List<dynamic>?)
          ?.map((e) => OverrideCost.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalSTHours: json['totalSTHours'] is double ? json['totalSTHours'] : double.tryParse(json['totalSTHours']?.toString() ?? '0.0'),
      totalOTHours: json['totalOTHours'] is double ? json['totalOTHours'] : double.tryParse(json['totalOTHours']?.toString() ?? '0.0'),
      totalDTHours: json['totalDTHours'] is double ? json['totalDTHours'] : double.tryParse(json['totalDTHours']?.toString() ?? '0.0'),
      department: json['department'] != null ? Department.fromJson(json['department']) : null,
      reason: json['reason']?.toString(),
      possibleApprovers: json['possibleApprovers'] is List 
          ? json['possibleApprovers'] as List<dynamic>?
          : null,
      employeeNames: json['employeeNames']?.toString(),
      clippedEmployeesUrl: json['clippedEmployeesUrl']?.toString(),
      domainUrl: json['domainUrl']?.toString(),
      formattedClippedEmployeeUrl: json['formattedClippedEmployeeUrl']?.toString(),
      comment: json['comment']?.toString(),
      isUnauthenticatedApproval: json['isUnauthenticatedApproval'] ?? false,
      notificationId: json['notificationId']?.toString(),
      status: json['status']?.toString(),
      isEditRestricted: json['isEditRestricted'] ?? false,
      isArchived: json['isArchived'] ?? false,
      formattedStatus: json['formattedStatus']?.toString(),
      loggedInUserRole: json['loggedInUserRole']?.toString(),
      loggedInUserId: json['loggedInUserId'] is int ? json['loggedInUserId'] : int.tryParse(json['loggedInUserId']?.toString() ?? '0'),
      canProcess: json['canProcess'] ?? false,
      canUpdate: json['canUpdate'] ?? false,
      canDelete: json['canDelete'] ?? false,
      formattedStatusForView: json['formattedStatusForView']?.toString(),
      approver: json['approver'] != null ? Approver.fromJson(json['approver']) : null,
      employee: json['employee'] != null ? Employee.fromJson(json['employee']) : null,
      activeStatus: json['activeStatus'] is int ? json['activeStatus'] : int.tryParse(json['activeStatus']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, 'createdOn': createdOn, 'formattedCreatedOn': formattedCreatedOn,
      'formattedCreatedTime': formattedCreatedTime, 'formattedCreatedDate': formattedCreatedDate,
      'workCompletedDate': workCompletedDate, 'formattedDateOfWorkCompleted': formattedDateOfWorkCompleted,
      'totalCost': totalCost, 'totalHours': totalHours, 'totalHeadCount': totalHeadCount,
      'description': description, 'workScope': workScope, 'poNumber': poNumber,
      'overrideCategory': overrideCategory, 'unit': unit?.toJson(), 'shift': shift?.toJson(),
      'reasonForRequest': reasonForRequest, 'craftRate': craftRate?.toJson(),
      'delayReason': delayReason, 'startOfWorkDelay': startOfWorkDelay?.toJson(),
      'shiftDelay': shiftDelay?.toJson(), 'reworkDelay': reworkDelay?.toJson(),
      'delayType': delayType?.toJson(), 'company': company?.toJson(),
      'costs': costs?.map((e) => e.toJson()).toList(), 'totalSTHours': totalSTHours,
      'totalOTHours': totalOTHours, 'totalDTHours': totalDTHours, 'department': department?.toJson(),
      'reason': reason, 'possibleApprovers': possibleApprovers, 'employeeNames': employeeNames,
      'clippedEmployeesUrl': clippedEmployeesUrl, 'domainUrl': domainUrl,
      'formattedClippedEmployeeUrl': formattedClippedEmployeeUrl, 'comment': comment,
      'isUnauthenticatedApproval': isUnauthenticatedApproval, 'notificationId': notificationId,
      'status': status, 'isEditRestricted': isEditRestricted, 'isArchived': isArchived,
      'formattedStatus': formattedStatus, 'loggedInUserRole': loggedInUserRole,
      'loggedInUserId': loggedInUserId, 'canProcess': canProcess, 'canUpdate': canUpdate,
      'canDelete': canDelete, 'formattedStatusForView': formattedStatusForView,
      'approver': approver?.toJson(), 'employee': employee?.toJson(), 'activeStatus': activeStatus,
    };
  }
}

// WRR Log Models
class WRRLogData {
  final List<WRRLogItem>? items;
  final List<dynamic>? links;
  final SubmissionMeta? meta;

  WRRLogData({this.items, this.links, this.meta});

  factory WRRLogData.fromJson(Map<String, dynamic> json) {
    return WRRLogData(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => WRRLogItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      links: json['_links'] as List<dynamic>?,
      meta: json['_meta'] != null ? SubmissionMeta.fromJson(json['_meta']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items?.map((e) => e.toJson()).toList(),
      '_links': links,
      '_meta': meta?.toJson(),
    };
  }
}

class WRRLogItem {
  final int? id;
  final String? createdOn;
  final String? formattedCreatedOn;
  final String? status;
  final String? formattedStatus;
  final String? dateRodReturned;
  final String? calibrationDate;
  final String? fumeControlUsed;
  final String? workScope;
  final String? email;
  final String? rodCheckedOut;
  final double? rodCheckedOutLbs;
  final double? rodReturnedWasteLbs;
  final String? comment;
  final String? activeStatus;
  final String? workCompletedDate;
  final String? formattedDateOfWorkCompleted;
  final Department? department;
  final Unit? unit;
  final Company? company;
  final Approver? approver;
  final Employee? employee;
  final RodType? rodType;
  final WeldMethod? weldMethod;
  final Location? location;
  final TWRModel? twrModel;
  final Shift? shift;

  WRRLogItem({
    this.id, this.createdOn, this.formattedCreatedOn, this.status, this.formattedStatus,
    this.dateRodReturned, this.calibrationDate, this.fumeControlUsed, this.workScope,
    this.email, this.rodCheckedOut, this.rodCheckedOutLbs, this.rodReturnedWasteLbs,
    this.comment, this.activeStatus, this.workCompletedDate, this.formattedDateOfWorkCompleted,
    this.department, this.unit, this.company, this.approver, this.employee, 
    this.rodType, this.weldMethod, this.location, this.twrModel, this.shift,
  });

  factory WRRLogItem.fromJson(Map<String, dynamic> json) {
    return WRRLogItem(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      createdOn: json['createdOn']?.toString(),
      formattedCreatedOn: json['formattedCreatedOn']?.toString(),
      status: json['status']?.toString(),
      formattedStatus: json['formattedStatus']?.toString(),
      dateRodReturned: json['dateRodReturned']?.toString(),
      calibrationDate: json['calibrationDate']?.toString(),
      fumeControlUsed: json['fumeControlUsed']?.toString(),
      workScope: json['workScope']?.toString(),
      email: json['email']?.toString(),
      rodCheckedOut: json['rodCheckedOut']?.toString(),
      rodCheckedOutLbs: json['rodCheckedOutLbs'] is double ? json['rodCheckedOutLbs'] : double.tryParse(json['rodCheckedOutLbs']?.toString() ?? '0'),
      rodReturnedWasteLbs: json['rodReturnedWasteLbs'] is double ? json['rodReturnedWasteLbs'] : double.tryParse(json['rodReturnedWasteLbs']?.toString() ?? '0'),
      comment: json['comment']?.toString(),
      activeStatus: json['activeStatus']?.toString(),
      workCompletedDate: json['workCompletedDate']?.toString(),
      formattedDateOfWorkCompleted: json['formattedDateOfWorkCompleted']?.toString(),
      department: json['department'] != null ? Department.fromJson(json['department']) : null,
      unit: json['unit'] != null ? Unit.fromJson(json['unit']) : null,
      company: json['company'] != null ? Company.fromJson(json['company']) : null,
      approver: json['approver'] != null ? Approver.fromJson(json['approver']) : null,
      employee: json['employee'] != null ? Employee.fromJson(json['employee']) : null,
      rodType: json['rodType'] != null ? RodType.fromJson(json['rodType']) : null,
      weldMethod: json['weldMethod'] != null ? WeldMethod.fromJson(json['weldMethod']) : null,
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      twrModel: json['twrModel'] != null ? TWRModel.fromJson(json['twrModel']) : null,
      shift: json['shift'] != null ? Shift.fromJson(json['shift']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, 'createdOn': createdOn, 'formattedCreatedOn': formattedCreatedOn,
      'status': status, 'formattedStatus': formattedStatus,
      'dateRodReturned': dateRodReturned, 'calibrationDate': calibrationDate,
      'fumeControlUsed': fumeControlUsed, 'workScope': workScope,
      'email': email, 'rodCheckedOut': rodCheckedOut,
      'rodCheckedOutLbs': rodCheckedOutLbs, 'rodReturnedWasteLbs': rodReturnedWasteLbs,
      'comment': comment, 'activeStatus': activeStatus,
      'workCompletedDate': workCompletedDate, 'formattedDateOfWorkCompleted': formattedDateOfWorkCompleted,
      'department': department?.toJson(), 'unit': unit?.toJson(),
      'company': company?.toJson(), 'approver': approver?.toJson(),
      'employee': employee?.toJson(), 'rodType': rodType?.toJson(),
      'weldMethod': weldMethod?.toJson(), 'location': location?.toJson(),
      'twrModel': twrModel?.toJson(), 'shift': shift?.toJson(),
    };
  }
}

// Common Models for Submissions
class SubmissionMeta {
  final int? currentPage;
  final int? perPage;
  final int? totalCount;
  final int? pageCount;

  SubmissionMeta({
    this.currentPage, this.perPage, this.totalCount, this.pageCount,
  });

  factory SubmissionMeta.fromJson(Map<String, dynamic> json) {
    return SubmissionMeta(
      currentPage: json['currentPage'] is int 
          ? json['currentPage'] 
          : int.tryParse(json['currentPage']?.toString() ?? '1'),
      perPage: json['perPage'] is int 
          ? json['perPage'] 
          : int.tryParse(json['perPage']?.toString() ?? '15'),
      totalCount: json['totalCount'] is int 
          ? json['totalCount'] 
          : int.tryParse(json['totalCount']?.toString() ?? '0'),
      pageCount: json['pageCount'] is int 
          ? json['pageCount'] 
          : int.tryParse(json['pageCount']?.toString() ?? '1'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage, 'perPage': perPage, 'totalCount': totalCount, 'pageCount': pageCount,
    };
  }
}

class TWRModel {
  final String? name;
  final NumericPart? numericPart;
  final AlphabeticPart? alphabeticPart;
  final String? text;

  TWRModel({this.name, this.numericPart, this.alphabeticPart, this.text});

  factory TWRModel.fromJson(Map<String, dynamic> json) {
    return TWRModel(
      name: json['name']?.toString(),
      numericPart: json['numericPart'] != null ? NumericPart.fromJson(json['numericPart']) : null,
      alphabeticPart: json['alphabeticPart'] != null ? AlphabeticPart.fromJson(json['alphabeticPart']) : null,
      text: json['text']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name, 'numericPart': numericPart?.toJson(), 'alphabeticPart': alphabeticPart?.toJson(), 'text': text,
    };
  }
}

class NumericPart {
  final int? id;
  final String? text;

  NumericPart({this.id, this.text});

  factory NumericPart.fromJson(Map<String, dynamic> json) {
    return NumericPart(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      text: json['text']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text};
  }
}

class AlphabeticPart {
  final int? id;
  final String? text;

  AlphabeticPart({this.id, this.text});

  factory AlphabeticPart.fromJson(Map<String, dynamic> json) {
    return AlphabeticPart(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      text: json['text']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text};
  }
}

class DelayType {
  final String? name;
  final String? identifier;
  final String? errorMessage;
  final bool? isValidationEnabled;
  final int? id;

  DelayType({this.name, this.identifier, this.errorMessage, this.isValidationEnabled, this.id});

  factory DelayType.fromJson(Map<String, dynamic> json) {
    return DelayType(
      name: json['name']?.toString(),
      identifier: json['identifier']?.toString(),
      errorMessage: json['errorMessage']?.toString(),
      isValidationEnabled: json['isValidationEnabled'] ?? false,
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name, 'identifier': identifier, 'errorMessage': errorMessage,
      'isValidationEnabled': isValidationEnabled, 'id': id,
    };
  }
}

class PermitType {
  final String? name;
  final String? errorMessage;
  final bool? isValidationEnabled;
  final int? id;

  PermitType({this.name, this.errorMessage, this.isValidationEnabled, this.id});

  factory PermitType.fromJson(Map<String, dynamic> json) {
    return PermitType(
      name: json['name']?.toString(),
      errorMessage: json['errorMessage']?.toString(),
      isValidationEnabled: json['isValidationEnabled'] ?? false,
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'errorMessage': errorMessage, 'isValidationEnabled': isValidationEnabled, 'id': id};
  }
}

class Shift {
  final String? name;
  final String? errorMessage;
  final bool? isValidationEnabled;
  final int? id;

  Shift({this.name, this.errorMessage, this.isValidationEnabled, this.id});

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      name: json['name']?.toString(),
      errorMessage: json['errorMessage']?.toString(),
      isValidationEnabled: json['isValidationEnabled'] ?? false,
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'errorMessage': errorMessage, 'isValidationEnabled': isValidationEnabled, 'id': id};
  }
}

class CraftRate {
  final double? rate;
  final String? name;
  final String? errorMessage;
  final bool? isValidationEnabled;
  final int? id;

  CraftRate({this.rate, this.name, this.errorMessage, this.isValidationEnabled, this.id});

  factory CraftRate.fromJson(Map<String, dynamic> json) {
    return CraftRate(
      rate: json['rate'] is double ? json['rate'] : double.tryParse(json['rate']?.toString() ?? '0.0'),
      name: json['name']?.toString(),
      errorMessage: json['errorMessage']?.toString(),
      isValidationEnabled: json['isValidationEnabled'] ?? false,
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {'rate': rate, 'name': name, 'errorMessage': errorMessage, 'isValidationEnabled': isValidationEnabled, 'id': id};
  }
}

class OverrideCost {
  final int? id;
  final String? overrideHours;
  final String? overrideType;
  final int? headCount;
  final CraftSkill? craftSkill;
  final String? employeeName;
  final int? poNumber;
  final String? poNumberValue;
  final double? stHours;
  final double? otHours;
  final double? dtHours;
  final int? overrideLogId;
  final double? cost;
  final double? craftRate;
  final String? formattedCraftRate;
  final String? formattedCost;

  OverrideCost({
    this.id, this.overrideHours, this.overrideType, this.headCount, this.craftSkill,
    this.employeeName, this.poNumber, this.poNumberValue, this.stHours, this.otHours,
    this.dtHours, this.overrideLogId, this.cost, this.craftRate, this.formattedCraftRate, this.formattedCost,
  });

  factory OverrideCost.fromJson(Map<String, dynamic> json) {
    return OverrideCost(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      overrideHours: json['overrideHours']?.toString(),
      overrideType: json['overrideType']?.toString(),
      headCount: json['headCount'] is int ? json['headCount'] : int.tryParse(json['headCount']?.toString() ?? '0'),
      craftSkill: json['craftSkill'] != null ? CraftSkill.fromJson(json['craftSkill']) : null,
      employeeName: json['employeeName']?.toString(),
      poNumber: json['poNumber'] is int ? json['poNumber'] : int.tryParse(json['poNumber']?.toString() ?? '0'),
      poNumberValue: json['poNumberValue']?.toString(),
      stHours: json['stHours'] is double ? json['stHours'] : double.tryParse(json['stHours']?.toString() ?? '0.0'),
      otHours: json['otHours'] is double ? json['otHours'] : double.tryParse(json['otHours']?.toString() ?? '0.0'),
      dtHours: json['dtHours'] is double ? json['dtHours'] : double.tryParse(json['dtHours']?.toString() ?? '0.0'),
      overrideLogId: json['overrideLogId'] is int ? json['overrideLogId'] : int.tryParse(json['overrideLogId']?.toString() ?? '0'),
      cost: json['cost'] is double ? json['cost'] : double.tryParse(json['cost']?.toString() ?? '0.0'),
      craftRate: json['craftRate'] is double ? json['craftRate'] : double.tryParse(json['craftRate']?.toString() ?? '0.0'),
      formattedCraftRate: json['formattedCraftRate']?.toString(),
      formattedCost: json['formattedCost']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, 'overrideHours': overrideHours, 'overrideType': overrideType, 'headCount': headCount,
      'craftSkill': craftSkill?.toJson(), 'employeeName': employeeName, 'poNumber': poNumber,
      'poNumberValue': poNumberValue, 'stHours': stHours, 'otHours': otHours, 'dtHours': dtHours,
      'overrideLogId': overrideLogId, 'cost': cost, 'craftRate': craftRate,
      'formattedCraftRate': formattedCraftRate, 'formattedCost': formattedCost,
    };
  }
}

class CraftSkill {
  final String? name;
  final double? stRate;
  final double? otRate;
  final double? dtRate;
  final String? errorMessage;
  final bool? isValidationEnabled;
  final int? id;

  CraftSkill({
    this.name, this.stRate, this.otRate, this.dtRate, this.errorMessage, this.isValidationEnabled, this.id,
  });

  factory CraftSkill.fromJson(Map<String, dynamic> json) {
    return CraftSkill(
      name: json['name']?.toString(),
      stRate: json['stRate'] is double ? json['stRate'] : double.tryParse(json['stRate']?.toString() ?? '0.0'),
      otRate: json['otRate'] is double ? json['otRate'] : double.tryParse(json['otRate']?.toString() ?? '0.0'),
      dtRate: json['dtRate'] is double ? json['dtRate'] : double.tryParse(json['dtRate']?.toString() ?? '0.0'),
      errorMessage: json['errorMessage']?.toString(),
      isValidationEnabled: json['isValidationEnabled'] ?? false,
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name, 'stRate': stRate, 'otRate': otRate, 'dtRate': dtRate,
      'errorMessage': errorMessage, 'isValidationEnabled': isValidationEnabled, 'id': id,
    };
  }
}

class Approver {
  final String? name;
  final String? email;
  final String? errorMessage;
  final bool? isValidationEnabled;
  final int? id;

  Approver({this.name, this.email, this.errorMessage, this.isValidationEnabled, this.id});

  factory Approver.fromJson(Map<String, dynamic> json) {
    return Approver(
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      errorMessage: json['errorMessage']?.toString(),
      isValidationEnabled: json['isValidationEnabled'] ?? false,
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'errorMessage': errorMessage, 'isValidationEnabled': isValidationEnabled, 'id': id};
  }
}

// ==================== ADDITIONAL RESPONSE MODELS ====================

class LookupResponse {
  final int? id;
  final String? name;
  final String? value;
  final String? description;

  LookupResponse({this.id, this.name, this.value, this.description});

  factory LookupResponse.fromJson(Map<String, dynamic> json) {
    return LookupResponse(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name']?.toString(),
      value: json['value']?.toString(),
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'description': description,
    };
  }
}

class DashboardChartsResponse {
  final Map<String, dynamic>? data;

  DashboardChartsResponse({this.data});

  factory DashboardChartsResponse.fromJson(Map<String, dynamic> json) {
    return DashboardChartsResponse(
      data: json,
    );
  }

  Map<String, dynamic> toJson() {
    return data ?? {};
  }
}

class TWRNumericValuesResponse {
  final List<NumericPart>? values;

  TWRNumericValuesResponse({this.values});

  factory TWRNumericValuesResponse.fromJson(Map<String, dynamic> json) {
    return TWRNumericValuesResponse(
      values: (json['values'] as List<dynamic>?)
          ?.map((e) => NumericPart.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'values': values?.map((e) => e.toJson()).toList(),
    };
  }
}

class TWRAphabeticValuesResponse {
  final List<AlphabeticPart>? values;

  TWRAphabeticValuesResponse({this.values});

  factory TWRAphabeticValuesResponse.fromJson(Map<String, dynamic> json) {
    return TWRAphabeticValuesResponse(
      values: (json['values'] as List<dynamic>?)
          ?.map((e) => AlphabeticPart.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'values': values?.map((e) => e.toJson()).toList(),
    };
  }
}

// ==================== TRACKING DASHBOARD MODELS ====================

class TrackingDashboardTotals {
  final int onRent;
  final int pastDue;
  final int offRent;

  TrackingDashboardTotals({
    required this.onRent,
    required this.pastDue,
    required this.offRent,
  });

  factory TrackingDashboardTotals.fromJson(Map<String, dynamic> json) {
    int _toInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return TrackingDashboardTotals(
      onRent: _toInt(json['onRent'] ?? json['OnRent']),
      pastDue: _toInt(json['pastDue'] ?? json['PastDue']),
      offRent: _toInt(json['offRent'] ?? json['OffRent']),
    );
  }
}

class TrackingDashboardCompanyStat {
  final String company;
  final int onRent;
  final int pastDue;
  final int offRent;

  TrackingDashboardCompanyStat({
    required this.company,
    required this.onRent,
    required this.pastDue,
    required this.offRent,
  });

  factory TrackingDashboardCompanyStat.fromJson(Map<String, dynamic> json) {
    int _toInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return TrackingDashboardCompanyStat(
      company: (json['company'] ?? json['Company'] ?? '').toString(),
      onRent: _toInt(json['onRent'] ?? json['OnRent']),
      pastDue: _toInt(json['pastDue'] ?? json['PastDue']),
      offRent: _toInt(json['offRent'] ?? json['OffRent']),
    );
  }
}

class TrackingDashboardTypeStat {
  final String type;
  final int onRent;
  final int pastDue;
  final int offRent;

  TrackingDashboardTypeStat({
    required this.type,
    required this.onRent,
    required this.pastDue,
    required this.offRent,
  });

  factory TrackingDashboardTypeStat.fromJson(Map<String, dynamic> json) {
    int _toInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return TrackingDashboardTypeStat(
      type: (json['type'] ?? json['Type'] ?? '').toString(),
      onRent: _toInt(json['onRent'] ?? json['OnRent']),
      pastDue: _toInt(json['pastDue'] ?? json['PastDue']),
      offRent: _toInt(json['offRent'] ?? json['OffRent']),
    );
  }
}

class TrackingDashboardAvgRentalStat {
  final String type;
  final double avgDays;

  TrackingDashboardAvgRentalStat({
    required this.type,
    required this.avgDays,
  });

  factory TrackingDashboardAvgRentalStat.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return TrackingDashboardAvgRentalStat(
      type: (json['type'] ?? json['Type'] ?? '').toString(),
      avgDays: _toDouble(json['avgDays'] ?? json['AvgDays']),
    );
  }
}

class TrackingDashboardStats {
  final TrackingDashboardTotals totals;
  final List<TrackingDashboardCompanyStat> byCompany;
  final List<TrackingDashboardTypeStat> byType;
  final List<TrackingDashboardAvgRentalStat> avgRentalTime;

  TrackingDashboardStats({
    required this.totals,
    required this.byCompany,
    required this.byType,
    required this.avgRentalTime,
  });

  factory TrackingDashboardStats.fromJson(Map<String, dynamic> json) {
    final totalsJson = (json['totals'] ?? json['Totals']) as Map<String, dynamic>? ?? {};
    final byCompanyJson = (json['byCompany'] ?? json['ByCompany']) as List<dynamic>? ?? [];
    final byTypeJson = (json['byType'] ?? json['ByType']) as List<dynamic>? ?? [];
    final avgRentalJson = (json['avgRentalTime'] ?? json['AvgRentalTime']) as List<dynamic>? ?? [];

    return TrackingDashboardStats(
      totals: TrackingDashboardTotals.fromJson(totalsJson),
      byCompany: byCompanyJson
          .map((item) => TrackingDashboardCompanyStat.fromJson(item as Map<String, dynamic>))
          .toList(),
      byType: byTypeJson
          .map((item) => TrackingDashboardTypeStat.fromJson(item as Map<String, dynamic>))
          .toList(),
      avgRentalTime: avgRentalJson
          .map((item) => TrackingDashboardAvgRentalStat.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

// ==================== TRACKING MODELS ====================

class TrackingResponse {
  final int status;
  final List<TrackingDevice> data;
  final int totalCount;
  final int page;
  final int pageSize;

  TrackingResponse({
    required this.status,
    required this.data,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });

  factory TrackingResponse.fromJson(Map<String, dynamic> json) {
    return TrackingResponse(
      status: json['status'] ?? 200,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => TrackingDevice.fromJson(item))
              .toList() ??
          [],
      totalCount: json['totalCount'] ?? 0,
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 15,
    );
  }
}

class TrackingDevice {
  final int id;
  final TrackingSupplier? supplier;
  final TrackingManufacturer? manufacturer;
  final TrackingDeviceModel? deviceModel; // Keep for backward compatibility
  final TrackingDeviceModel? attachedEquipment; // New field from API
  final String? equipmentDescription; // Free text equipment description
  final String? vinSerial;
  final String? licensePlate;
  final String? deviceName;
  final String? photo;
  final String? velavuTagId; // Keep for backward compatibility
  final TrackingTagMaster? tagMaster;
  final TrackingCompany? company;
  final String? owner; // Keep for backward compatibility
  final String? custodian; // New field from API
  final String? deliveryNotes; // New field
  final TrackingCondition? condition;
  final int status;
  final bool hideReturn;
  final bool hideAssign;
  final String? rentalDate;
  final String? returnDate;
  final String? formattedRentalDate;
  final String? formattedReturnDate;
  final String? activeStatus;
  final String? formattedActiveStatus;
  final String? loggedInUserRole;

  /// Check if device is active - handles both string ('Active') and boolean (true/false) from API
  bool get isActive {
    if (activeStatus == null) return false;
    // Handle string 'Active'
    if (activeStatus.toString().toLowerCase() == 'active') return true;
    // Handle boolean true
    if (activeStatus.toString().toLowerCase() == 'true') return true;
    // Handle boolean false
    if (activeStatus.toString().toLowerCase() == 'false') return false;
    // Default: check if it's not 'Inactive' or 'false'
    return activeStatus.toString().toLowerCase() != 'inactive' && 
           activeStatus.toString().toLowerCase() != 'false';
  }

  /// Get display text for activeStatus - handles both string and boolean
  String get activeStatusDisplay {
    if (activeStatus == null) return 'N/A';
    // If formattedActiveStatus is available, use it
    if (formattedActiveStatus != null && formattedActiveStatus!.isNotEmpty) {
      return formattedActiveStatus!;
    }
    // Handle boolean
    if (activeStatus.toString().toLowerCase() == 'true') return 'Active';
    if (activeStatus.toString().toLowerCase() == 'false') return 'Inactive';
    // Handle string
    return activeStatus!;
  }

  TrackingDevice({
    required this.id,
    this.supplier,
    this.manufacturer,
    this.deviceModel,
    this.attachedEquipment,
    this.equipmentDescription,
    this.vinSerial,
    this.licensePlate,
    this.deviceName,
    this.photo,
    this.velavuTagId,
    this.tagMaster,
    this.company,
    this.owner,
    this.custodian,
    this.deliveryNotes,
    this.condition,
    required this.status,
    required this.hideReturn,
    required this.hideAssign,
    this.rentalDate,
    this.returnDate,
    this.formattedRentalDate,
    this.formattedReturnDate,
    this.activeStatus,
    this.formattedActiveStatus,
    this.loggedInUserRole,
  });

  factory TrackingDevice.fromJson(Map<String, dynamic> json) {
    // Handle both deviceModel (old) and attachedEquipment (new) fields
    TrackingDeviceModel? deviceModel;
    if (json['attachedEquipment'] != null) {
      deviceModel = TrackingDeviceModel.fromJson(json['attachedEquipment']);
    } else if (json['deviceModel'] != null) {
      deviceModel = TrackingDeviceModel.fromJson(json['deviceModel']);
    }
    
    return TrackingDevice(
      id: json['id'] ?? 0,
      supplier: json['supplier'] != null
          ? TrackingSupplier.fromJson(json['supplier'])
          : null,
      manufacturer: json['manufacturer'] != null
          ? TrackingManufacturer.fromJson(json['manufacturer'])
          : null,
      deviceModel: deviceModel,
      attachedEquipment: deviceModel, // Same value for both
      equipmentDescription: json['equipmentDescription'] is String ? json['equipmentDescription'] : null,
      vinSerial: json['vinSerial'],
      licensePlate: json['licensePlate'],
      deviceName: json['deviceName'],
      photo: json['photo'],
      velavuTagId: json['velavuTagId'],
      tagMaster: json['tagMaster'] != null
          ? TrackingTagMaster.fromJson(json['tagMaster'])
          : null,
      company: json['company'] != null
          ? TrackingCompany.fromJson(json['company'])
          : null,
      owner: json['owner'] is String ? json['owner'] : null,
      custodian: json['custodian'] is String ? json['custodian'] : null,
      deliveryNotes: json['deliveryNotes'] is String ? json['deliveryNotes'] : null,
      condition: json['condition'] != null
          ? TrackingCondition.fromJson(json['condition'])
          : null,
      status: json['status'] ?? 1,
      hideReturn: json['hideReturn'] ?? false,
      hideAssign: json['hideAssign'] ?? true,
      rentalDate: json['rentalDate'],
      returnDate: json['returnDate'],
      formattedRentalDate: json['formattedRentalDate'],
      formattedReturnDate: json['formattedReturnDate'],
      // Handle both string and boolean activeStatus from API
      // Convert boolean to string representation for consistency
      activeStatus: json['activeStatus'] is bool 
          ? (json['activeStatus'] == true ? 'Active' : 'Inactive')
          : json['activeStatus']?.toString(),
      formattedActiveStatus: json['formattedActiveStatus'],
      loggedInUserRole: json['loggedInUserRole'],
    );
  }
}

// ==================== MAP DEVICE MODEL ====================

class MapDevice {
  final int id;
  final String? vinSerial;
  final String? licensePlate;
  final String? deviceName;
  final String? photo;
  final TrackingTagMaster? tagMaster;
  final String? velavuDeviceName;
  final double? latitude;
  final double? longitude;
  final double? currentSpeed;
  final int? batteryLevel;
  final bool? isGpsEnabled;
  final String? deviceStatus;
  final String? lastLocationUpdate;
  final TrackingSupplier? supplier;
  final TrackingManufacturer? manufacturer;
  final String? equipmentDescription;
  final TrackingCompany? company;
  final String? custodian;
  final String? lastSeen;
  final String? imageUrl;
  final List<String>? imageUrls;
  final String? displayName;
  final bool? hasLocation;
  final String? activeStatus;
  final String? formattedActiveStatus;

  MapDevice({
    required this.id,
    this.vinSerial,
    this.licensePlate,
    this.deviceName,
    this.photo,
    this.tagMaster,
    this.velavuDeviceName,
    this.latitude,
    this.longitude,
    this.currentSpeed,
    this.batteryLevel,
    this.isGpsEnabled,
    this.deviceStatus,
    this.lastLocationUpdate,
    this.supplier,
    this.manufacturer,
    this.equipmentDescription,
    this.company,
    this.custodian,
    this.lastSeen,
    this.imageUrl,
    this.imageUrls,
    this.displayName,
    this.hasLocation,
    this.activeStatus,
    this.formattedActiveStatus,
  });

  factory MapDevice.fromJson(Map<String, dynamic> json) {
    return MapDevice(
      id: json['id'] ?? 0,
      vinSerial: json['vinSerial'],
      licensePlate: json['licensePlate'],
      deviceName: json['deviceName'],
      photo: json['photo'],
      tagMaster: json['tagMaster'] != null
          ? TrackingTagMaster.fromJson(json['tagMaster'])
          : null,
      velavuDeviceName: json['velavuDeviceName'],
      latitude: json['latitude'] != null ? (json['latitude'] is double ? json['latitude'] : (json['latitude'] as num).toDouble()) : null,
      longitude: json['longitude'] != null ? (json['longitude'] is double ? json['longitude'] : (json['longitude'] as num).toDouble()) : null,
      currentSpeed: json['currentSpeed'] != null ? (json['currentSpeed'] is double ? json['currentSpeed'] : (json['currentSpeed'] as num).toDouble()) : null,
      batteryLevel: json['batteryLevel'] is int ? json['batteryLevel'] : (json['batteryLevel'] as num?)?.toInt(),
      isGpsEnabled: json['isGpsEnabled'] is bool ? json['isGpsEnabled'] : null,
      deviceStatus: json['deviceStatus'],
      lastLocationUpdate: json['lastLocationUpdate'],
      supplier: json['supplier'] != null
          ? TrackingSupplier.fromJson(json['supplier'])
          : null,
      manufacturer: json['manufacturer'] != null
          ? TrackingManufacturer.fromJson(json['manufacturer'])
          : null,
      equipmentDescription: json['equipmentDescription'],
      company: json['company'] != null
          ? TrackingCompany.fromJson(json['company'])
          : null,
      custodian: json['custodian'],
      lastSeen: json['lastSeen'],
      imageUrl: json['imageUrl'],
      imageUrls: json['imageUrls'] != null ? List<String>.from(json['imageUrls']) : null,
      displayName: json['displayName'],
      hasLocation: json['hasLocation'] is bool ? json['hasLocation'] : null,
      activeStatus: json['activeStatus']?.toString(),
      formattedActiveStatus: json['formattedActiveStatus'],
    );
  }
}

class TrackingSupplier {
  final String name;
  final String? select2Text;
  final String? errorMessage;
  final bool isValidationEnabled;
  final int id;

  TrackingSupplier({
    required this.name,
    this.select2Text,
    this.errorMessage,
    this.isValidationEnabled = false,
    required this.id,
  });

  factory TrackingSupplier.fromJson(Map<String, dynamic> json) {
    return TrackingSupplier(
      name: json['name'] ?? '',
      select2Text: json['select2Text'],
      errorMessage: json['errorMessage'],
      isValidationEnabled: json['isValidationEnabled'] ?? false,
      id: json['id'] ?? 0,
    );
  }
}

class TrackingManufacturer {
  final String name;
  final String? select2Text;
  final String? errorMessage;
  final bool isValidationEnabled;
  final int id;

  TrackingManufacturer({
    required this.name,
    this.select2Text,
    this.errorMessage,
    this.isValidationEnabled = false,
    required this.id,
  });

  factory TrackingManufacturer.fromJson(Map<String, dynamic> json) {
    return TrackingManufacturer(
      name: json['name'] ?? '',
      select2Text: json['select2Text'],
      errorMessage: json['errorMessage'],
      isValidationEnabled: json['isValidationEnabled'] ?? false,
      id: json['id'] ?? 0,
    );
  }
}

class TrackingDeviceModel {
  final String name;
  final String? systemGeneratedId;
  final String? description;
  final String? select2Text;
  final String? errorMessage;
  final bool isValidationEnabled;
  final int id;

  TrackingDeviceModel({
    required this.name,
    this.systemGeneratedId,
    this.description,
    this.select2Text,
    this.errorMessage,
    this.isValidationEnabled = false,
    required this.id,
  });

  factory TrackingDeviceModel.fromJson(Map<String, dynamic> json) {
    return TrackingDeviceModel(
      name: json['name'] ?? '',
      systemGeneratedId: json['systemGeneratedId'],
      description: json['description'],
      select2Text: json['select2Text'],
      errorMessage: json['errorMessage'],
      isValidationEnabled: json['isValidationEnabled'] ?? false,
      id: json['id'] ?? 0,
    );
  }
}

class TrackingCompany {
  final String companyName;
  final String? select2Text;
  final String? errorMessage;
  final bool isValidationEnabled;
  final int id;

  TrackingCompany({
    required this.companyName,
    this.select2Text,
    this.errorMessage,
    this.isValidationEnabled = false,
    required this.id,
  });

  factory TrackingCompany.fromJson(Map<String, dynamic> json) {
    return TrackingCompany(
      companyName: json['companyName'] ?? '',
      select2Text: json['select2Text'],
      errorMessage: json['errorMessage'],
      isValidationEnabled: json['isValidationEnabled'] ?? false,
      id: json['id'] ?? 0,
    );
  }
}

class TrackingOwner {
  final String contactPersonName;
  final int id;

  TrackingOwner({
    required this.contactPersonName,
    required this.id,
  });

  factory TrackingOwner.fromJson(Map<String, dynamic> json) {
    return TrackingOwner(
      contactPersonName: json['contactPersonName'] ?? '',
      id: json['id'] ?? 0,
    );
  }
}

class TrackingCondition {
  final String name;
  final String? select2Text;
  final String? errorMessage;
  final bool isValidationEnabled;
  final int id;

  TrackingCondition({
    required this.name,
    this.select2Text,
    this.errorMessage,
    this.isValidationEnabled = false,
    required this.id,
  });

  factory TrackingCondition.fromJson(Map<String, dynamic> json) {
    return TrackingCondition(
      name: json['name'] ?? '',
      select2Text: json['select2Text'],
      errorMessage: json['errorMessage'],
      isValidationEnabled: json['isValidationEnabled'] ?? false,
      id: json['id'] ?? 0,
    );
  }
}

class TrackingTagMaster {
  final String? tagId;
  final String? tagType;
  final bool activeStatus;
  final String? select2Text;
  final String? errorMessage;
  final bool isValidationEnabled;
  final int? id;

  TrackingTagMaster({
    this.tagId,
    this.tagType,
    this.activeStatus = false,
    this.select2Text,
    this.errorMessage,
    this.isValidationEnabled = false,
    this.id,
  });

  factory TrackingTagMaster.fromJson(Map<String, dynamic> json) {
    return TrackingTagMaster(
      tagId: json['tagId'],
      tagType: json['tagType'],
      activeStatus: json['activeStatus'] ?? false,
      select2Text: json['select2Text'],
      errorMessage: json['errorMessage'],
      isValidationEnabled: json['isValidationEnabled'] ?? false,
      id: json['id'],
    );
  }
}

// ==================== TRACKING FILTER PARAMS ====================

class TrackingFilterParams {
  final int? supplierId;
  final int? manufacturerId;
  final int? modelId;
  final int? companyId;
  final int? ownerId;
  final int? conditionId;
  final int? status;
  final int? currentPage;
  final int? perPage;
  final String? search;
  final bool? disablePagination;

  TrackingFilterParams({
    this.supplierId,
    this.manufacturerId,
    this.modelId,
    this.companyId,
    this.ownerId,
    this.conditionId,
    this.status,
    this.currentPage,
    this.perPage,
    this.search,
    this.disablePagination,
  });

  Map<String, dynamic> toQueryParams() {
    final Map<String, dynamic> params = {};
    
    if (supplierId != null) params['SupplierId'] = supplierId;
    if (manufacturerId != null) params['ManufacturerId'] = manufacturerId;
    if (modelId != null) params['ModelId'] = modelId;
    if (companyId != null) params['CompanyId'] = companyId;
    if (ownerId != null) params['OwnerId'] = ownerId;
    if (conditionId != null) params['ConditionId'] = conditionId;
    if (status != null) params['Status'] = status;
    if (currentPage != null) params['CurrentPage'] = currentPage;
    if (perPage != null) params['PerPage'] = perPage;
    if (search != null && search!.isNotEmpty) params['Search'] = search;
    if (disablePagination != null) params['DisablePagination'] = disablePagination.toString().toLowerCase();
    
    return params;
  }
}

// ==================== TRACKING HISTORY MODELS ====================

class TrackingHistoryResponse {
  final int status;
  final int trackingId;
  final String deviceName;
  final TrackingDevice? device;
  final List<TrackingHistoryItem> history;

  TrackingHistoryResponse({
    required this.status,
    required this.trackingId,
    required this.deviceName,
    this.device,
    required this.history,
  });

  factory TrackingHistoryResponse.fromJson(Map<String, dynamic> json) {
    return TrackingHistoryResponse(
      status: json['status'] ?? 200,
      trackingId: json['trackingId'] ?? 0,
      deviceName: json['deviceName'] ?? '',
      device: json['device'] != null
          ? TrackingDevice.fromJson(json['device'] as Map<String, dynamic>)
          : null,
      history: (json['history'] as List<dynamic>?)
              ?.map((item) => TrackingHistoryItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class TrackingHistoryItem {
  final int id;
  final String? notes;
  final String type;
  final String? assignDate;
  final String? returnDate;
  final List<String>? photos; // Multiple photos
  final String? createdOn;
  final TrackingCompany? company;
  final String? owner;
  final String? custodian; // New field
  final String? deliveryNotes; // New field
  final TrackingCondition? condition;
  final TrackingDeviceModel? equipment; // New field (attachedEquipment)
  final String? lastUpdatedBy;
  final String? formattedDate;
  final String? formattedType;
  final int activeStatus;
  final String? formattedActiveStatus;
  final String? loggedInUserRole;

  TrackingHistoryItem({
    required this.id,
    this.notes,
    required this.type,
    this.assignDate,
    this.returnDate,
    this.photos,
    this.createdOn,
    this.company,
    this.owner,
    this.custodian,
    this.deliveryNotes,
    this.condition,
    this.equipment,
    this.lastUpdatedBy,
    this.formattedDate,
    this.formattedType,
    required this.activeStatus,
    this.formattedActiveStatus,
    this.loggedInUserRole,
  });

  factory TrackingHistoryItem.fromJson(Map<String, dynamic> json) {
    // Handle photos as array
    List<String>? photos;
    if (json['photos'] != null) {
      if (json['photos'] is List) {
        photos = (json['photos'] as List).map((e) => e.toString()).toList();
      } else if (json['photos'] is String) {
        photos = [json['photos'] as String];
      }
    }
    
    return TrackingHistoryItem(
      id: json['id'] ?? 0,
      notes: json['notes'],
      type: json['type'] ?? '',
      assignDate: json['assignDate'],
      returnDate: json['returnDate'],
      photos: photos,
      createdOn: json['createdOn'],
      company: json['company'] != null
          ? TrackingCompany.fromJson(json['company'] as Map<String, dynamic>)
          : null,
      owner: json['owner'] is String ? json['owner'] : null,
      custodian: json['custodian'] is String ? json['custodian'] : null,
      deliveryNotes: json['deliveryNotes'] is String ? json['deliveryNotes'] : null,
      condition: json['condition'] != null
          ? TrackingCondition.fromJson(json['condition'] as Map<String, dynamic>)
          : null,
      equipment: json['equipment'] != null
          ? TrackingDeviceModel.fromJson(json['equipment'] as Map<String, dynamic>)
          : null,
      lastUpdatedBy: json['lastUpdatedBy'],
      formattedDate: json['formattedDate'],
      formattedType: json['formattedType'],
      activeStatus: json['activeStatus'] ?? 0,
      formattedActiveStatus: json['formattedActiveStatus'],
      loggedInUserRole: json['loggedInUserRole'],
    );
  }
}

// ==================== TRACKING DROPDOWN MODELS ====================

class DropdownItem {
  final int id;
  final String name;

  DropdownItem({
    required this.id,
    required this.name,
  });

  factory DropdownItem.fromJson(Map<String, dynamic> json) {
    return DropdownItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class Select2Item {
  final String id;
  final String text;

  Select2Item({
    required this.id,
    required this.text,
  });

  factory Select2Item.fromJson(Map<String, dynamic> json) {
    return Select2Item(
      id: json['id']?.toString() ?? '',
      text: json['text'] ?? '',
    );
  }
}

class Select2Response {
  final List<Select2Item> results;
  final Map<String, dynamic>? pagination;

  Select2Response({
    required this.results,
    this.pagination,
  });

  factory Select2Response.fromJson(Map<String, dynamic> json) {
    return Select2Response(
      results: (json['results'] as List<dynamic>?)
              ?.map((item) => Select2Item.fromJson(item))
              .toList() ??
          [],
      pagination: json['pagination'] as Map<String, dynamic>?,
    );
  }
}

// ==================== UPDATE STATUS MODELS ====================

class UpdateStatusData {
  final String latestVersion;
  final bool isForcible;

  UpdateStatusData({
    required this.latestVersion,
    required this.isForcible,
  });

  factory UpdateStatusData.fromJson(Map<String, dynamic> json) {
    return UpdateStatusData(
      latestVersion: json['latestVersion'] ?? '',
      isForcible: json['isForcible'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latestVersion': latestVersion,
      'isForcible': isForcible,
    };
  }
}

class UpdateStatusResponse {
  final int status;
  final UpdateStatusData data;

  UpdateStatusResponse({
    required this.status,
    required this.data,
  });

  factory UpdateStatusResponse.fromJson(Map<String, dynamic> json) {
    return UpdateStatusResponse(
      status: json['status'] ?? 200,
      data: UpdateStatusData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}
