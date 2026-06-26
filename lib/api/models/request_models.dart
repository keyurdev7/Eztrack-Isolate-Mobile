import 'dart:io';
import 'package:dio/dio.dart';
import 'lookup_models.dart' as lookup;

// Login Request Models
class LoginRequest {
  final String email;
  final String password;
  final String? deviceId;

  LoginRequest({
    required this.email,
    required this.password,
    this.deviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'deviceId': deviceId,
    };
  }
}

class LoginUsingPincodeRequest {
  final String pincode;
  // final String deviceId;

  LoginUsingPincodeRequest({
    required this.pincode,
    // required this.deviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'pincode': pincode,
      // 'deviceId': deviceId,
    };
  }
}

class ResetPasswordRequest {
  final String password;
  final String confirmPassword;
  final String email;

  ResetPasswordRequest({
    required this.password,
    required this.confirmPassword,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'confirmPassword': confirmPassword,
      'email': email,
    };
  }
}

class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

// Employee Signup Request Model
class EmployeeSignupRequest {
  final String? fullName;
  final String? email;
  final String? telephone;
  final lookup.Company? company;
  final String? accessCode;

  EmployeeSignupRequest({
    this.fullName,
    this.email,
    this.telephone,
    this.company,
    this.accessCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'telephone': telephone,
      'company': company != null
          ? {
              'name': company!.name,
              'id': company!.id,
            }
          : null,
      'accessCode': accessCode,
    };
  }
}

// TOTLog Request Models - Updated to match API specification
class TOTLogRequestPost {
  final String? date;
  final TWRModelDetailed? twrModel;
  final String? permitNo;
  final String? delayDescription;
  final String? workScope;
  final int? manHours;
  final String? startOfWork;
  final String? timeRequested;
  final String? timeSigned;
  final String? comment;
  final LookupItemDetailed? reasonForRequest;
  final String? jobDescription;
  final int? manPowerAffected;
  final String? equipmentNo;
  final int? hoursDelayed;
  final String? status;
  final LookupItemDetailed? department;
  final LookupItemDetailed? unit;

  final LookupItemDetailed? permitType;
  final LookupItemDetailed? shift;
  final LookupItemDetailed? permittingIssue;
  final ApproverDetailed? approver;
  final String? foreman;
  final EmployeeDetailed? employee;
  final LookupItemDetailed? company;
  final LookupItemDetailed? shiftDelay;
  final DelayTypeDetailed? delayType;





  TOTLogRequestPost({
    this.date,
    this.twrModel,
    this.permitNo,
    this.delayDescription,
    this.workScope,
    this.manHours,
    this.startOfWork,
    this.timeRequested,
    this.timeSigned,
    this.comment,
    this.reasonForRequest,
    this.jobDescription,
    this.manPowerAffected,
    this.equipmentNo,
    this.hoursDelayed,
    this.status,
    this.department,
    this.unit,

    this.permitType,
    this.shift,
    this.permittingIssue,
    this.approver,
    this.foreman,
    this.employee,
    this.company,
    this.shiftDelay,
    this.delayType,

  });

  Map<String, dynamic> toJson() {
    return {
      'date': date?.toString(),
      'twrModel': twrModel?.toJson(),
      'permitNo': permitNo,
      'delayDescription': delayDescription,
      'workScope': workScope,
      'manHours': manHours,
      'startOfWork': startOfWork?.toString(),
      'timeRequested': timeRequested,
      'timeSigned': timeSigned,
      'comment': comment,
      'reasonForRequest': reasonForRequest?.toJson(),
      'jobDescription': jobDescription,
      'manPowerAffected': manPowerAffected,
      'equipmentNo': equipmentNo,
      'hoursDelayed': hoursDelayed,
      'status': status,
      'department': department?.toJson(),
      'unit': unit?.toJson(),

      'permitType': permitType?.toJson(),
      'shift': shift?.toJson(),
      'permittingIssue': permittingIssue?.toJson(),
      'approver': approver?.toJson(),
      'foreman': foreman,
      'employee': employee?.toJson(),
      'company': company?.toJson(),
      'shiftDelay': shiftDelay?.toJson(),
      'delayType': delayType?.toJson(),

    };
  }
}


