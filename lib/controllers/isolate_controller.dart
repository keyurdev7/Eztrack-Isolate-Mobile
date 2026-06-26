import 'package:get/get.dart';

class IsolateProject {
  final String name;
  final String unitNumber;
  final String year;
  final String department;

  IsolateProject({
    required this.name,
    required this.unitNumber,
    required this.year,
    required this.department,
  });
}

class TWRItem {
  final String id;
  final String equipClass;
  final String serviceType;
  final String twr;
  final String equipNo;
  final String pid;

  TWRItem({
    required this.id,
    required this.equipClass,
    required this.serviceType,
    required this.twr,
    required this.equipNo,
    required this.pid,
  });
}

class IsolationItem {
  final String tagNo;
  final String location;
  final String twr;
  final String status; // Entered, Confirmed, Installed, Removed
  final String type; // Isolation Valve, Blind, Piping, etc.

  IsolationItem({
    required this.tagNo,
    required this.location,
    required this.twr,
    required this.status,
    required this.type,
  });
}

class BlindItem {
  final String tagNo;
  final String twr;
  final String flangeSize;
  final String flangeType;
  final String rating;
  final String status; // Entered, Confirmed, Installed, Removed

  BlindItem({
    required this.tagNo,
    required this.twr,
    required this.flangeSize,
    required this.flangeType,
    required this.rating,
    required this.status,
  });
}

class UserItem {
  final String fullName;
  final String email;
  final String accountType; // Administrator, User
  final String status; // Active, Inactive

  UserItem({
    required this.fullName,
    required this.email,
    required this.accountType,
    required this.status,
  });
}

class IsolateController extends GetxController {
  // Active Project Selection
  final Rx<IsolateProject?> selectedProject = Rx<IsolateProject?>(null);

  // Lists of Turnaround Projects
  final RxList<IsolateProject> projects = <IsolateProject>[
    IsolateProject(name: "22 Coker TA27", unitNumber: "22", year: "2027", department: "Turnaround"),
    IsolateProject(name: "01 Crude TA27", unitNumber: "01", year: "2027", department: "Turnaround"),
    IsolateProject(name: "06 Hydro TA26", unitNumber: "06", year: "2026", department: "Maintenance"),
  ].obs;

  // Mock list of TWR Items
  final RxList<TWRItem> twrItems = <TWRItem>[
    TWRItem(id: "1", equipClass: "Piping", serviceType: "HGO Pumparound", twr: "T-01P-001", equipNo: "22E-3", pid: "22A0102D01"),
    TWRItem(id: "2", equipClass: "Piping", serviceType: "Feed Exch.", twr: "T-01P-029", equipNo: "22E-3", pid: "22A0102D01"),
    TWRItem(id: "3", equipClass: "Valves", serviceType: "Isolation", twr: "T-01P-030", equipNo: "1G-54A", pid: "01A0105A11"),
    TWRItem(id: "4", equipClass: "Piping", serviceType: "Bypass", twr: "T-01P-031", equipNo: "1G-54A", pid: "01A0105A11"),
    TWRItem(id: "5", equipClass: "Vessels", serviceType: "Column", twr: "T-02V-012", equipNo: "22C-1", pid: "22A0102D02"),
  ].obs;

  // Mock list of Isolation Tags
  final RxList<IsolationItem> isolationItems = <IsolationItem>[
    IsolationItem(tagNo: "#226", location: "22E-3 Inlet", twr: "T-01P-001", status: "Installed", type: "Isolation Valve"),
    IsolationItem(tagNo: "#225", location: "22E-3 Outlet", twr: "T-01P-029", status: "Confirmed", type: "Isolation Valve"),
    IsolationItem(tagNo: "#7", location: "1G-54A Suction", twr: "T-01P-030", status: "Installed", type: "Isolation Valve"),
    IsolationItem(tagNo: "#122", location: "1G-54A Discharge", twr: "T-01P-031", status: "Removed", type: "Isolation Valve"),
    IsolationItem(tagNo: "#54", location: "22C-1 Top Reflux", twr: "T-02V-012", status: "Entered", type: "Isolation Valve"),
  ].obs;

  // Mock list of Blind Tags
  final RxList<BlindItem> blindItems = <BlindItem>[
    BlindItem(tagNo: "B-226-1", twr: "T-01P-001", flangeSize: "2\"", flangeType: "Flange", rating: "150#", status: "Installed"),
    BlindItem(tagNo: "B-226-2", twr: "T-01P-001", flangeSize: "2\"", flangeType: "Flange", rating: "150#", status: "Installed"),
    BlindItem(tagNo: "B-225-1", twr: "T-01P-029", flangeSize: "4\"", flangeType: "Flange", rating: "300#", status: "Confirmed"),
    BlindItem(tagNo: "B-007-1", twr: "T-01P-030", flangeSize: "6\"", flangeType: "Flange", rating: "300#", status: "Entered"),
    BlindItem(tagNo: "B-122-1", twr: "T-01P-031", flangeSize: "3\"", flangeType: "Flange", rating: "150#", status: "Removed"),
  ].obs;

  // Mock Settings options
  final RxList<String> unitNumbers = <String>["01", "06", "22"].obs;
  final RxList<String> years = <String>["2026", "2027"].obs;
  final RxList<String> departments = <String>["Turnaround", "Maintenance", "Operations"].obs;
  final RxList<String> blindTypes = <String>["Slip", "Spectacle", "Blind Flange"].obs;
  final RxList<String> flangeSizes = <String>["1\"", "2\"", "3\"", "4\"", "6\"", "8\"", "12\""].obs;
  final RxList<String> flangeTypes = <String>["Raised Face", "Flat Face", "Ring Joint"].obs;
  final RxList<String> flangeRatings = <String>["150#", "300#", "600#", "900#"].obs;
  final RxList<String> loopNumbers = <String>["L-101", "L-102", "L-220"].obs;
  final RxList<String> scaffoldHeights = <String>["6 ft", "12 ft", "18 ft", "24 ft"].obs;
  final RxList<String> scaffoldLF = <String>["50 LF", "100 LF", "150 LF"].obs;
  final RxList<String> equipClasses = <String>["Piping", "Valves", "Vessels", "Exchangers", "Pumps"].obs;

