import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../api/models/response_models.dart';

class PreferenceManager {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userCodeKey = 'user_code';
  static const String _isFirstTimeKey = 'is_first_time';
  
  // User data keys
  static const String _userDetailKey = 'user_detail';
  static const String _tokenKey = 'auth_token';
  static const String _emailKey = 'user_email';
  static const String _expiryKey = 'token_expiry';
  static const String _userIdKey = 'user_id';
  static const String _userRoleKey = 'user_role';
  static const String _userNameKey = 'user_name';
  static const String _fullNameKey = 'full_name';
  static const String _isApprovedKey = 'is_approved';
  static const String _canAddLogsKey = 'can_add_logs';
  static const String _disableNotificationsKey = 'disable_notifications';
  static const String _activeStatusKey = 'active_status';
  static const String _contractorKey = 'contractor';
  static const String _companyKey = 'company';
  static const String _associationsKey = 'associations';
  static const String _accessCodeKey = 'access_code';
  static const String _formattedAccessCodeKey = 'formatted_access_code';
  static const String _changePasswordKey = 'change_password';
  static const String _formattedCanAddLogsKey = 'formatted_can_add_logs';
  static const String _formattedDisableNotificationsKey = 'formatted_disable_notifications';
  static const String _formattedStatusKey = 'formatted_status';
  static const String _userEmailKey = 'user_email_field';
  static const String _userNameFieldKey = 'user_name_field';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Login state management
  static Future<bool> isLoggedIn() async {
    await _ensureInitialized();
    return _prefs!.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    await _ensureInitialized();
    await _prefs!.setBool(_isLoggedInKey, value);
  }

  // User code management
  static Future<String?> getUserCode() async {
    await _ensureInitialized();
    return _prefs!.getString(_userCodeKey);
  }

  static Future<void> setUserCode(String code) async {
    await _ensureInitialized();
    await _prefs!.setString(_userCodeKey, code);
  }

  // First time user management
  static Future<bool> isFirstTime() async {
    await _ensureInitialized();
    return _prefs!.getBool(_isFirstTimeKey) ?? true;
  }

  static Future<void> setFirstTime(bool value) async {
    await _ensureInitialized();
    await _prefs!.setBool(_isFirstTimeKey, value);
  }

  // Logout functionality
  static Future<void> logout() async {
    await _ensureInitialized();
    await _prefs!.remove(_isLoggedInKey);
    await _prefs!.remove(_userCodeKey);
    await _prefs!.remove(_userDetailKey);
    await _prefs!.remove(_tokenKey);
    await _prefs!.remove(_emailKey);
    await _prefs!.remove(_expiryKey);
    await _prefs!.remove(_userIdKey);
    await _prefs!.remove(_userRoleKey);
    await _prefs!.remove(_userNameKey);
    await _prefs!.remove(_fullNameKey);
    await _prefs!.remove(_isApprovedKey);
    await _prefs!.remove(_canAddLogsKey);
    await _prefs!.remove(_disableNotificationsKey);
    await _prefs!.remove(_activeStatusKey);
    await _prefs!.remove(_contractorKey);
    await _prefs!.remove(_companyKey);
    await _prefs!.remove(_associationsKey);
    await _prefs!.remove(_accessCodeKey);
    await _prefs!.remove(_formattedAccessCodeKey);
    await _prefs!.remove(_changePasswordKey);
    await _prefs!.remove(_formattedCanAddLogsKey);
    await _prefs!.remove(_formattedDisableNotificationsKey);
    await _prefs!.remove(_formattedStatusKey);
    await _prefs!.remove(_userEmailKey);
    await _prefs!.remove(_userNameFieldKey);
    // Keep _isFirstTimeKey to remember it's not first time anymore
  }

  // Clear all data
  static Future<void> clearAll() async {
    await _ensureInitialized();
    await _prefs!.clear();
  }

  // ==================== USER DATA GETTERS AND SETTERS ====================

