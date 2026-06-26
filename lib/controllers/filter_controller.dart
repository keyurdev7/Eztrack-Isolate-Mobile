import 'package:get/get.dart';
import '../api/models/response_models.dart';
import 'dropdown_controller.dart';

class FilterController extends GetxController {
  // Filter values (stored as names for display)
  final RxString keyword = ''.obs;
  final Rxn<String> selectedSupplier = Rxn<String>();
  final Rxn<String> selectedManufacturer = Rxn<String>();
  final Rxn<String> selectedEquipment = Rxn<String>();
  final Rxn<String> selectedCompany = Rxn<String>();
  final Rxn<String> selectedOwner = Rxn<String>();
  final Rxn<String> selectedCondition = Rxn<String>();
  final Rxn<String> selectedStatus = Rxn<String>();
  final Rxn<int> selectedStatusIntData = Rxn<int>();

  // Store owner ID when owner is selected (needed for API)
  final Rxn<int> selectedOwnerId = Rxn<int>();

  // Check if any filter is applied
  bool get hasActiveFilters {
    return keyword.value.isNotEmpty ||
        (selectedSupplier.value != null &&
            selectedSupplier.value!.isNotEmpty) ||
        (selectedManufacturer.value != null &&
            selectedManufacturer.value!.isNotEmpty) ||
        (selectedEquipment.value != null &&
            selectedEquipment.value!.isNotEmpty) ||
        (selectedCompany.value != null && selectedCompany.value!.isNotEmpty) ||
        (selectedOwner.value != null && selectedOwner.value!.isNotEmpty) ||
        (selectedCondition.value != null &&
            selectedCondition.value!.isNotEmpty) ||
        (selectedStatus.value != null && selectedStatus.value!.isNotEmpty) ||
        (selectedStatusIntData.value != null);
  }

  // Clear all filters
  void clearFilters() {
    keyword.value = '';
    selectedSupplier.value = null;
    selectedManufacturer.value = null;
    selectedEquipment.value = null;
    selectedCompany.value = null;
    selectedOwner.value = null;
    selectedOwnerId.value = null;
    selectedCondition.value = null;
    selectedStatus.value = null;
    selectedStatusIntData.value = null;
  }

  void statusData(String? value) {
    if (value == 'Active') {
      selectedStatusIntData.value = 0;
    } else if (value == 'Inactive') {
      selectedStatusIntData.value = 1;
    } else if (value == 'All') {
      selectedStatusIntData.value = null;
    } else {
      selectedStatusIntData.value = null;
    }
  }

  // Apply filters (called when Search button is pressed)
  void applyFilters() {
    // Filters are already stored in reactive variables
    // This method can be used to trigger any additional logic
    update();
  }

  // Get filter values as map for API calls
  Map<String, dynamic> getFilterMap() {
    return {
      'keyword': keyword.value,
      'supplier': selectedSupplier.value,
      'manufacturer': selectedManufacturer.value,
      'equipment': selectedEquipment.value,
      'company': selectedCompany.value,
      'owner': selectedOwner.value,
      'condition': selectedCondition.value,
      'status': selectedStatusIntData.value,
    };
  }

  // Build TrackingFilterParams from current filter values
  TrackingFilterParams? buildFilterParams() {
    if (!hasActiveFilters) {
      return null;
    }

    final dropdownController = Get.find<DropdownController>();

    // Convert names to IDs
    int? supplierId;
    if (selectedSupplier.value != null && selectedSupplier.value!.isNotEmpty) {
      final supplier = dropdownController.suppliers.firstWhereOrNull(
        (s) => s.name == selectedSupplier.value,
      );
      supplierId = supplier?.id;
    }

    int? manufacturerId;
    if (selectedManufacturer.value != null &&
        selectedManufacturer.value!.isNotEmpty) {
      final manufacturer = dropdownController.manufacturers.firstWhereOrNull(
        (m) => m.name == selectedManufacturer.value,
      );
      manufacturerId = manufacturer?.id;
    }

    int? modelId;
    if (selectedEquipment.value != null &&
        selectedEquipment.value!.isNotEmpty) {
      final equipment = dropdownController.equipment.firstWhereOrNull(
        (e) => e.name == selectedEquipment.value,
      );
      modelId = equipment?.id;
    }

    int? companyId;
    if (selectedCompany.value != null && selectedCompany.value!.isNotEmpty) {
      final company = dropdownController.companies.firstWhereOrNull(
        (c) => c.text == selectedCompany.value,
      );
      companyId = company != null ? int.tryParse(company.id) : null;
    }

    int? ownerId = selectedOwnerId.value;

    int? conditionId;
    if (selectedCondition.value != null &&
        selectedCondition.value!.isNotEmpty) {
      final condition = dropdownController.conditions.firstWhereOrNull(
        (c) => c.name == selectedCondition.value,
      );
      conditionId = condition?.id;
    }

    // Use the status int data that was set by statusData() method
    // "Active" = 0, "Inactive" = 1, "All" = null
    int? status = selectedStatusIntData.value;

    return TrackingFilterParams(
      supplierId: supplierId,
      manufacturerId: manufacturerId,
      modelId: modelId,
      companyId: companyId,
      ownerId: ownerId,
      conditionId: conditionId,
      status: status,
      search: keyword.value.isNotEmpty ? keyword.value : null,
      disablePagination: true, // Set to true to get all results
    );
  }
}