  // Mock list of Users
  final RxList<UserItem> users = <UserItem>[
    UserItem(fullName: "System Administrator", email: "admin@local", accountType: "Administrator", status: "Active"),
    UserItem(fullName: "Claudio Pardo", email: "cpardo@local", accountType: "Administrator", status: "Active"),
    UserItem(fullName: "Duane Blackman", email: "dblackman@local", accountType: "Administrator", status: "Active"),
    UserItem(fullName: "Federico Kindweiler", email: "fkindweiler@local", accountType: "User", status: "Active"),
    UserItem(fullName: "General User", email: "user@local", accountType: "User", status: "Active"),
    UserItem(fullName: "Jose De Los Santos", email: "jdelossantos@local", accountType: "User", status: "Active"),
    UserItem(fullName: "Shane Hartman", email: "shartman@local", accountType: "User", status: "Inactive"),
  ].obs;

  // Helper getters for Dashboard Stats
  int get totalIsolations => isolationItems.length;
  int get enteredIsolations => isolationItems.where((i) => i.status == "Entered").length;
  int get confirmedIsolations => isolationItems.where((i) => i.status == "Confirmed").length;
  int get installedIsolations => isolationItems.where((i) => i.status == "Installed").length;
  int get removedIsolations => isolationItems.where((i) => i.status == "Removed").length;

  int get totalBlinds => blindItems.length;
  int get installedBlinds => blindItems.where((b) => b.status == "Installed").length;
  int get enteredBlinds => blindItems.where((b) => b.status == "Entered").length;
  int get confirmedBlinds => blindItems.where((b) => b.status == "Confirmed").length;
  int get removedBlinds => blindItems.where((b) => b.status == "Removed").length;

  // Methods to manipulate TWR Items
  void addTWR(TWRItem item) {
    twrItems.add(item);
  }

  void updateTWR(TWRItem updatedItem) {
    final index = twrItems.indexWhere((i) => i.id == updatedItem.id);
    if (index != -1) {
      twrItems[index] = updatedItem;
    }
  }

  // Methods to manipulate Isolation/Blind Items
  void updateIsolationStatus(String tagNo, String newStatus) {
    final index = isolationItems.indexWhere((i) => i.tagNo == tagNo);
    if (index != -1) {
      final item = isolationItems[index];
      isolationItems[index] = IsolationItem(
        tagNo: item.tagNo,
        location: item.location,
        twr: item.twr,
        status: newStatus,
        type: item.type,
      );
    }
  }

  void updateBlindStatus(String tagNo, String newStatus) {
    final index = blindItems.indexWhere((b) => b.tagNo == tagNo);
    if (index != -1) {
      final item = blindItems[index];
      blindItems[index] = BlindItem(
        tagNo: item.tagNo,
        twr: item.twr,
        flangeSize: item.flangeSize,
        flangeType: item.flangeType,
        rating: item.rating,
        status: newStatus,
      );
    }
  }

  // Methods to manipulate settings configurations
  void addSettingItem(String category, String value) {
    switch (category.toLowerCase()) {
      case 'unit number':
      case 'unit numbers':
        if (!unitNumbers.contains(value)) unitNumbers.add(value);
        break;
      case 'year':
      case 'years':
        if (!years.contains(value)) years.add(value);
        break;
      case 'department':
      case 'departments':
        if (!departments.contains(value)) departments.add(value);
        break;
      case 'blind type':
        if (!blindTypes.contains(value)) blindTypes.add(value);
        break;
      case 'size':
        if (!flangeSizes.contains(value)) flangeSizes.add(value);
        break;
      case 'flange type':
        if (!flangeTypes.contains(value)) flangeTypes.add(value);
        break;
      case 'rating':
        if (!flangeRatings.contains(value)) flangeRatings.add(value);
        break;
      case 'loop #':
        if (!loopNumbers.contains(value)) loopNumbers.add(value);
        break;
      case 'scaffold height':
        if (!scaffoldHeights.contains(value)) scaffoldHeights.add(value);
        break;
    }
  }

  void removeSettingItem(String category, String value) {
    switch (category.toLowerCase()) {
      case 'unit number':
      case 'unit numbers':
        unitNumbers.remove(value);
        break;
      case 'year':
      case 'years':
        years.remove(value);
        break;
      case 'department':
      case 'departments':
        departments.remove(value);
        break;
      case 'blind type':
        blindTypes.remove(value);
        break;
      case 'size':
        flangeSizes.remove(value);
        break;
      case 'flange type':
        flangeTypes.remove(value);
        break;
      case 'rating':
        flangeRatings.remove(value);
        break;
      case 'loop #':
        loopNumbers.remove(value);
        break;
      case 'scaffold height':
        scaffoldHeights.remove(value);
        break;
    }
  }

  // User methods
  void createUser(UserItem user) {
    users.add(user);
  }

  void toggleUserStatus(String email) {
    final index = users.indexWhere((u) => u.email == email);
    if (index != -1) {
      final user = users[index];
      users[index] = UserItem(
        fullName: user.fullName,
        email: user.email,
        accountType: user.accountType,
        status: user.status == "Active" ? "Inactive" : "Active",
      );
    }
  }
}