  // User Detail (Complete object)
  static Future<UserDetail?> getUserDetail() async {
    await _ensureInitialized();
    final userDetailJson = _prefs!.getString(_userDetailKey);
    if (userDetailJson != null) {
      try {
        return UserDetail.fromJson(json.decode(userDetailJson));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static Future<void> setUserDetail(UserDetail userDetail) async {
    await _ensureInitialized();
    await _prefs!.setString(_userDetailKey, json.encode(userDetail.toJson()));
  }

  // Auth Token
  static Future<String?> getToken() async {
    await _ensureInitialized();
    return _prefs!.getString(_tokenKey);
  }

  static Future<void> setToken(String token) async {
    await _ensureInitialized();
    await _prefs!.setString(_tokenKey, token);
  }

  // Email
  static Future<String?> getEmail() async {
    await _ensureInitialized();
    return _prefs!.getString(_emailKey);
  }

  static Future<void> setEmail(String email) async {
    await _ensureInitialized();
    await _prefs!.setString(_emailKey, email);
  }

  // Token Expiry
  static Future<String?> getTokenExpiry() async {
    await _ensureInitialized();
    return _prefs!.getString(_expiryKey);
  }

  static Future<void> setTokenExpiry(String expiry) async {
    await _ensureInitialized();
    await _prefs!.setString(_expiryKey, expiry);
  }

  // User ID
  static Future<int?> getUserId() async {
    await _ensureInitialized();
    return _prefs!.getInt(_userIdKey);
  }

  static Future<void> setUserId(int userId) async {
    await _ensureInitialized();
    await _prefs!.setInt(_userIdKey, userId);
  }

  // User Role
  static Future<String?> getUserRole() async {
    await _ensureInitialized();
    return _prefs!.getString(_userRoleKey);
  }

  static Future<void> setUserRole(String role) async {
    await _ensureInitialized();
    await _prefs!.setString(_userRoleKey, role);
  }

  // User Name
  static Future<String?> getUserName() async {
    await _ensureInitialized();
    return _prefs!.getString(_userNameKey);
  }

  static Future<void> setUserName(String userName) async {
    await _ensureInitialized();
    await _prefs!.setString(_userNameKey, userName);
  }

  // Full Name
  static Future<String?> getFullName() async {
    await _ensureInitialized();
    return _prefs!.getString(_fullNameKey);
  }

  static Future<void> setFullName(String fullName) async {
    await _ensureInitialized();
    await _prefs!.setString(_fullNameKey, fullName);
  }

  // Is Approved
  static Future<bool?> getIsApproved() async {
    await _ensureInitialized();
    return _prefs!.getBool(_isApprovedKey);
  }

  static Future<void> setIsApproved(bool isApproved) async {
    await _ensureInitialized();
    await _prefs!.setBool(_isApprovedKey, isApproved);
  }

  // Can Add Logs
  static Future<bool?> getCanAddLogs() async {
    await _ensureInitialized();
    return _prefs!.getBool(_canAddLogsKey);
  }

  static Future<void> setCanAddLogs(bool canAddLogs) async {
    await _ensureInitialized();
    await _prefs!.setBool(_canAddLogsKey, canAddLogs);
  }

  // Disable Notifications
  static Future<bool?> getDisableNotifications() async {
    await _ensureInitialized();
    return _prefs!.getBool(_disableNotificationsKey);
  }

  static Future<void> setDisableNotifications(bool disableNotifications) async {
    await _ensureInitialized();
    await _prefs!.setBool(_disableNotificationsKey, disableNotifications);
  }

  // Active Status
  static Future<String?> getActiveStatus() async {
    await _ensureInitialized();
    return _prefs!.getString(_activeStatusKey);
  }

  static Future<void> setActiveStatus(String activeStatus) async {
    await _ensureInitialized();
    await _prefs!.setString(_activeStatusKey, activeStatus);
  }

  // Contractor
  static Future<Contractor?> getContractor() async {
    await _ensureInitialized();
    final contractorJson = _prefs!.getString(_contractorKey);
    if (contractorJson != null) {
      try {
        return Contractor.fromJson(json.decode(contractorJson));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static Future<void> setContractor(Contractor contractor) async {
    await _ensureInitialized();
    await _prefs!.setString(_contractorKey, json.encode(contractor.toJson()));
  }

  // Company
  static Future<Company?> getCompany() async {
    await _ensureInitialized();
    final companyJson = _prefs!.getString(_companyKey);
    if (companyJson != null) {
      try {
        return Company.fromJson(json.decode(companyJson));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static Future<void> setCompany(Company company) async {
    await _ensureInitialized();
    await _prefs!.setString(_companyKey, json.encode(company.toJson()));
  }

  // Associations
  static Future<List<Association>?> getAssociations() async {
    await _ensureInitialized();
    final associationsJson = _prefs!.getString(_associationsKey);
    if (associationsJson != null) {
      try {
        final List<dynamic> associationsList = json.decode(associationsJson);
        return associationsList.map((item) => Association.fromJson(item)).toList();
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static Future<void> setAssociations(List<Association> associations) async {
    await _ensureInitialized();
    final associationsJson = json.encode(associations.map((item) => item.toJson()).toList());
    await _prefs!.setString(_associationsKey, associationsJson);
  }

  // Access Code
  static Future<String?> getAccessCode() async {
    await _ensureInitialized();
    return _prefs!.getString(_accessCodeKey);
  }

  static Future<void> setAccessCode(String accessCode) async {
    await _ensureInitialized();
    await _prefs!.setString(_accessCodeKey, accessCode);
  }

  // Formatted Access Code
  static Future<String?> getFormattedAccessCode() async {
    await _ensureInitialized();
    return _prefs!.getString(_formattedAccessCodeKey);
  }

  static Future<void> setFormattedAccessCode(String formattedAccessCode) async {
    await _ensureInitialized();
    await _prefs!.setString(_formattedAccessCodeKey, formattedAccessCode);
  }

  // Change Password
  static Future<bool?> getChangePassword() async {
    await _ensureInitialized();
    return _prefs!.getBool(_changePasswordKey);
  }

  static Future<void> setChangePassword(bool changePassword) async {
    await _ensureInitialized();
    await _prefs!.setBool(_changePasswordKey, changePassword);
  }

  // Formatted Can Add Logs
  static Future<String?> getFormattedCanAddLogs() async {
    await _ensureInitialized();
    return _prefs!.getString(_formattedCanAddLogsKey);
  }

  static Future<void> setFormattedCanAddLogs(String formattedCanAddLogs) async {
    await _ensureInitialized();
    await _prefs!.setString(_formattedCanAddLogsKey, formattedCanAddLogs);
  }

  // Formatted Disable Notifications
  static Future<String?> getFormattedDisableNotifications() async {
    await _ensureInitialized();
    return _prefs!.getString(_formattedDisableNotificationsKey);
  }

  static Future<void> setFormattedDisableNotifications(String formattedDisableNotifications) async {
    await _ensureInitialized();
    await _prefs!.setString(_formattedDisableNotificationsKey, formattedDisableNotifications);
  }

  // Formatted Status
  static Future<String?> getFormattedStatus() async {
    await _ensureInitialized();
    return _prefs!.getString(_formattedStatusKey);
  }

  static Future<void> setFormattedStatus(String formattedStatus) async {
    await _ensureInitialized();
    await _prefs!.setString(_formattedStatusKey, formattedStatus);
  }

  // User Email Field
  static Future<String?> getUserEmailField() async {
    await _ensureInitialized();
    return _prefs!.getString(_userEmailKey);
  }

  static Future<void> setUserEmailField(String userEmail) async {
    await _ensureInitialized();
    await _prefs!.setString(_userEmailKey, userEmail);
  }

  // User Name Field
  static Future<String?> getUserNameField() async {
    await _ensureInitialized();
    return _prefs!.getString(_userNameFieldKey);
  }

  static Future<void> setUserNameField(String userName) async {
    await _ensureInitialized();
    await _prefs!.setString(_userNameFieldKey, userName);
  }

  // ==================== BULK USER DATA SETTER ====================

  /// Save complete login data from API response
  static Future<void> saveLoginData(LoginData loginData) async {
    await _ensureInitialized();
    
    // Save main data
    if (loginData.token != null) await setToken(loginData.token!);
    if (loginData.email != null) await setEmail(loginData.email!);
    if (loginData.expiry != null) await setTokenExpiry(loginData.expiry!);
    
    // Save user detail data
    if (loginData.userDetail != null) {
      final userDetail = loginData.userDetail!;
      await setUserDetail(userDetail);
      
      // Basic user info
      if (userDetail.id != null) await setUserId(userDetail.id!);
      if (userDetail.role != null) await setUserRole(userDetail.role!);
      if (userDetail.name != null) await setUserName(userDetail.name!);
      if (userDetail.select2Text != null) await setFullName(userDetail.select2Text!);
      // if (userDetail.email != null) await setUserEmailField(userDetail.email!);
      if (userDetail.userName != null) await setUserNameField(userDetail.userName!);
      
      // User permissions and status
      if (userDetail.isApproved != null) await setIsApproved(userDetail.isApproved!);
      if (userDetail.canAddLogs != null) await setCanAddLogs(userDetail.canAddLogs!);
      if (userDetail.disableNotifications != null) await setDisableNotifications(userDetail.disableNotifications!);
      if (userDetail.changePassword != null) await setChangePassword(userDetail.changePassword!);
      
      // Access codes
      if (userDetail.accessCode != null) await setAccessCode(userDetail.accessCode!);
      if (userDetail.formattedAccessCode != null) await setFormattedAccessCode(userDetail.formattedAccessCode!);
      
      // Formatted strings
      if (userDetail.formattedCanAddLogs != null) await setFormattedCanAddLogs(userDetail.formattedCanAddLogs!);
      if (userDetail.formattedDisableNotifications != null) await setFormattedDisableNotifications(userDetail.formattedDisableNotifications!);
      if (userDetail.formattedStatus != null) await setFormattedStatus(userDetail.formattedStatus!);
      
      // Status
      if (userDetail.activeStatus != null) await setActiveStatus(userDetail.activeStatus!);
      
      // Related objects
      if (userDetail.contractor != null) await setContractor(userDetail.contractor!);
      if (userDetail.company != null) await setCompany(userDetail.company!);
      if (userDetail.associations != null) await setAssociations(userDetail.associations!);
    }
  }

  static Future<void> _ensureInitialized() async {
    if (_prefs == null) {
      await init();
    }
  }
}