// class TOTLogRequestPut {
//   final String? date;
//   final TWRModelDetailed? twrModel;
//   final String? permitNo;
//   final String? delayDescription;
//   final String? workScope;
//   final int? manHours;
//   final String? startOfWork;
//   final String? timeRequested;
//   final String? timeSigned;
//   final String? comment;
//   final LookupItemDetailed? reasonForRequest;
//   final String? jobDescription;
//   final int? manPowerAffected;
//   final String? equipmentNo;
//   final int? hoursDelayed;
//   final String? status;
//   final LookupItemDetailed? department;
//   final LookupItemDetailed? unit;
//   final LookupItemDetailed? contractor;
//   final LookupItemDetailed? permitType;
//   final LookupItemDetailed? shift;
//   final LookupItemDetailed? permittingIssue;
//   final ApproverDetailed? approver;
//   final String? foreman;
//   final EmployeeDetailed? employee;
//   final LookupItemDetailed? company;
//   final LookupItemDetailed? shiftDelay;
//   final DelayTypeDetailed? delayType;
//   final LookupItemDetailed? startOfWorkDelay;
//   final LookupItemDetailed? reworkDelay;
//   final LookupItemDetailed? ongoingWorkDelay;
//   final bool? isArchived;
//   final int? id;
//   final String? activeStatus;
//
//   TOTLogRequestPut({
//     this.date,
//     this.twrModel,
//     this.permitNo,
//     this.delayDescription,
//     this.workScope,
//     this.manHours,
//     this.startOfWork,
//     this.timeRequested,
//     this.timeSigned,
//     this.comment,
//     this.reasonForRequest,
//     this.jobDescription,
//     this.manPowerAffected,
//     this.equipmentNo,
//     this.hoursDelayed,
//     this.status,
//     this.department,
//     this.unit,
//     this.contractor,
//     this.permitType,
//     this.shift,
//     this.permittingIssue,
//     this.approver,
//     this.foreman,
//     this.employee,
//     this.company,
//     this.shiftDelay,
//     this.delayType,
//     this.startOfWorkDelay,
//     this.reworkDelay,
//     this.ongoingWorkDelay,
//     this.isArchived,
//     this.id,
//     this.activeStatus,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       'date': date,
//       'twrModel': twrModel?.toJson(),
//       'permitNo': permitNo,
//       'delayDescription': delayDescription,
//       'workScope': workScope,
//       'manHours': manHours,
//       'startOfWork': startOfWork,
//       'timeRequested': timeRequested,
//       'timeSigned': timeSigned,
//       'comment': comment,
//       'reasonForRequest': reasonForRequest?.toJson(),
//       'jobDescription': jobDescription,
//       'manPowerAffected': manPowerAffected,
//       'equipmentNo': equipmentNo,
//       'hoursDelayed': hoursDelayed,
//       'status': status,
//       'department': department?.toJson(),
//       'unit': unit?.toJson(),
//       'contractor': contractor?.toJson(),
//       'permitType': permitType?.toJson(),
//       'shift': shift?.toJson(),
//       'permittingIssue': permittingIssue?.toJson(),
//       'approver': approver?.toJson(),
//       'foreman': foreman,
//       'employee': employee?.toJson(),
//       'company': company?.toJson(),
//       'shiftDelay': shiftDelay?.toJson(),
//       'delayType': delayType?.toJson(),
//       'startOfWorkDelay': startOfWorkDelay?.toJson(),
//       'reworkDelay': reworkDelay?.toJson(),
//       'ongoingWorkDelay': ongoingWorkDelay?.toJson(),
//       'isArchived': isArchived,
//       'id': id,
//       'activeStatus': activeStatus,
//     };
//   }
// }

class TOTLogRequestPut {
  final String? date;
  final TWRModelDetailed? twrModel;
  final String? permitNo;
  final String? delayDescription;
  final String? workScope;
  final int? manHours;
  final String? startOfWork;
  final String? timeRequested;
  final String? timeSigned;
  final String? comment;
  final LookupItemDetailed? reasonForRequest;
  final String? jobDescription;
  final int? manPowerAffected;
  final String? equipmentNo;
  final int? hoursDelayed;
  final String? status;
  final bool? isArchived;
  final LookupItemDetailed? department;
  final LookupItemDetailed? unit;

  final LookupItemDetailed? permitType;
  final LookupItemDetailed? shift;
  final LookupItemDetailed? permittingIssue;
  final ApproverDetailed? approver;
  final String? foreman;
  final EmployeeDetailed? employee;
  final LookupItemDetailed? company;
  final LookupItemDetailed? shiftDelay;
  final DelayTypeDetailed? delayType;

  final int? id;



  TOTLogRequestPut({
    this.date,
    this.twrModel,
    this.permitNo,
    this.delayDescription,
    this.workScope,
    this.manHours,
    this.startOfWork,
    this.timeRequested,
    this.isArchived,
    this.timeSigned,
    this.comment,
    this.reasonForRequest,
    this.jobDescription,
    this.manPowerAffected,
    this.equipmentNo,
    this.hoursDelayed,
    this.status,
    this.department,
    this.unit,

    this.permitType,
    this.shift,
    this.permittingIssue,
    this.approver,
    this.foreman,
    this.employee,
    this.company,
    this.shiftDelay,
    this.delayType,
    this.id,

  });

  Map<String, dynamic> toJson() {
    return {
      'date': date?.toString(),
      'twrModel': twrModel?.toJson(),
      'permitNo': permitNo,
      'delayDescription': delayDescription,
      'workScope': workScope,
      'manHours': manHours,
      'startOfWork': startOfWork?.toString(),
      'timeRequested': timeRequested,
      'timeSigned': timeSigned,
      'comment': comment,
      'reasonForRequest': reasonForRequest?.toJson(),
      'jobDescription': jobDescription,
      'manPowerAffected': manPowerAffected,
      'equipmentNo': equipmentNo,
      'hoursDelayed': hoursDelayed,
      'status': status,
      'isArchived': isArchived,
      'department': department?.toJson(),
      'unit': unit?.toJson(),

      'permitType': permitType?.toJson(),
      'shift': shift?.toJson(),
      'permittingIssue': permittingIssue?.toJson(),
      'approver': approver?.toJson(),
      'foreman': foreman,
      'employee': employee?.toJson(),
      'company': company?.toJson(),
      'shiftDelay': shiftDelay?.toJson(),
      'delayType': delayType?.toJson(),
      'id': id,

    };
  }
}

// WRRLog Request Models - Updated to match API specification
class WRRLogRequestPost {
  final String? dateRodReturned;
  final String? calibrationDate;
  final String? fumeControlUsed;
  final String? workScope;
  final TWRModelDetailed? twrModel;
  final String? email;
  final String? rodCheckedOut;
  final double? rodCheckedOutLbs;
  final double? rodReturnedWasteLbs;
  final String? status;
  final bool? isArchived;
  final LookupItemDetailed? department;
  final EmployeeDetailed? employee;
  final LookupItemDetailed? unit;
  final LookupItemDetailed? rodType;
  final LookupItemDetailed? weldMethod;
  final LookupItemDetailed? location;
  final ApproverDetailed? approver;
  final LookupItemDetailed? company;
  final String? comment;
  final String? activeStatus;

