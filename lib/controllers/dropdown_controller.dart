import 'package:get/get.dart';
import 'package:eztrack_rental/api/api_service.dart';
import 'package:eztrack_rental/api/models/response_models.dart';

class DropdownController extends GetxController {
  final ApiService _apiService = ApiService();

  // Dropdown data
  final RxList<DropdownItem> suppliers = <DropdownItem>[].obs;
  final RxList<DropdownItem> manufacturers = <DropdownItem>[].obs;
  final RxList<DropdownItem> equipment = <DropdownItem>[].obs;
  final RxList<DropdownItem> equipmentDescriptions = <DropdownItem>[].obs;
  final RxList<DropdownItem> conditions = <DropdownItem>[].obs;
  final RxList<DropdownItem> tagMasters = <DropdownItem>[].obs;
  final RxList<Select2Item> companies = <Select2Item>[].obs;

  // Loading states
  final RxBool isLoadingSuppliers = false.obs;
  final RxBool isLoadingManufacturers = false.obs;
  final RxBool isLoadingEquipment = false.obs;
  final RxBool isLoadingEquipmentDescriptions = false.obs;
  final RxBool isLoadingConditions = false.obs;
  final RxBool isLoadingTagMasters = false.obs;
  final RxBool isLoadingCompanies = false.obs;

