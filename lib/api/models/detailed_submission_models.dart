// Detailed submission models for ID-based navigation
import 'lookup_models.dart' as lookup;
import 'response_models.dart' as response;

// Detailed TOT Log Model (single item response)
class TOTLogDetailResponse {
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
  final TWRModelDetail? twrModel;
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
  final DepartmentDetail? department;
  final UnitDetail? unit;
  final ContractorDetail? contractor;
  final DelayTypeDetail? startOfWorkDelay;
  final DelayTypeDetail? ongoingWorkDelay;
  final DelayTypeDetail? shiftDelay;
  final DelayTypeDetail? reworkDelay;
  final PermitTypeDetail? permitType;
  final ShiftDetail? shift;
  final DelayTypeDetail? delayType;
  final String? delayReason;
  final CompanyDetail? company;
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
  final ApproverDetail? approver;
  final EmployeeDetail? employee;
  final int? activeStatus;

  TOTLogDetailResponse({
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

  factory TOTLogDetailResponse.fromJson(Map<String, dynamic> json) {
    return TOTLogDetailResponse(
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
      twrModel: json['twrModel'] != null ? TWRModelDetail.fromJson(json['twrModel']) : null,
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
      department: json['department'] != null ? DepartmentDetail.fromJson(json['department']) : null,
      unit: json['unit'] != null ? UnitDetail.fromJson(json['unit']) : null,
      contractor: json['contractor'] != null ? ContractorDetail.fromJson(json['contractor']) : null,
      startOfWorkDelay: json['startOfWorkDelay'] != null ? DelayTypeDetail.fromJson(json['startOfWorkDelay']) : null,
      ongoingWorkDelay: json['ongoingWorkDelay'] != null ? DelayTypeDetail.fromJson(json['ongoingWorkDelay']) : null,
      shiftDelay: json['shiftDelay'] != null ? DelayTypeDetail.fromJson(json['shiftDelay']) : null,
      reworkDelay: json['reworkDelay'] != null ? DelayTypeDetail.fromJson(json['reworkDelay']) : null,
      permitType: json['permitType'] != null ? PermitTypeDetail.fromJson(json['permitType']) : null,
      shift: json['shift'] != null ? ShiftDetail.fromJson(json['shift']) : null,
      delayType: json['delayType'] != null ? DelayTypeDetail.fromJson(json['delayType']) : null,
      delayReason: json['delayReason']?.toString(),
      company: json['company'] != null ? CompanyDetail.fromJson(json['company']) : null,
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
      approver: json['approver'] != null ? ApproverDetail.fromJson(json['approver']) : null,
      employee: json['employee'] != null ? EmployeeDetail.fromJson(json['employee']) : null,
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

// Detailed Override Log Model (single item response)
class OverrideLogDetailResponse {
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
  final UnitDetail? unit;
  final ShiftDetail? shift;
  final String? reasonForRequest;
  final CraftRateDetail? craftRate;
  final String? delayReason;
  final DelayTypeDetail? startOfWorkDelay;
  final DelayTypeDetail? shiftDelay;
  final DelayTypeDetail? reworkDelay;
  final DelayTypeDetail? delayType;
  final CompanyDetail? company;
  final List<OverrideCostDetail>? costs;
  final double? totalSTHours;
  final double? totalOTHours;
  final double? totalDTHours;
  final DepartmentDetail? department;
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
  final ApproverDetail? approver;
  final EmployeeDetail? employee;
  final int? activeStatus;

  OverrideLogDetailResponse({
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

  factory OverrideLogDetailResponse.fromJson(Map<String, dynamic> json) {
    return OverrideLogDetailResponse(
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
      unit: json['unit'] != null ? UnitDetail.fromJson(json['unit']) : null,
      shift: json['shift'] != null ? ShiftDetail.fromJson(json['shift']) : null,
      reasonForRequest: json['reasonForRequest']?.toString(),
      craftRate: json['craftRate'] != null ? CraftRateDetail.fromJson(json['craftRate']) : null,
      delayReason: json['delayReason']?.toString(),
      startOfWorkDelay: json['startOfWorkDelay'] != null ? DelayTypeDetail.fromJson(json['startOfWorkDelay']) : null,
      shiftDelay: json['shiftDelay'] != null ? DelayTypeDetail.fromJson(json['shiftDelay']) : null,
      reworkDelay: json['reworkDelay'] != null ? DelayTypeDetail.fromJson(json['reworkDelay']) : null,
      delayType: json['delayType'] != null ? DelayTypeDetail.fromJson(json['delayType']) : null,
      company: json['company'] != null ? CompanyDetail.fromJson(json['company']) : null,
      costs: (json['costs'] as List<dynamic>?)
          ?.map((e) => OverrideCostDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalSTHours: json['totalSTHours'] is double ? json['totalSTHours'] : double.tryParse(json['totalSTHours']?.toString() ?? '0.0'),
      totalOTHours: json['totalOTHours'] is double ? json['totalOTHours'] : double.tryParse(json['totalOTHours']?.toString() ?? '0.0'),
      totalDTHours: json['totalDTHours'] is double ? json['totalDTHours'] : double.tryParse(json['totalDTHours']?.toString() ?? '0.0'),
      department: json['department'] != null ? DepartmentDetail.fromJson(json['department']) : null,
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
      approver: json['approver'] != null ? ApproverDetail.fromJson(json['approver']) : null,
      employee: json['employee'] != null ? EmployeeDetail.fromJson(json['employee']) : null,
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

// Detailed WRR Log Model (single item response)
class WRRLogDetailResponse {
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
  final lookup.Department? department;
  final lookup.Unit? unit;
  final lookup.Company? company;
  final lookup.Approver? approver;
  final response.Employee? employee;
  final lookup.RodType? rodType;
  final lookup.WeldMethod? weldMethod;
  final lookup.Location? location;
  final response.TWRModel? twrModel;
  final lookup.Shift? shift;

  WRRLogDetailResponse({
    this.id, this.createdOn, this.formattedCreatedOn, this.status, this.formattedStatus,
    this.dateRodReturned, this.calibrationDate, this.fumeControlUsed, this.workScope,
    this.email, this.rodCheckedOut, this.rodCheckedOutLbs, this.rodReturnedWasteLbs,
    this.comment, this.activeStatus, this.workCompletedDate, this.formattedDateOfWorkCompleted,
    this.department, this.unit, this.company, this.approver, this.employee,
    this.rodType, this.weldMethod, this.location, this.twrModel, this.shift,
  });

  factory WRRLogDetailResponse.fromJson(Map<String, dynamic> json) {
    return WRRLogDetailResponse(
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
      department: json['department'] != null ? lookup.Department.fromJson(json['department']) : null,
      unit: json['unit'] != null ? lookup.Unit.fromJson(json['unit']) : null,
      company: json['company'] != null ? lookup.Company.fromJson(json['company']) : null,
      approver: json['approver'] != null ? lookup.Approver.fromJson(json['approver']) : null,
      employee: json['employee'] != null ? response.Employee.fromJson(json['employee']) : null,
      rodType: json['rodType'] != null ? lookup.RodType.fromJson(json['rodType']) : null,
      weldMethod: json['weldMethod'] != null ? lookup.WeldMethod.fromJson(json['weldMethod']) : null,
      location: json['location'] != null ? lookup.Location.fromJson(json['location']) : null,
      twrModel: json['twrModel'] != null ? response.TWRModel.fromJson(json['twrModel']) : null,
      shift: json['shift'] != null ? lookup.Shift.fromJson(json['shift']) : null,
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

// ==================== DETAILED SUPPORTING MODELS ====================

class TWRModelDetail {
  final String? name;
  final NumericPartDetail? numericPart;
  final AlphabeticPartDetail? alphabeticPart;
  final String? text;

  TWRModelDetail({this.name, this.numericPart, this.alphabeticPart, this.text});

  factory TWRModelDetail.fromJson(Map<String, dynamic> json) {
    return TWRModelDetail(
      name: json['name']?.toString(),
      numericPart: json['numericPart'] != null ? NumericPartDetail.fromJson(json['numericPart']) : null,
      alphabeticPart: json['alphabeticPart'] != null ? AlphabeticPartDetail.fromJson(json['alphabeticPart']) : null,
      text: json['text']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name, 'numericPart': numericPart?.toJson(), 'alphabeticPart': alphabeticPart?.toJson(), 'text': text,
    };
  }
}

class NumericPartDetail {
  final int? id;
  final String? text;

  NumericPartDetail({this.id, this.text});

  factory NumericPartDetail.fromJson(Map<String, dynamic> json) {
    return NumericPartDetail(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      text: json['text']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text};
  }
}

class AlphabeticPartDetail {
  final int? id;
  final String? text;

  AlphabeticPartDetail({this.id, this.text});

  factory AlphabeticPartDetail.fromJson(Map<String, dynamic> json) {
    return AlphabeticPartDetail(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      text: json['text']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text};
  }
}

class DepartmentDetail {
  final int? id;
  final String? name;
  final String? errorMessage;
  final bool? isValidationEnabled;

  DepartmentDetail({this.id, this.name, this.errorMessage, this.isValidationEnabled});

  factory DepartmentDetail.fromJson(Map<String, dynamic> json) {
    return DepartmentDetail(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name']?.toString(),
      errorMessage: json['errorMessage']?.toString(),
      isValidationEnabled: json['isValidationEnabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'errorMessage': errorMessage, 'isValidationEnabled': isValidationEnabled};
  }
}

class UnitDetail {
  final int? id;
  final String? name;
  final String? errorMessage;
  final bool? isValidationEnabled;

  UnitDetail({this.id, this.name, this.errorMessage, this.isValidationEnabled});

  factory UnitDetail.fromJson(Map<String, dynamic> json) {
    return UnitDetail(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name']?.toString(),
      errorMessage: json['errorMessage']?.toString(),
      isValidationEnabled: json['isValidationEnabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'errorMessage': errorMessage, 'isValidationEnabled': isValidationEnabled};
  }
}

class ContractorDetail {
  final int? id;
  final String? name;

  ContractorDetail({this.id, this.name});

  factory ContractorDetail.fromJson(Map<String, dynamic> json) {
    return ContractorDetail(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class DelayTypeDetail {
  final int? id;
  final String? name;
  final String? identifier;
  final String? errorMessage;
  final bool? isValidationEnabled;

  DelayTypeDetail({this.id, this.name, this.identifier, this.errorMessage, this.isValidationEnabled});

  factory DelayTypeDetail.fromJson(Map<String, dynamic> json) {
    return DelayTypeDetail(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name']?.toString(),
      identifier: json['identifier']?.toString(),
      errorMessage: json['errorMessage']?.toString(),
      isValidationEnabled: json['isValidationEnabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, 'name': name, 'identifier': identifier, 'errorMessage': errorMessage,
      'isValidationEnabled': isValidationEnabled,
    };
  }
}

class PermitTypeDetail {
  final int? id;
  final String? name;
  final String? errorMessage;
  final bool? isValidationEnabled;

  PermitTypeDetail({this.id, this.name, this.errorMessage, this.isValidationEnabled});

  factory PermitTypeDetail.fromJson(Map<String, dynamic> json) {
    return PermitTypeDetail(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name']?.toString(),
      errorMessage: json['errorMessage']?.toString(),
      isValidationEnabled: json['isValidationEnabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'errorMessage': errorMessage, 'isValidationEnabled': isValidationEnabled};
  }
}

class ShiftDetail {
  final int? id;
  final String? name;
  final String? errorMessage;
  final bool? isValidationEnabled;

  ShiftDetail({this.id, this.name, this.errorMessage, this.isValidationEnabled});

  factory ShiftDetail.fromJson(Map<String, dynamic> json) {
    return ShiftDetail(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name']?.toString(),
      errorMessage: json['errorMessage']?.toString(),
      isValidationEnabled: json['isValidationEnabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'errorMessage': errorMessage, 'isValidationEnabled': isValidationEnabled};
  }
}

class CompanyDetail {
  final int? id;
  final String? name;
  final String? errorMessage;
  final bool? isValidationEnabled;

  CompanyDetail({this.id, this.name, this.errorMessage, this.isValidationEnabled});

  factory CompanyDetail.fromJson(Map<String, dynamic> json) {
    return CompanyDetail(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name']?.toString(),
      errorMessage: json['errorMessage']?.toString(),
      isValidationEnabled: json['isValidationEnabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'errorMessage': errorMessage, 'isValidationEnabled': isValidationEnabled};
  }
}

class ApproverDetail {
  final int? id;
  final String? name;
  final String? email;
  final String? errorMessage;
  final bool? isValidationEnabled;

  ApproverDetail({this.id, this.name, this.email, this.errorMessage, this.isValidationEnabled});

  factory ApproverDetail.fromJson(Map<String, dynamic> json) {
    return ApproverDetail(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      errorMessage: json['errorMessage']?.toString(),
      isValidationEnabled: json['isValidationEnabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'errorMessage': errorMessage, 'isValidationEnabled': isValidationEnabled};
  }
}

class EmployeeDetail {
  final int? id;
  final String? name;
  final String? email;
  final String? errorMessage;
  final bool? isValidationEnabled;

  EmployeeDetail({this.id, this.name, this.email, this.errorMessage, this.isValidationEnabled});

  factory EmployeeDetail.fromJson(Map<String, dynamic> json) {
    return EmployeeDetail(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      errorMessage: json['errorMessage']?.toString(),
      isValidationEnabled: json['isValidationEnabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'errorMessage': errorMessage, 'isValidationEnabled': isValidationEnabled};
  }
}

class CraftRateDetail {
  final int? id;
  final double? rate;
  final String? name;
  final String? errorMessage;
  final bool? isValidationEnabled;

  CraftRateDetail({this.id, this.rate, this.name, this.errorMessage, this.isValidationEnabled});

  factory CraftRateDetail.fromJson(Map<String, dynamic> json) {
    return CraftRateDetail(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      rate: json['rate'] is double ? json['rate'] : double.tryParse(json['rate']?.toString() ?? '0.0'),
      name: json['name']?.toString(),
      errorMessage: json['errorMessage']?.toString(),
      isValidationEnabled: json['isValidationEnabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'rate': rate, 'name': name, 'errorMessage': errorMessage, 'isValidationEnabled': isValidationEnabled};
  }
}

class OverrideCostDetail {
  final int? id;
  final double? overrideHours;
  final String? overrideType;
  final int? headCount;
  final CraftSkillDetail? craftSkill;
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

  OverrideCostDetail({
    this.id, this.overrideHours, this.overrideType, this.headCount, this.craftSkill,
    this.employeeName, this.poNumber, this.poNumberValue, this.stHours, this.otHours,
    this.dtHours, this.overrideLogId, this.cost, this.craftRate, this.formattedCraftRate, this.formattedCost,
  });

  factory OverrideCostDetail.fromJson(Map<String, dynamic> json) {
    return OverrideCostDetail(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      overrideHours: json['overrideHours'] is double ? json['overrideHours'] : double.tryParse(json['overrideHours']?.toString() ?? '0.0'),
      overrideType: json['overrideType']?.toString(),
      headCount: json['headCount'] is int ? json['headCount'] : int.tryParse(json['headCount']?.toString() ?? '0'),
      craftSkill: json['craftSkill'] != null ? CraftSkillDetail.fromJson(json['craftSkill']) : null,
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

class CraftSkillDetail {
  final int? id;
  final String? name;
  final double? stRate;
  final double? otRate;
  final double? dtRate;
  final String? errorMessage;
  final bool? isValidationEnabled;

  CraftSkillDetail({
    this.id, this.name, this.stRate, this.otRate, this.dtRate, this.errorMessage, this.isValidationEnabled,
  });

  factory CraftSkillDetail.fromJson(Map<String, dynamic> json) {
    return CraftSkillDetail(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name']?.toString(),
      stRate: json['stRate'] is double ? json['stRate'] : double.tryParse(json['stRate']?.toString() ?? '0.0'),
      otRate: json['otRate'] is double ? json['otRate'] : double.tryParse(json['otRate']?.toString() ?? '0.0'),
      dtRate: json['dtRate'] is double ? json['dtRate'] : double.tryParse(json['dtRate']?.toString() ?? '0.0'),
      errorMessage: json['errorMessage']?.toString(),
      isValidationEnabled: json['isValidationEnabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, 'name': name, 'stRate': stRate, 'otRate': otRate, 'dtRate': dtRate,
      'errorMessage': errorMessage, 'isValidationEnabled': isValidationEnabled,
    };
  }
}