  WRRLogRequestPost({
    this.dateRodReturned,
    this.calibrationDate,
    this.fumeControlUsed,
    this.workScope,
    this.twrModel,
    this.email,
    this.rodCheckedOut,
    this.rodCheckedOutLbs,
    this.rodReturnedWasteLbs,
    this.status,
    this.isArchived,
    this.department,
    this.employee,
    this.unit,
    this.rodType,
    this.weldMethod,
    this.location,
    this.approver,
    this.company,
    this.comment,
    this.activeStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'dateRodReturned': dateRodReturned,
      'calibrationDate': calibrationDate,
      'fumeControlUsed': fumeControlUsed,
      'workScope': workScope,
      'twrModel': twrModel?.toJson(),
      'email': email,
      'rodCheckedOut': rodCheckedOut,
      'rodCheckedOutLbs': rodCheckedOutLbs,
      'rodReturnedWasteLbs': rodReturnedWasteLbs,
      'status': status,
      'isArchived': isArchived,
      'department': department?.toJson(),
      'employee': employee?.toJson(),
      'unit': unit?.toJson(),
      'rodType': rodType?.toJson(),
      'weldMethod': weldMethod?.toJson(),
      'location': location?.toJson(),
      'approver': approver?.toJson(),
      'company': company?.toJson(),
      'comment': comment,
      'activeStatus': activeStatus,
    };
  }
}

class WRRLogRequestPut {
  final int? id;
  final String? dateRodReturned;
  final String? calibrationDate;
  final String? fumeControlUsed;
  final String? workScope;
  final TWRModelDetailed? twrModel;
  final String? email;
  final String? rodCheckedOut;
  final double? rodCheckedOutLbs;
  final double? rodReturnedWasteLbs;
  final String? status;
  final bool? isArchived;
  final LookupItemDetailed? department;
  final EmployeeDetailed? employee;
  final LookupItemDetailed? unit;
  final LookupItemDetailed? rodType;
  final LookupItemDetailed? weldMethod;
  final LookupItemDetailed? location;
  final ApproverDetailed? approver;
  final LookupItemDetailed? company;
  final String? comment;
  final String? activeStatus;

  WRRLogRequestPut({
    this.id,
    this.dateRodReturned,
    this.calibrationDate,
    this.fumeControlUsed,
    this.workScope,
    this.twrModel,
    this.email,
    this.rodCheckedOut,
    this.rodCheckedOutLbs,
    this.rodReturnedWasteLbs,
    this.status,
    this.isArchived,
    this.department,
    this.employee,
    this.unit,
    this.rodType,
    this.weldMethod,
    this.location,
    this.approver,
    this.company,
    this.comment,
    this.activeStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateRodReturned': dateRodReturned,
      'calibrationDate': calibrationDate,
      'fumeControlUsed': fumeControlUsed,
      'workScope': workScope,
      'twrModel': twrModel?.toJson(),
      'email': email,
      'rodCheckedOut': rodCheckedOut,
      'rodCheckedOutLbs': rodCheckedOutLbs,
      'rodReturnedWasteLbs': rodReturnedWasteLbs,
      'status': status,
      'isArchived': isArchived,
      'department': department?.toJson(),
      'employee': employee?.toJson(),
      'unit': unit?.toJson(),
      'rodType': rodType?.toJson(),
      'weldMethod': weldMethod?.toJson(),
      'location': location?.toJson(),
      'approver': approver?.toJson(),
      'company': company?.toJson(),
      'comment': comment,
      'activeStatus': activeStatus,
    };
  }
}

// Legacy WRRLog Request Model (keeping for backward compatibility)
class WRRLogRequest {
  final int? id;
  final DepartmentRef? department;
  final UnitRef? unit;
  final ApproverRef? approver;
  final CompanyRef? company;
  final String? calibrationDate;
  final bool? fumeControlUsed;
  final RodTypeRef? rodType;
  final TWRModel? twrModel;
  final WeldMethodRef? weldMethod;
  final String? rodCheckedOut;
  final LocationRef? location;
  final double? rodCheckedOutLbs;
  final double? rodReturnedWasteLbs;
  final String? dateRodReturned;
  final EmployeeRef? employee;

  WRRLogRequest({
    this.id,
    this.department,
    this.unit,
    this.approver,
    this.company,
    this.calibrationDate,
    this.fumeControlUsed,
    this.rodType,
    this.twrModel,
    this.weldMethod,
    this.rodCheckedOut,
    this.location,
    this.rodCheckedOutLbs,
    this.rodReturnedWasteLbs,
    this.dateRodReturned,
    this.employee,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'department': department?.toJson(),
      'unit': unit?.toJson(),
      'approver': approver?.toJson(),
      'company': company?.toJson(),
      'calibrationDate': calibrationDate,
      'fumeControlUsed': fumeControlUsed,
      'rodType': rodType?.toJson(),
      'twrModel': twrModel?.toJson(),
      'weldMethod': weldMethod?.toJson(),
      'rodCheckedOut': rodCheckedOut,
      'location': location?.toJson(),
      'rodCheckedOutLbs': rodCheckedOutLbs,
      'rodReturnedWasteLbs': rodReturnedWasteLbs,
      'dateRodReturned': dateRodReturned,
      'employee': employee?.toJson(),
    };
  }
}

// OverrideLog Request Models (for multipart/form-data)
class OverrideLogRequest {
  final int? id;
  final DepartmentRef? department;
  final UnitRef? unit;
  final ApproverRef? approver;
  final ShiftRef? shift;
  final String? workCompletedDate;
  final CompanyRef? company;
  final String? poNumber;
  final String? workScope;
  final OverrideCategoryRef? overrideCategory;
  final String? reason;
  final List<OverrideCost>? costs;
  final ClippedEmployeesFile? clippedEmployees;
  final EmployeeRef? employee;