  // Error states
  final RxString supplierError = ''.obs;
  final RxString manufacturerError = ''.obs;
  final RxString equipmentError = ''.obs;
  final RxString equipmentDescriptionError = ''.obs;
  final RxString conditionError = ''.obs;
  final RxString tagMasterError = ''.obs;
  final RxString companyError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Load all dropdown data when controller is initialized
    loadAllDropdownData();
  }

  /// Load all dropdown data
  Future<void> loadAllDropdownData() async {
    // Load critical dropdowns first (suppliers, equipment, equipment descriptions, companies)
    await Future.wait([
      loadSuppliers(),
      loadEquipment(),
      loadEquipmentDescriptions(),
      loadCompanies(),
    ]);
    
    // Load manufacturers and conditions separately with timeout - don't block if they fail
    loadManufacturers().timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        manufacturerError.value = 'Manufacturers loading timed out';
        isLoadingManufacturers.value = false;
        manufacturers.value = [];
      },
    ).catchError((e) {
      manufacturerError.value = 'Error loading manufacturers: $e';
      isLoadingManufacturers.value = false;
      manufacturers.value = [];
    });
    
    loadConditions().timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        conditionError.value = 'Conditions loading timed out';
        isLoadingConditions.value = false;
        conditions.value = [];
      },
    ).catchError((e) {
      conditionError.value = 'Error loading conditions: $e';
      isLoadingConditions.value = false;
      conditions.value = [];
    });
    
    // Load tag masters separately - don't block if it fails or times out
    loadTagMasters().timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        tagMasterError.value = 'Tag masters loading timed out';
        isLoadingTagMasters.value = false;
        tagMasters.value = []; // Use empty list on timeout
      },
    ).catchError((e) {
      tagMasterError.value = 'Error loading tag masters: $e';
      isLoadingTagMasters.value = false;
      tagMasters.value = []; // Use empty list on error
    });
  }

  /// Load suppliers
  Future<void> loadSuppliers() async {
    isLoadingSuppliers.value = true;
    supplierError.value = '';
    try {
      final response = await _apiService.getSuppliers();
      if (response.success && response.data != null) {
        suppliers.value = response.data!;
      } else {
        supplierError.value = response.error ?? 'Failed to load suppliers';
      }
    } catch (e) {
      supplierError.value = 'Error loading suppliers: $e';
    } finally {
      isLoadingSuppliers.value = false;
    }
  }

  /// Load manufacturers
  Future<void> loadManufacturers() async {
    isLoadingManufacturers.value = true;
    manufacturerError.value = '';
    try {
      final response = await _apiService.getManufacturers();
      if (response.success && response.data != null) {
        manufacturers.value = response.data!;
        manufacturerError.value = ''; // Clear error on success
      } else {
        manufacturerError.value = response.error ?? 'Failed to load manufacturers';
        // Don't block the app - use empty list if failed
        manufacturers.value = [];
      }
    } catch (e) {
      manufacturerError.value = 'Error loading manufacturers: $e';
      // Don't block the app - use empty list if failed
      manufacturers.value = [];
    } finally {
      isLoadingManufacturers.value = false;
    }
  }

  /// Load equipment
  Future<void> loadEquipment() async {
    isLoadingEquipment.value = true;
    equipmentError.value = '';
    try {
      final response = await _apiService.getEquipment();
      if (response.success && response.data != null) {
        equipment.value = response.data!;
      } else {
        equipmentError.value = response.error ?? 'Failed to load equipment';
      }
    } catch (e) {
      equipmentError.value = 'Error loading equipment: $e';
    } finally {
      isLoadingEquipment.value = false;
    }
  }

  /// Load equipment descriptions
  Future<void> loadEquipmentDescriptions() async {
    isLoadingEquipmentDescriptions.value = true;
    equipmentDescriptionError.value = '';
    try {
      final response = await _apiService.getEquipmentDescriptions();
      if (response.success && response.data != null) {
        equipmentDescriptions.value = response.data!;
      } else {
        equipmentDescriptionError.value = response.error ?? 'Failed to load equipment descriptions';
      }
    } catch (e) {
      equipmentDescriptionError.value = 'Error loading equipment descriptions: $e';
    } finally {
      isLoadingEquipmentDescriptions.value = false;
    }
  }

  /// Load conditions
  Future<void> loadConditions() async {
    isLoadingConditions.value = true;
    conditionError.value = '';
    try {
      final response = await _apiService.getConditions();
      if (response.success && response.data != null) {
        conditions.value = response.data!;
        conditionError.value = ''; // Clear error on success
        print('✅ Loaded ${conditions.length} conditions');
      } else {
        conditionError.value = response.error ?? 'Failed to load conditions';
        print('❌ Failed to load conditions: ${response.error}');
        // Don't block the app - use empty list if failed
        conditions.value = [];
      }
    } catch (e) {
      conditionError.value = 'Error loading conditions: $e';
      print('❌ Exception loading conditions: $e');
      // Don't block the app - use empty list if failed
      conditions.value = [];
    } finally {
      isLoadingConditions.value = false;
    }
  }

  /// Load tag masters (Velavu Tag IDs)
  Future<void> loadTagMasters() async {
    isLoadingTagMasters.value = true;
    tagMasterError.value = '';
    try {
      final response = await _apiService.getTagMasters();
      if (response.success && response.data != null) {
        tagMasters.value = response.data!;
        tagMasterError.value = ''; // Clear error on success
      } else {
        tagMasterError.value = response.error ?? 'Failed to load tag masters';
        // Don't block the app - use empty list if failed
        tagMasters.value = [];
      }
    } catch (e) {
      tagMasterError.value = 'Error loading tag masters: $e';
      // Don't block the app - use empty list if failed
      tagMasters.value = [];
    } finally {
      isLoadingTagMasters.value = false;
    }
  }

  /// Load companies
  Future<void> loadCompanies() async {
    isLoadingCompanies.value = true;
    companyError.value = '';
    try {
      final response = await _apiService.getCompanyInformation();
      if (response.success && response.data != null) {
        companies.value = response.data!.results;
      } else {
        companyError.value = response.error ?? 'Failed to load companies';
      }
    } catch (e) {
      companyError.value = 'Error loading companies: $e';
    } finally {
      isLoadingCompanies.value = false;
    }
  }

  /// Get company contacts
  Future<List<Select2Item>> getCompanyContacts(int companyId) async {
    try {
      final response = await _apiService.getCompanyContacts(companyId);
      if (response.success && response.data != null) {
        return response.data!.results;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Get supplier names list (removes duplicates)
  List<String> getSupplierNames() {
    final names = suppliers.map((s) => s.name).toList();
    return names.toSet().toList();
  }

  /// Get manufacturer names list (removes duplicates)
  List<String> getManufacturerNames() {
    final names = manufacturers.map((m) => m.name).toList();
    return names.toSet().toList();
  }

  /// Get equipment names list (removes duplicates)
  List<String> getEquipmentNames() {
    final names = equipment.map((e) => e.name).toList();
    // Remove duplicates while preserving order
    return names.toSet().toList();
  }

  /// Get equipment description names list (removes duplicates)
  List<String> getEquipmentDescriptionNames() {
    final names = equipmentDescriptions.map((e) => e.name).toList();
    return names.toSet().toList();
  }

  /// Get condition names list (removes duplicates)
  List<String> getConditionNames() {
    final names = conditions.map((c) => c.name).toList();
    return names.toSet().toList();
  }

  /// Get company names list
  List<String> getCompanyNames() {
    return companies.map((c) => c.text).toList();
  }

  /// Get tag master names list (Velavu Tag IDs)
  List<String> getTagMasterNames() {
    return tagMasters.map((t) => t.name).toList();
  }
}

