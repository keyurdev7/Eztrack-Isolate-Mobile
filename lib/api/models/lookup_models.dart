// ==================== LOOKUP RESPONSE MODELS ====================

class LookupResponse<T> {
  final int? status;
  final LookupData<T>? data;

  LookupResponse({this.status, this.data});

  factory LookupResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return LookupResponse<T>(
      status: json['status'] is int ? json['status'] : int.tryParse(json['status']?.toString() ?? '0'),
      data: json['data'] != null ? LookupData<T>.fromJson(json['data'], fromJsonT) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.toJson(),
    };
  }
}

class LookupData<T> {
  final List<T>? items;
  final List<dynamic>? links;
  final LookupMeta? meta;

  LookupData({this.items, this.links, this.meta});

  factory LookupData.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return LookupData<T>(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      links: json['_links'] as List<dynamic>?,
      meta: json['_meta'] != null ? LookupMeta.fromJson(json['_meta']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items?.map((e) => e.toString()).toList(),
      '_links': links,
      '_meta': meta?.toJson(),
    };
  }
}

class LookupMeta {
  final int? currentPage;
  final int? perPage;
  final int? totalCount;
  final int? pageCount;

  LookupMeta({this.currentPage, this.perPage, this.totalCount, this.pageCount});

  factory LookupMeta.fromJson(Map<String, dynamic> json) {
    return LookupMeta(
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

// ==================== SPECIFIC LOOKUP MODELS ====================

class Department {
  final int? id;
  final String? name;
  final List<int>? unitIds;
  final List<Unit>? units;
  final String? formattedUnits;
  final int? activeStatus;
  final String? formattedStatus;

  Department({
    this.id,
    this.name,
    this.unitIds,
    this.units,
    this.formattedUnits,
    this.activeStatus,
    this.formattedStatus,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name']?.toString(),
      unitIds: (json['unitIds'] as List<dynamic>?)?.map((e) => e as int).toList(),
      units: (json['units'] as List<dynamic>?)
          ?.map((e) => Unit.fromJson(e as Map<String, dynamic>))
          .toList(),
      formattedUnits: json['formattedUnits']?.toString(),
      activeStatus: json['activeStatus'] is int ? json['activeStatus'] : int.tryParse(json['activeStatus']?.toString() ?? '0'),
      formattedStatus: json['formattedStatus']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'unitIds': unitIds,
      'units': units?.map((e) => e.toJson()).toList(),
      'formattedUnits': formattedUnits,
      'activeStatus': activeStatus,
      'formattedStatus': formattedStatus,
    };
  }
}

class Unit {
  final int? id;
  final String? name;
  final String? costTrackerUnit;
  final String? type;
  final int? activeStatus;
  final String? formattedStatus;
  final String? errorMessage;
  final bool? isValidationEnabled;

  Unit({
    this.id,
    this.name,
    this.costTrackerUnit,
    this.type,
    this.activeStatus,
    this.formattedStatus,
    this.errorMessage,
    this.isValidationEnabled,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name']?.toString(),
      costTrackerUnit: json['costTrackerUnit']?.toString(),
      type: json['type']?.toString(),
      activeStatus: json['activeStatus'] is int ? json['activeStatus'] : int.tryParse(json['activeStatus']?.toString() ?? '0'),
      formattedStatus: json['formattedStatus']?.toString(),
      errorMessage: json['errorMessage']?.toString(),
      isValidationEnabled: json['isValidationEnabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'costTrackerUnit': costTrackerUnit,
      'type': type,
      'activeStatus': activeStatus,
      'formattedStatus': formattedStatus,
      'errorMessage': errorMessage,
      'isValidationEnabled': isValidationEnabled,
    };
  }
}

class Approver {
  final int? id;
  final String? name;
  final String? email;
  final String? userName;
  final String? fullName;
  final List<Role>? roles;
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
  final List<dynamic>? associations;

  Approver({
    this.id,
    this.name,
    this.email,
    this.userName,
    this.fullName,
    this.roles,
    this.role,
    this.isApproved,
    this.accessCode,
    this.formattedAccessCode,
    this.contractor,
    this.company,
    this.changePassword,
    this.canAddLogs,
    this.formattedCanAddLogs,
    this.disableNotifications,
    this.formattedDisableNotifications,
    this.activeStatus,
    this.formattedStatus,
    this.associations,
  });

  factory Approver.fromJson(Map<String, dynamic> json) {
    return Approver(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      userName: json['userName']?.toString(),
      fullName: json['fullName']?.toString(),
      roles: (json['roles'] as List<dynamic>?)
          ?.map((e) => Role.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      associations: json['associations'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'userName': userName,
      'fullName': fullName,
      'roles': roles?.map((e) => e.toJson()).toList(),
      'role': role,
      'isApproved': isApproved,
      'accessCode': accessCode,
      'formattedAccessCode': formattedAccessCode,
      'contractor': contractor?.toJson(),
      'company': company?.toJson(),
      'changePassword': changePassword,
      'canAddLogs': canAddLogs,
      'formattedCanAddLogs': formattedCanAddLogs,
      'disableNotifications': disableNotifications,
      'formattedDisableNotifications': formattedDisableNotifications,
      'activeStatus': activeStatus,
      'formattedStatus': formattedStatus,
      'associations': associations,
    };
  }
}

class Role {
  final int? id;
  final String? name;

  Role({this.id, this.name});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Contractor {
  final String? name;
  final String? errorMessage;
  final bool? isValidationEnabled;
  final int? id;

  Contractor({this.name, this.errorMessage, this.isValidationEnabled, this.id});

  factory Contractor.fromJson(Map<String, dynamic> json) {
    return Contractor(
      name: json['name']?.toString(),
      errorMessage: json['errorMessage']?.toString(),
      isValidationEnabled: json['isValidationEnabled'] ?? false,
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'errorMessage': errorMessage,
      'isValidationEnabled': isValidationEnabled,
      'id': id,
    };
  }
}

class Company {
  final String? name;
  final String? errorMessage;
  final bool? isValidationEnabled;
  final int? id;

  Company({this.name, this.errorMessage, this.isValidationEnabled, this.id});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name']?.toString(),
      errorMessage: json['errorMessage']?.toString(),
      isValidationEnabled: json['isValidationEnabled'] ?? false,
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'errorMessage': errorMessage,
      'isValidationEnabled': isValidationEnabled,
      'id': id,
    };
  }
}

class Shift {
  final int? id;
  final String? name;
  final int? activeStatus;
  final String? formattedStatus;

  Shift({this.id, this.name, this.activeStatus, this.formattedStatus});

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name']?.toString(),
      activeStatus: json['activeStatus'] is int ? json['activeStatus'] : int.tryParse(json['activeStatus']?.toString() ?? '0'),
      formattedStatus: json['formattedStatus']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'activeStatus': activeStatus,
      'formattedStatus': formattedStatus,
    };
  }
}

class PermitType {
  final int? id;
  final String? name;
  final int? activeStatus;
  final String? formattedStatus;

  PermitType({this.id, this.name, this.activeStatus, this.formattedStatus});

  factory PermitType.fromJson(Map<String, dynamic> json) {
    return PermitType(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name']?.toString(),
      activeStatus: json['activeStatus'] is int ? json['activeStatus'] : int.tryParse(json['activeStatus']?.toString() ?? '0'),
      formattedStatus: json['formattedStatus']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'activeStatus': activeStatus,
      'formattedStatus': formattedStatus,
    };
  }
}

class DelayType {
  final int? id;
  final String? name;
  final String? identifier;
  final int? order;
  final int? activeStatus;
  final String? formattedStatus;

  DelayType({this.id, this.name, this.identifier, this.order, this.activeStatus, this.formattedStatus});

  factory DelayType.fromJson(Map<String, dynamic> json) {
    return DelayType(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name']?.toString(),
      identifier: json['identifier']?.toString(),
      order: json['order'] is int ? json['order'] : int.tryParse(json['order']?.toString() ?? '0'),
      activeStatus: json['activeStatus'] is int ? json['activeStatus'] : int.tryParse(json['activeStatus']?.toString() ?? '0'),
      formattedStatus: json['formattedStatus']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'identifier': identifier,
      'order': order,
      'activeStatus': activeStatus,
      'formattedStatus': formattedStatus,
    };
  }
}

class TWRNumericValue {
  final String? id;
  final String? text;

  TWRNumericValue({this.id, this.text});

  factory TWRNumericValue.fromJson(Map<String, dynamic> json) {
    return TWRNumericValue(
      id: json['id']?.toString(),
      text: json['text']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }
}

class TWRAlphabeticValue {
  final String? id;
  final String? text;

  TWRAlphabeticValue({this.id, this.text});

  factory TWRAlphabeticValue.fromJson(Map<String, dynamic> json) {
    return TWRAlphabeticValue(
      id: json['id']?.toString(),
      text: json['text']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }

  @override
  String toString() => 'TWRAlphabeticValue(id: $id, text: $text)';
}

// ==================== OVERRIDE CATEGORY MODEL ====================

class OverrideCategory {
  final String id;
  final String text;

  OverrideCategory({
    required this.id,
    required this.text,
  });

  factory OverrideCategory.fromJson(Map<String, dynamic> json) {
    return OverrideCategory(
      id: json['id']?.toString() ?? '',
      text: json['text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }

  @override
  String toString() => 'OverrideCategory(id: $id, text: $text)';
}

// ==================== CRAFT SKILL MODEL ====================

class CraftSkill {
  final int id;
  final String name;
  final double stRate;
  final double otRate;
  final double dtRate;
  final int activeStatus;
  final String formattedStatus;

  CraftSkill({
    required this.id,
    required this.name,
    required this.stRate,
    required this.otRate,
    required this.dtRate,
    required this.activeStatus,
    required this.formattedStatus,
  });

  factory CraftSkill.fromJson(Map<String, dynamic> json) {
    return CraftSkill(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      stRate: (json['stRate'] ?? 0.0).toDouble(),
      otRate: (json['otRate'] ?? 0.0).toDouble(),
      dtRate: (json['dtRate'] ?? 0.0).toDouble(),
      activeStatus: json['activeStatus'] ?? 0,
      formattedStatus: json['formattedStatus'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'stRate': stRate,
      'otRate': otRate,
      'dtRate': dtRate,
      'activeStatus': activeStatus,
      'formattedStatus': formattedStatus,
    };
  }

  @override
  String toString() => 'CraftSkill(id: $id, name: $name, stRate: $stRate, otRate: $otRate, dtRate: $dtRate)';
}

// ==================== ROD TYPE MODEL ====================

class RodType {
  final int id;
  final String name;
  final int activeStatus;
  final String formattedStatus;

  RodType({
    required this.id,
    required this.name,
    required this.activeStatus,
    required this.formattedStatus,
  });

  factory RodType.fromJson(Map<String, dynamic> json) {
    return RodType(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      activeStatus: json['activeStatus'] ?? 0,
      formattedStatus: json['formattedStatus'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'activeStatus': activeStatus,
      'formattedStatus': formattedStatus,
    };
  }

  @override
  String toString() => 'RodType(id: $id, name: $name)';
}

// ==================== WELD METHOD MODEL ====================

class WeldMethod {
  final int id;
  final String name;
  final int activeStatus;
  final String formattedStatus;

  WeldMethod({
    required this.id,
    required this.name,
    required this.activeStatus,
    required this.formattedStatus,
  });

  factory WeldMethod.fromJson(Map<String, dynamic> json) {
    return WeldMethod(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      activeStatus: json['activeStatus'] ?? 0,
      formattedStatus: json['formattedStatus'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'activeStatus': activeStatus,
      'formattedStatus': formattedStatus,
    };
  }

  @override
  String toString() => 'WeldMethod(id: $id, name: $name)';
}

// ==================== LOCATION MODEL ====================

class Location {
  final int id;
  final String name;
  final int activeStatus;
  final String formattedStatus;

  Location({
    required this.id,
    required this.name,
    required this.activeStatus,
    required this.formattedStatus,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      activeStatus: json['activeStatus'] ?? 0,
      formattedStatus: json['formattedStatus'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'activeStatus': activeStatus,
      'formattedStatus': formattedStatus,
    };
  }

  @override
  String toString() => 'Location(id: $id, name: $name)';
}