  OverrideLogRequest({
    this.id,
    this.department,
    this.unit,
    this.approver,
    this.shift,
    this.workCompletedDate,
    this.company,
    this.poNumber,
    this.workScope,
    this.overrideCategory,
    this.reason,
    this.costs,
    this.clippedEmployees,
    this.employee,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'department': department?.toJson(),
      'unit': unit?.toJson(),
      'approver': approver?.toJson(),
      'shift': shift?.toJson(),
      'workCompletedDate': workCompletedDate,
      'company': company?.toJson(),
      'poNumber': poNumber,
      'workScope': workScope,
      'overrideCategory': overrideCategory?.toJson(),
      'reason': reason,
      'costs': costs?.map((cost) => cost.toJson()).toList(),
      'ClippedEmployees': clippedEmployees?.toJson(),
      'employee': employee?.toJson(),
    };
  }
}

// Override Log Request Models - Updated for multipart/form-data
class OverrideLogRequestPost {
  final String? workScope;
  final String? reason;
  final String? description;
  final String? workCompletedDate;
  final String? poNumber;
  final String? overrideCategory;
  final String? employeeNames;
  final String? comment;
  final String? reasonForRequest;
  final String? status;
  final String? formattedStatus;
  final String? activeStatus;
  final bool? isArchived;
  final bool? isCreated;
  final OverrideDepartment? department;
  final OverrideUnit? unit;
  final OverrideCompany? company;
  final OverrideApprover? approver;
  final OverrideEmployee? employee;
  final OverrideShift? shift;
  final OverrideDelayType? delayType;
  final OverrideReasonForRequest? reasonForRequestObj;
  final OverrideClippedEmployees? clippedEmployees;
  final List<OverrideCosts>? costs;

  OverrideLogRequestPost({
    this.workScope,
    this.reason,
    this.description,
    this.workCompletedDate,
    this.poNumber,
    this.overrideCategory,
    this.employeeNames,
    this.comment,
    this.reasonForRequest,
    this.status,
    this.formattedStatus,
    this.activeStatus,
    this.isArchived,
    this.isCreated,
    this.department,
    this.unit,
    this.company,
    this.approver,
    this.employee,
    this.shift,
    this.delayType,
    this.reasonForRequestObj,
    this.clippedEmployees,
    this.costs,
  });

  Map<String, dynamic> toFormData() {
    final Map<String, dynamic> formData = {};
    
    // Basic fields
    if (workScope != null) formData['WorkScope'] = workScope;
    if (reason != null) formData['Reason'] = reason;
    if (description != null) formData['Description'] = description;
    if (workCompletedDate != null) formData['WorkCompletedDate'] = workCompletedDate;
    if (poNumber != null) formData['PoNumber'] = poNumber;
    if (overrideCategory != null) formData['OverrideCategory'] = overrideCategory;
    if (employeeNames != null) formData['EmployeeNames'] = employeeNames;
    if (comment != null) formData['Comment'] = comment;
    if (reasonForRequest != null) formData['ReasonForRequest.Name'] = reasonForRequest;
    if (status != null) formData['Status'] = status;
    if (formattedStatus != null) formData['FormattedStatus'] = formattedStatus;
    if (activeStatus != null) formData['ActiveStatus'] = activeStatus;
    if (isArchived != null) formData['IsArchived'] = isArchived.toString();
    if (isCreated != null) formData['IsCreated'] = isCreated.toString();

    // Department fields
    if (department != null) {
      formData['Department.Id'] = department!.id?.toString();
      formData['Department.Name'] = department!.name;
      formData['Department.IsValidationEnabled'] = department!.isValidationEnabled.toString();
      formData['Department.ErrorMessage'] = department!.errorMessage ?? '';
    }

    // Unit fields
    if (unit != null) {
      formData['Unit.Id'] = unit!.id?.toString();
      formData['Unit.Name'] = unit!.name;
      formData['Unit.IsValidationEnabled'] = unit!.isValidationEnabled.toString();
      formData['Unit.ErrorMessage'] = unit!.errorMessage ?? '';
    }

    // Company fields
    if (company != null) {
      formData['Company.Id'] = company!.id?.toString();
      formData['Company.Name'] = company!.name;
      formData['Company.IsValidationEnabled'] = company!.isValidationEnabled.toString();
      formData['Company.ErrorMessage'] = company!.errorMessage ?? '';
    }

    // Approver fields
    if (approver != null) {
      formData['Approver.Id'] = approver!.id?.toString();
      formData['Approver.Name'] = approver!.name;
      formData['Approver.Email'] = approver!.email;
      formData['Approver.IsValidationEnabled'] = approver!.isValidationEnabled.toString();
      formData['Approver.ErrorMessage'] = approver!.errorMessage ?? '';
    }

    // Employee fields
    if (employee != null) {
      formData['Employee.Id'] = employee!.id?.toString();
      formData['Employee.Name'] = employee!.name;
      formData['Employee.Email'] = employee!.email;
      formData['Employee.IsValidationEnabled'] = employee!.isValidationEnabled.toString();
      formData['Employee.ErrorMessage'] = employee!.errorMessage ?? '';
    }

    // Shift fields
    if (shift != null) {
      formData['Shift.Id'] = shift!.id?.toString();
      formData['Shift.Name'] = shift!.name;
      formData['Shift.IsValidationEnabled'] = shift!.isValidationEnabled.toString();
      formData['Shift.ErrorMessage'] = shift!.errorMessage ?? '';
    }

    // DelayType fields
    if (delayType != null) {
      formData['DelayType.Id'] = delayType!.id?.toString();
      formData['DelayType.Name'] = delayType!.name;
      formData['DelayType.Identifier'] = delayType!.identifier;
      formData['DelayType.IsValidationEnabled'] = delayType!.isValidationEnabled.toString();
      formData['DelayType.ErrorMessage'] = delayType!.errorMessage ?? '';
    }

    // ReasonForRequest fields
    if (reasonForRequestObj != null) {
      formData['ReasonForRequest.Id'] = reasonForRequestObj!.id?.toString();
      formData['ReasonForRequest.Name'] = reasonForRequestObj!.name;
      formData['ReasonForRequest.IsValidationEnabled'] = reasonForRequestObj!.isValidationEnabled.toString();
      formData['ReasonForRequest.ErrorMessage'] = reasonForRequestObj!.errorMessage ?? '';
    }

    // ClippedEmployees fields
    if (clippedEmployees != null) {
      formData['ClippedEmployees.Type'] = clippedEmployees!.type ?? '';
      formData['ClippedEmployees.Name'] = clippedEmployees!.name ?? '';
      formData['ClippedEmployees.Url'] = clippedEmployees!.url ?? '';
      // File will be handled separately in FormData
    }

    // Costs fields - Updated to match reference structure
    if (costs != null && costs!.isNotEmpty) {
      for (int i = 0; i < costs!.length; i++) {
        final cost = costs![i];
        final costFields = cost.toFormDataFields(i);
        formData.addAll(costFields);
      }
    }

    return formData;
  }
}

