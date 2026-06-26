class ApiConstants {
  // Base URL
  //  static const String baseUrl = 'https://hrdeveliteapi.eztrak.net/api';
  //  static const String base = 'https://hrdeveliteapi.eztrak.net';

   //Testing
 static const String baseUrl = 'http://195.26.242.125:82/api';
 static const String base = 'https://rental.eztraksoftware.com';
 

  // API Endpoints
  static const String notification = '/Notification';
  static const String delayType = '/DelayType';
  static const String updateStatus = '/UpdateStatus';
  // static const String dashboardTotCharts = '/Dashboard/GetTOTCharts';
  // static const String folder = '/Folder';
  // static const String dropbox = '/Dropbox';
  // static const String totLog = '/TOTLog';
  // static const String wrrLog = '/WRRLog';
  // static const String overrideLog = '/OverrideLog';
  // static const String fcoLog = '/FCOLog';
  
  // Detail endpoints for individual submissions
  // static const String totLogDetail = '/TOTLog';
  // static const String overrideLogDetail = '/OverrideLog';
  // static const String wrrLogDetail = '/WRRLog';
  // static const String department = '/Department';
  // static const String unit = '/Unit';
  // static const String approver = '/Approver';
  // static const String shift = '/Shift';
  // static const String permitType = '/PermitType';
  // static const String company = '/Company';
  // static const String craftSkill = '/CraftSkill';
  // static const String startOfWorkDelay = '/StartOfWorkDelay';
  // static const String shiftDelay = '/ShiftDelay';
  // static const String reworkDelay = '/ReworkDelay';
  // static const String ongoingWorkDelay = '/OngoingWorkDelay';
  // static const String employee = '/Employee';
  static const String accountLogin = '/Account/Login';
  static const String accountLoginUsingPincode = '/Account/Login';
  // static const String accountLoginUsingPincode = '/Account/LoginUsingPincode';
  static const String accountResetPassword = '/Account/ResetPassword';
  static const String accountForgotPassword = '/Account/ForgotPassword';
  static const String accountDelete = '/Account/Delete';
  static const String pendingApproval = '/Approval';
  static const String trackingGet = '/Tracking/Get';
  static const String trackingPost = '/Tracking/Post';
  static const String trackingPut = '/Tracking/Put';
  static const String trackingReturn = '/Tracking/Return';
  static const String trackingAssign = '/Tracking/Assign';
  static const String trackingHistory = '/Tracking/TrackingHistory';
  static const String trackingDashboardStats = '/Tracking/GetDashboardStats';
  static const String trackingGetMapData = '/TrackingDevice/GetMapData';
  
  // Tracking dropdown APIs
  static const String manufacturerGet = '/Manufacturer/Get';
  static const String conditionGet = '/Condition/Get';
  static const String supplierGet = '/Supplier/Get';
  static const String equipmentGet = '/Equipment/Get';
  static const String equipmentDescriptionGet = '/EquipmentDescription/Get';
  static const String tagMasterGet = '/TagMaster/Get';
  static const String trackingCompanyInformation = '/Tracking/CompanyInformation';
  static const String trackingGetCompanyContacts = '/Tracking/GetCompanyContacts';

  // TOTLog specific endpoints
  static const String totLogGetTWRNumericValues = '/TOTLog/GetTWRNumericValues';
  static const String totLogGetTWRAphabeticValues = '/TOTLog/GetTWRAphabeticValues';

  // FCOLog specific endpoints
  static const String fcoLogApprove = '/FCOLog/Approve';

  // Dynamic approve/reject endpoint pattern
  // static const String dynamicApproveReject = '/{apiUrl}/{id}/{status}';

  // Query Parameters
  static const String typeParam = 'Type';
  static const String disablePaginationParam = 'DisablePagination';
  static const String companyIdParam = 'Company.Id';

  // Common Values
  static const String pushType = 'Push';
  static const String disablePaginationTrue = 'true';

  // Headers
  static const String authorizationHeader = 'Authorization';
  static const String contentTypeHeader = 'Content-Type';
  static const String bearerPrefix = 'Bearer ';
  static const String applicationJson = 'application/json';

  // Status Values
  static const String approvedStatus = 'Approved';
  static const String rejectedStatus = 'Rejected';


  //Statistics
  static const String statistics = '${base}/ApproverDashboard';

  // Approval
  static const String approval = '/Approval';

  // Lookup APIs
  static const String departments = '/Department';
  static const String units = '/Unit';
  static const String approvers = '/Approver';
  static const String shifts = '/Shift';
  static const String permitTypes = '/PermitType';
  static const String companies = '/Company';
  static const String delayTypes = '/DelayType';
  static const String twrNumericValues = '/TOTLog/GetTWRNumericValues';
  static const String twrAlphabeticValues = '/TOTLog/GetTWRAphabeticValues';
  static const String overrideCategories = '/OverrideLog/GetOverrideCategories';
  static const String craftSkills = '/CraftSkill';
  static const String rodTypes = '/RodType';
  static const String weldMethods = '/WeldMethod';
  static const String locations = '/Location';

}