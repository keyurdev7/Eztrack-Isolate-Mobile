// ==================== APPROVAL RESPONSE MODELS ====================

class ApprovalResponse {
  final int? status;
  final ApprovalData? data;

  ApprovalResponse({this.status, this.data});

  factory ApprovalResponse.fromJson(Map<String, dynamic> json) {
    return ApprovalResponse(
      status: json['status'] is int ? json['status'] : int.tryParse(json['status']?.toString() ?? '0'),
      data: json['data'] != null ? ApprovalData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.toJson(),
    };
  }
}

class ApprovalData {
  final List<ApprovalItem>? items;
  final List<dynamic>? links;
  final ApprovalMeta? meta;

  ApprovalData({this.items, this.links, this.meta});

  factory ApprovalData.fromJson(Map<String, dynamic> json) {
    return ApprovalData(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => ApprovalItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      links: json['_links'] as List<dynamic>?,
      meta: json['_meta'] != null ? ApprovalMeta.fromJson(json['_meta']) : null,
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

class ApprovalItem {
  final int? id;
  final String? status;
  final String? formattedStatus;
  final String? formattedStatusForView;
  final String? date;
  final String? formattedDate;
  final String? type;
  final String? formattedLogType;
  final ApprovalEmployee? employee;
  final String? requester;
  final String? department;
  final String? contractor;
  final String? delayType;
  final String? resonForDelay;
  final String? reason;
  final double? totalCost;
  final String? approver;
  final String? unit;
  final String? twr;
  final double? totalHours;
  final double? totalHeadCount;
  final int? activeStatus;

  ApprovalItem({
    this.id,
    this.status,
    this.formattedStatus,
    this.formattedStatusForView,
    this.date,
    this.formattedDate,
    this.type,
    this.formattedLogType,
    this.employee,
    this.requester,
    this.department,
    this.contractor,
    this.delayType,
    this.resonForDelay,
    this.reason,
    this.totalCost,
    this.approver,
    this.unit,
    this.twr,
    this.totalHours,
    this.totalHeadCount,
    this.activeStatus,
  });

  factory ApprovalItem.fromJson(Map<String, dynamic> json) {
    return ApprovalItem(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      status: json['status']?.toString(),
      formattedStatus: json['formattedStatus']?.toString(),
      formattedStatusForView: json['formattedStatusForView']?.toString(),
      date: json['date']?.toString(),
      formattedDate: json['formattedDate']?.toString(),
      type: json['type']?.toString(),
      formattedLogType: json['formattedLogType']?.toString(),
      employee: json['employee'] != null ? ApprovalEmployee.fromJson(json['employee']) : null,
      requester: json['requester']?.toString(),
      department: json['department']?.toString(),
      contractor: json['contractor']?.toString(),
      delayType: json['delayType']?.toString(),
      resonForDelay: json['resonForDelay']?.toString(),
      reason: json['reason']?.toString(),
      totalCost: json['totalCost'] is double ? json['totalCost'] : double.tryParse(json['totalCost']?.toString() ?? '0.0'),
      approver: json['approver']?.toString(),
      unit: json['unit']?.toString(),
      twr: json['twr']?.toString(),
      totalHours: json['totalHours'] is double ? json['totalHours'] : double.tryParse(json['totalHours']?.toString() ?? '0.0'),
      totalHeadCount: json['totalHeadCount'] is double ? json['totalHeadCount'] : double.tryParse(json['totalHeadCount']?.toString() ?? '0.0'),
      activeStatus: json['activeStatus'] is int ? json['activeStatus'] : int.tryParse(json['activeStatus']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'formattedStatus': formattedStatus,
      'formattedStatusForView': formattedStatusForView,
      'date': date,
      'formattedDate': formattedDate,
      'type': type,
      'formattedLogType': formattedLogType,
      'employee': employee?.toJson(),
      'requester': requester,
      'department': department,
      'contractor': contractor,
      'delayType': delayType,
      'resonForDelay': resonForDelay,
      'reason': reason,
      'totalCost': totalCost,
      'approver': approver,
      'unit': unit,
      'twr': twr,
      'totalHours': totalHours,
      'totalHeadCount': totalHeadCount,
      'activeStatus': activeStatus,
    };
  }
}

class ApprovalEmployee {
  final bool? isDeleted;
  final String? activeStatus;
  final String? createdOn;
  final int? createdBy;
  final String? updatedOn;
  final int? updatedBy;
  final String? deviceId;
  final String? accessCode;
  final String? fullName;
  final int? companyId;
  final String? company;
  final bool? changePassword;
  final bool? canAddLogs;
  final bool? disableNotifications;
  final int? id;
  final String? userName;
  final String? normalizedUserName;
  final String? email;
  final String? normalizedEmail;
  final bool? emailConfirmed;
  final String? passwordHash;
  final String? securityStamp;
  final String? concurrencyStamp;
  final String? phoneNumber;
  final bool? phoneNumberConfirmed;
  final bool? twoFactorEnabled;
  final String? lockoutEnd;
  final bool? lockoutEnabled;
  final int? accessFailedCount;

  ApprovalEmployee({
    this.isDeleted,
    this.activeStatus,
    this.createdOn,
    this.createdBy,
    this.updatedOn,
    this.updatedBy,
    this.deviceId,
    this.accessCode,
    this.fullName,
    this.companyId,
    this.company,
    this.changePassword,
    this.canAddLogs,
    this.disableNotifications,
    this.id,
    this.userName,
    this.normalizedUserName,
    this.email,
    this.normalizedEmail,
    this.emailConfirmed,
    this.passwordHash,
    this.securityStamp,
    this.concurrencyStamp,
    this.phoneNumber,
    this.phoneNumberConfirmed,
    this.twoFactorEnabled,
    this.lockoutEnd,
    this.lockoutEnabled,
    this.accessFailedCount,
  });

  factory ApprovalEmployee.fromJson(Map<String, dynamic> json) {
    return ApprovalEmployee(
      isDeleted: json['isDeleted'] ?? false,
      activeStatus: json['activeStatus']?.toString(),
      createdOn: json['createdOn']?.toString(),
      createdBy: json['createdBy'] is int ? json['createdBy'] : int.tryParse(json['createdBy']?.toString() ?? '0'),
      updatedOn: json['updatedOn']?.toString(),
      updatedBy: json['updatedBy'] is int ? json['updatedBy'] : int.tryParse(json['updatedBy']?.toString() ?? '0'),
      deviceId: json['deviceId']?.toString(),
      accessCode: json['accessCode']?.toString(),
      fullName: json['fullName']?.toString(),
      companyId: json['companyId'] is int ? json['companyId'] : int.tryParse(json['companyId']?.toString() ?? '0'),
      company: json['company']?.toString(),
      changePassword: json['changePassword'] ?? false,
      canAddLogs: json['canAddLogs'] ?? false,
      disableNotifications: json['disableNotifications'] ?? false,
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      userName: json['userName']?.toString(),
      normalizedUserName: json['normalizedUserName']?.toString(),
      email: json['email']?.toString(),
      normalizedEmail: json['normalizedEmail']?.toString(),
      emailConfirmed: json['emailConfirmed'] ?? false,
      passwordHash: json['passwordHash']?.toString(),
      securityStamp: json['securityStamp']?.toString(),
      concurrencyStamp: json['concurrencyStamp']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      phoneNumberConfirmed: json['phoneNumberConfirmed'] ?? false,
      twoFactorEnabled: json['twoFactorEnabled'] ?? false,
      lockoutEnd: json['lockoutEnd']?.toString(),
      lockoutEnabled: json['lockoutEnabled'] ?? false,
      accessFailedCount: json['accessFailedCount'] is int ? json['accessFailedCount'] : int.tryParse(json['accessFailedCount']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDeleted': isDeleted,
      'activeStatus': activeStatus,
      'createdOn': createdOn,
      'createdBy': createdBy,
      'updatedOn': updatedOn,
      'updatedBy': updatedBy,
      'deviceId': deviceId,
      'accessCode': accessCode,
      'fullName': fullName,
      'companyId': companyId,
      'company': company,
      'changePassword': changePassword,
      'canAddLogs': canAddLogs,
      'disableNotifications': disableNotifications,
      'id': id,
      'userName': userName,
      'normalizedUserName': normalizedUserName,
      'email': email,
      'normalizedEmail': normalizedEmail,
      'emailConfirmed': emailConfirmed,
      'passwordHash': passwordHash,
      'securityStamp': securityStamp,
      'concurrencyStamp': concurrencyStamp,
      'phoneNumber': phoneNumber,
      'phoneNumberConfirmed': phoneNumberConfirmed,
      'twoFactorEnabled': twoFactorEnabled,
      'lockoutEnd': lockoutEnd,
      'lockoutEnabled': lockoutEnabled,
      'accessFailedCount': accessFailedCount,
    };
  }
}

class ApprovalMeta {
  final int? currentPage;
  final int? perPage;
  final int? totalCount;
  final int? pageCount;

  ApprovalMeta({this.currentPage, this.perPage, this.totalCount, this.pageCount});

  factory ApprovalMeta.fromJson(Map<String, dynamic> json) {
    return ApprovalMeta(
      currentPage: json['currentPage'] is int ? json['currentPage'] : int.tryParse(json['currentPage']?.toString() ?? '0'),
      perPage: json['perPage'] is int ? json['perPage'] : int.tryParse(json['perPage']?.toString() ?? '0'),
      totalCount: json['totalCount'] is int ? json['totalCount'] : int.tryParse(json['totalCount']?.toString() ?? '0'),
      pageCount: json['pageCount'] is int ? json['pageCount'] : int.tryParse(json['pageCount']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'perPage': perPage,
      'totalCount': totalCount,
      'pageCount': pageCount,
    };
  }
}