class OverrideLogRequestPut extends OverrideLogRequestPost {
  final int? id;

  OverrideLogRequestPut({
    this.id,
    String? workScope,
    String? reason,
    String? description,
    String? workCompletedDate,
    String? poNumber,
    String? overrideCategory,
    String? employeeNames,
    String? comment,
    String? reasonForRequest,
    String? status,
    String? formattedStatus,
    String? activeStatus,
    bool? isArchived,
    bool? isCreated,
    OverrideDepartment? department,
    OverrideUnit? unit,
    OverrideCompany? company,
    OverrideApprover? approver,
    OverrideEmployee? employee,
    OverrideShift? shift,
    OverrideDelayType? delayType,
    OverrideReasonForRequest? reasonForRequestObj,
    OverrideClippedEmployees? clippedEmployees,
    List<OverrideCosts>? costs,
  }) : super(
          workScope: workScope,
          reason: reason,
          description: description,
          workCompletedDate: workCompletedDate,
          poNumber: poNumber,
          overrideCategory: overrideCategory,
          employeeNames: employeeNames,
          comment: comment,
          reasonForRequest: reasonForRequest,
          status: status,
          formattedStatus: formattedStatus,
          activeStatus: activeStatus,
          isArchived: isArchived,
          isCreated: isCreated,
          department: department,
          unit: unit,
          company: company,
          approver: approver,
          employee: employee,
          shift: shift,
          delayType: delayType,
          reasonForRequestObj: reasonForRequestObj,
          clippedEmployees: clippedEmployees,
          costs: costs,
        );

  @override
  Map<String, dynamic> toFormData() {
    final formData = super.toFormData();
    if (id != null) {
      formData['Id'] = id.toString();
    }
    return formData;
  }
}

// Supporting models for Override requests
class OverrideDepartment {
  final int? id;
  final String? name;
  final bool? isValidationEnabled;
  final String? errorMessage;

  OverrideDepartment({
    this.id,
    this.name,
    this.isValidationEnabled,
    this.errorMessage,
  });
}

class OverrideUnit {
  final int? id;
  final String? name;
  final bool? isValidationEnabled;
  final String? errorMessage;

  OverrideUnit({
    this.id,
    this.name,
    this.isValidationEnabled,
    this.errorMessage,
  });
}

class OverrideCompany {
  final int? id;
  final String? name;
  final bool? isValidationEnabled;
  final String? errorMessage;

  OverrideCompany({
    this.id,
    this.name,
    this.isValidationEnabled,
    this.errorMessage,
  });
}

class OverrideApprover {
  final int? id;
  final String? name;
  final String? email;
  final bool? isValidationEnabled;
  final String? errorMessage;

  OverrideApprover({
    this.id,
    this.name,
    this.email,
    this.isValidationEnabled,
    this.errorMessage,
  });
}

class OverrideEmployee {
  final int? id;
  final String? name;
  final String? email;
  final bool? isValidationEnabled;
  final String? errorMessage;

  OverrideEmployee({
    this.id,
    this.name,
    this.email,
    this.isValidationEnabled,
    this.errorMessage,
  });
}

class OverrideShift {
  final int? id;
  final String? name;
  final bool? isValidationEnabled;
  final String? errorMessage;

  OverrideShift({
    this.id,
    this.name,
    this.isValidationEnabled,
    this.errorMessage,
  });
}

class OverrideDelayType {
  final int? id;
  final String? name;
  final String? identifier;
  final bool? isValidationEnabled;
  final String? errorMessage;

  OverrideDelayType({
    this.id,
    this.name,
    this.identifier,
    this.isValidationEnabled,
    this.errorMessage,
  });
}

class OverrideReasonForRequest {
  final int? id;
  final String? name;
  final bool? isValidationEnabled;
  final String? errorMessage;

  OverrideReasonForRequest({
    this.id,
    this.name,
    this.isValidationEnabled,
    this.errorMessage,
  });
}

class OverrideClippedEmployees {
  final String? type;
  final String? name;
  final String? url;
  final MultipartFile? file;

  OverrideClippedEmployees({
    this.type,
    this.name,
    this.url,
    this.file,
  });
}

class OverrideCosts {
  final int id;
  final int? overrideHours;
  final String? overrideType;
  final int? headCount;
  final OverrideCraftSkill? craftSkill;
  final String? employeeName;
  final int? poNumber;
  final int? stHours;
  final int? otHours;
  final int? dtHours;
  final int? overrideLogId;

  OverrideCosts({
    this.id = 0,
    this.overrideHours,
    this.overrideType,
    this.headCount,
    this.craftSkill,
    this.employeeName,
    this.poNumber,
    this.stHours,
    this.otHours,
    this.dtHours,
    this.overrideLogId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'overrideHours': overrideHours,
      'overrideType': overrideType,
      'headCount': headCount,
      'craftSkill': craftSkill?.toJson(),
      'employeeName': employeeName,
      'poNumber': poNumber,
      'stHours': stHours,
      'otHours': otHours,
      'dtHours': dtHours,
      'overrideLogId': overrideLogId,
    };
  }

  // Method to generate form data fields for multipart/form-data
  Map<String, dynamic> toFormDataFields(int index) {
    final fields = <String, dynamic>{};
    
    // Basic cost fields
    fields['Costs[$index].Id'] = id;
    fields['Costs[$index].OverrideHours'] = overrideHours ?? 0;
    fields['Costs[$index].OverrideType'] = overrideType ?? '';
    fields['Costs[$index].HeadCount'] = headCount ?? 0;
    fields['Costs[$index].EmployeeName'] = employeeName ?? '';
    fields['Costs[$index].PoNumber'] = poNumber ?? 0;
    fields['Costs[$index].STHours'] = stHours ?? 0;
    fields['Costs[$index].OTHours'] = otHours ?? 0;
    fields['Costs[$index].DTHours'] = dtHours ?? 0;
    fields['Costs[$index].OverrideLogId'] = overrideLogId ?? 0;
    
    // Craft skill fields
    if (craftSkill != null) {
      fields['Costs[$index].CraftSkill.Name'] = craftSkill!.name ?? '';
      fields['Costs[$index].CraftSkill.STRate'] = craftSkill!.stRate ?? 0;
      fields['Costs[$index].CraftSkill.OTRate'] = craftSkill!.otRate ?? 0;
      fields['Costs[$index].CraftSkill.DTRate'] = craftSkill!.dtRate ?? 0;
      fields['Costs[$index].CraftSkill.ErrorMessage'] = craftSkill!.errorMessage ?? '';
      fields['Costs[$index].CraftSkill.IsValidationEnabled'] = craftSkill!.isValidationEnabled ?? true;
      fields['Costs[$index].CraftSkill.Id'] = craftSkill!.id ?? 0;
    }
    
    return fields;
  }
}

class OverrideCraftSkill {
  final String? name;
  final int? stRate;
  final int? otRate;
  final int? dtRate;
  final String? errorMessage;
  final bool? isValidationEnabled;
  final int? id;

  OverrideCraftSkill({
    this.name,
    this.stRate,
    this.otRate,
    this.dtRate,
    this.errorMessage = "",
    this.isValidationEnabled = true,
    this.id = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'stRate': stRate,
      'otRate': otRate,
      'dtRate': dtRate,
      'errorMessage': errorMessage,
      'isValidationEnabled': isValidationEnabled,
      'id': id,
    };
  }

  // Factory method to create from lookup CraftSkill
  factory OverrideCraftSkill.fromLookup(lookup.CraftSkill craftSkill) {
    return OverrideCraftSkill(
      name: craftSkill.name,
      stRate: craftSkill.stRate.toInt(),
      otRate: craftSkill.otRate.toInt(),
      dtRate: craftSkill.dtRate.toInt(),
      errorMessage: "",
      isValidationEnabled: true,
      id: craftSkill.id,
    );
  }
}

// FCOLog Request Models
class FCOLogRequest {
  final String? id;
  final String? employeeId;
  final String? departmentId;
  final String? unitId;
  final String? shiftId;
  final String? permitTypeId;
  final String? approverId;
  final String? delayTypeId;
  final String? startOfWorkDelayId;
  final String? shiftDelayId;
  final String? reworkDelayId;
  final String? ongoingWorkDelayId;
  final String? craftSkillId;
  final String? companyId;
  final String? description;
  final String? status;
  final String? filePath;
  final String? fileName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FCOLogRequest({
    this.id,
    this.employeeId,
    this.departmentId,
    this.unitId,
    this.shiftId,
    this.permitTypeId,
    this.approverId,
    this.delayTypeId,
    this.startOfWorkDelayId,
    this.shiftDelayId,
    this.reworkDelayId,
    this.ongoingWorkDelayId,
    this.craftSkillId,
    this.companyId,
    this.description,
    this.status,
    this.filePath,
    this.fileName,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'departmentId': departmentId,
      'unitId': unitId,
      'shiftId': shiftId,
      'permitTypeId': permitTypeId,
      'approverId': approverId,
      'delayTypeId': delayTypeId,
      'startOfWorkDelayId': startOfWorkDelayId,
      'shiftDelayId': shiftDelayId,
      'reworkDelayId': reworkDelayId,
      'ongoingWorkDelayId': ongoingWorkDelayId,
      'craftSkillId': craftSkillId,
      'companyId': companyId,
      'description': description,
      'status': status,
      'filePath': filePath,
      'fileName': fileName,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

// Generic Approve/Reject Request
class ApproveRejectRequest {
  final String? comment;
  final String? reason;

  ApproveRejectRequest({
    this.comment,
    this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'comment': comment,
      'reason': reason,
    };
  }
}

// Reference classes for API requests
class DepartmentRef {
  final int? id;
  
  DepartmentRef({this.id});
  
  Map<String, dynamic> toJson() => {'id': id};
}

class UnitRef {
  final int? id;
  
  UnitRef({this.id});
  
  Map<String, dynamic> toJson() => {'id': id};
}

class ApproverRef {
  final int? id;
  
  ApproverRef({this.id});
  
  Map<String, dynamic> toJson() => {'id': id};
}

class ShiftRef {
  final int? id;
  
  ShiftRef({this.id});
  
  Map<String, dynamic> toJson() => {'id': id};
}

class PermitTypeRef {
  final int? id;
  
  PermitTypeRef({this.id});
  
  Map<String, dynamic> toJson() => {'id': id};
}

class CompanyRef {
  final int? id;
  final String? name;
  
  CompanyRef({this.id, this.name});
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}

class DelayTypeRef {
  final int? id;
  final String? identifier;
  
  DelayTypeRef({this.id, this.identifier});
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'identifier': identifier,
  };
}

class DelayRef {
  final int? id;
  
  DelayRef({this.id});
  
  Map<String, dynamic> toJson() => {'id': id};
}

class EmployeeRef {
  final int? id;
  final String? name;
  
  EmployeeRef({this.id, this.name});
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}

class TWRModel {
  final TWRPart? alphabeticPart;
  final TWRPart? numericPart;
  final String? text;
  
  TWRModel({this.alphabeticPart, this.numericPart, this.text});
  
  Map<String, dynamic> toJson() => {
    'alphabeticPart': alphabeticPart?.toJson(),
    'numericPart': numericPart?.toJson(),
    'text': text,
  };
}

class TWRPart {
  final int? id;
  
  TWRPart({this.id});
  
  Map<String, dynamic> toJson() => {'id': id};
}

class RodTypeRef {
  final int? id;
  
  RodTypeRef({this.id});
  
  Map<String, dynamic> toJson() => {'id': id};
}

class WeldMethodRef {
  final int? id;
  
  WeldMethodRef({this.id});
  
  Map<String, dynamic> toJson() => {'id': id};
}

class LocationRef {
  final int? id;
  
  LocationRef({this.id});
  
  Map<String, dynamic> toJson() => {'id': id};
}

class OverrideCategoryRef {
  final int? id;
  
  OverrideCategoryRef({this.id});
  
  Map<String, dynamic> toJson() => {'id': id};
}

class OverrideCost {
  final OverrideTypeRef? overrideType;
  final double? hours;
  final CraftSkillRef? craftSkill;
  
  OverrideCost({this.overrideType, this.hours, this.craftSkill});
  
  Map<String, dynamic> toJson() => {
    'overrideType': overrideType?.toJson(),
    'hours': hours,
    'craftSkill': craftSkill?.toJson(),
  };
}

class OverrideTypeRef {
  final int? id;
  
  OverrideTypeRef({this.id});
  
  Map<String, dynamic> toJson() => {'id': id};
}

class CraftSkillRef {
  final int? id;
  
  CraftSkillRef({this.id});
  
  Map<String, dynamic> toJson() => {'id': id};
}

class ClippedEmployeesFile {
  final String? fileName;
  final String? type;
  final String? uri;
  
  ClippedEmployeesFile({this.fileName, this.type, this.uri});
  
  Map<String, dynamic> toJson() => {
    'fileName': fileName,
    'type': type,
    'uri': uri,
  };
}

// ==================== DETAILED MODELS FOR TOTLOG ====================

// Detailed TWR Model for TOTLog
class TWRModelDetailed {
  final String? name;
  final TWRPartDetailed? numericPart;
  final TWRPartDetailed? alphabeticPart;
  final String? text;
  
  TWRModelDetailed({
    this.name,
    this.numericPart,
    this.alphabeticPart,
    this.text,
  });
  
  Map<String, dynamic> toJson() => {
    'name': name,
    'numericPart': numericPart?.toJson(),
    'alphabeticPart': alphabeticPart?.toJson(),
    'text': text,
  };
}

// Detailed TWR Part
class TWRPartDetailed {
  final String? id;
  final String? text;
  
  TWRPartDetailed({this.id, this.text});
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
  };
}

// Detailed Lookup Item
class LookupItemDetailed {
  final String? name;
  final String? errorMessage;
  final bool? isValidationEnabled ;
  final int? id;
  
  LookupItemDetailed({
    this.name,
    this.errorMessage = "",
    this.isValidationEnabled = true,
    this.id,
  });
  
  Map<String, dynamic> toJson() => {
    'name': name,
    'errorMessage': errorMessage,
    'isValidationEnabled': isValidationEnabled,
    'id': id,
  };
}

// Detailed Approver
class ApproverDetailed {
  final String? name;
  final String? email;
  final String? errorMessage;
  final bool? isValidationEnabled;
  final int? id;
  
  ApproverDetailed({
    this.name,
    this.email,
       this.errorMessage = "",
    this.isValidationEnabled = true,
    this.id,
  });
  
  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'errorMessage': errorMessage,
    'isValidationEnabled': isValidationEnabled,
    'id': id,
  };
}

// Detailed Employee
class EmployeeDetailed {
  final String? name;
  final String? email;
  final String? errorMessage;
  final bool? isValidationEnabled;
  final int? id;
  
  EmployeeDetailed({
    this.name,
    this.email,
    this.errorMessage = "",
    this.isValidationEnabled = true,
    this.id,
  });
  
  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'errorMessage': errorMessage,
    'isValidationEnabled': isValidationEnabled,
    'id': id,
  };
}

// Detailed Delay Type
class DelayTypeDetailed {
  final String? name;
  final String? identifier;
  final String? errorMessage;
  final bool? isValidationEnabled;
  final int? id;
  
  DelayTypeDetailed({
    this.name,
    this.identifier,
    this.errorMessage = "",
    this.isValidationEnabled = true,
    this.id,
  });
  
  Map<String, dynamic> toJson() => {
    'name': name,
    'identifier': identifier,
    'errorMessage': errorMessage,
    'isValidationEnabled': isValidationEnabled,
    'id': id,
  };
}

// ==================== TRACKING UPDATE REQUEST ====================

class TrackingUpdateRequest {
  final int? id;
  final int? supplierId;
  final int? manufacturerId;
  final String? equipmentDescription; // Free text field
  final String? vinSerial;
  final String? licensePlate;
  final int? tagMasterId;
  final int? conditionId;
  final File? photo; // Single photo for License Photo

  TrackingUpdateRequest({
    this.id,
    this.supplierId,
    this.manufacturerId,
    this.equipmentDescription,
    this.vinSerial,
    this.licensePlate,
    this.tagMasterId,
    this.conditionId,
    this.photo,
  });

  /// Convert to FormData map for multipart/form-data
  Map<String, dynamic> toFormData() {
    final Map<String, dynamic> formData = {};
    
    if (id != null) formData['Id'] = id.toString();
    if (supplierId != null) formData['SupplierId'] = supplierId.toString();
    if (manufacturerId != null) formData['ManufacturerId'] = manufacturerId.toString();
    formData['EquipmentDescription'] = equipmentDescription ?? '';
    if (vinSerial != null && vinSerial!.isNotEmpty) formData['VinSerial'] = vinSerial;
    if (licensePlate != null && licensePlate!.isNotEmpty) formData['LicensePlate'] = licensePlate;
    if (tagMasterId != null) formData['TagMasterId'] = tagMasterId.toString();
    if (conditionId != null) formData['ConditionId'] = conditionId.toString();
    // Photo will be handled separately in FormData
    
    return formData;
  }
}

// ==================== TRACKING RETURN REQUEST ====================

class TrackingReturnRequest {
  final int conditionId;
  final String? returnDate;
  final String? mileage;
  final String? notes;
  final List<File>? photos; // Multiple photos

  TrackingReturnRequest({
    required this.conditionId,
    this.returnDate,
    this.mileage,
    this.notes,
    this.photos,
  });

  /// Convert to FormData map for multipart/form-data
  Map<String, dynamic> toFormData() {
    final Map<String, dynamic> formData = {};
    
    if (conditionId != null) formData['Custodian'] = conditionId.toString();
    formData['ReturnDate'] = returnDate ?? '';
    formData['Milage'] = mileage ?? '';
    formData['Notes'] = notes ?? '';
    // Photos will be handled separately in FormData
    
    return formData;
  }
}

// ==================== TRACKING ASSIGN REQUEST ====================

class TrackingAssignRequest {
  final int? companyId;
  final int? ownerId;
  final String? assignDate;
  final String? expectedReturnDate;
  final int? conditionId;
  final int? tagMasterId;
  final String? mileage;
  final String? notes;
  final List<File>? photos; // Multiple photos

  TrackingAssignRequest({
    this.companyId,
    this.ownerId,
    this.assignDate,
    this.expectedReturnDate,
    this.conditionId,
    this.tagMasterId,
    this.mileage,
    this.notes,
    this.photos,
  });

  /// Convert to FormData map for multipart/form-data
  Map<String, dynamic> toFormData() {
    final Map<String, dynamic> formData = {};
    
    if (companyId != null) formData['CompanyId'] = companyId.toString();
    if (ownerId != null) formData['OwnerId'] = ownerId.toString();
    formData['AssignDate'] = assignDate ?? '';
    formData['ExpectedReturnDate'] = expectedReturnDate ?? '';
    if (conditionId != null) formData['Custodian'] = conditionId.toString();
    if (tagMasterId != null) formData['TagMasterId'] = tagMasterId.toString();
    formData['Milage'] = mileage ?? '';
    formData['Notes'] = notes ?? '';
    // Photos will be handled separately in FormData
    
    return formData;
  }
}

// ==================== TRACKING CREATE REQUEST ====================

class TrackingCreateRequest {
  final int? supplierId;
  final int? manufacturerId;
  final String? equipmentDescription; // Free text field
  final String? vinSerial;
  final String? licensePlate;
  final int? tagMasterId;
  final String? custodian;
  final int? companyId;
  final String? assignDate; // Pick Up Date / Rental Date
  final String? expectedReturnDate; // Anticipated Return Date
  final String? deliveryNotes;
  final int? conditionId;
  final File? photo; // Single photo for License Photo

  TrackingCreateRequest({
    this.supplierId,
    this.manufacturerId,
    this.equipmentDescription,
    this.vinSerial,
    this.licensePlate,
    this.tagMasterId,
    this.custodian,
    this.companyId,
    this.assignDate,
    this.expectedReturnDate,
    this.deliveryNotes,
    this.conditionId,
    this.photo,
  });

  /// Convert to FormData map for multipart/form-data
  Map<String, dynamic> toFormData() {
    final Map<String, dynamic> formData = {};
    
    formData['SupplierId'] = supplierId?.toString() ?? '';
    formData['ManufacturerId'] = manufacturerId?.toString() ?? '';
    formData['EquipmentDescription'] = equipmentDescription ?? '';
    formData['VinSerial'] = vinSerial ?? '';
    formData['LicensePlate'] = licensePlate ?? '';
    if (tagMasterId != null) formData['TagMasterId'] = tagMasterId.toString();
    formData['Custodian'] = custodian ?? '';
    if (companyId != null) formData['CompanyId'] = companyId.toString();
    formData['AssignDate'] = assignDate ?? '';
    formData['ExpectedReturnDate'] = expectedReturnDate ?? '';
    formData['DeliveryNotes'] = deliveryNotes ?? '';
    if (conditionId != null) formData['ConditionId'] = conditionId.toString();
    // Photo will be handled separately in FormData
    
    return formData;
  }
}

