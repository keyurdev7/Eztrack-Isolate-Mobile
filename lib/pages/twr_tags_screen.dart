import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eztrack_rental/theme/color.dart';
import 'package:eztrack_rental/controllers/isolate_controller.dart';
import 'package:eztrack_rental/widgets/form_components.dart';
import '../widgets/common_app_bar.dart';

class TwrTagsScreen extends StatefulWidget {
  const TwrTagsScreen({Key? key}) : super(key: key);

  @override
  _TwrTagsScreenState createState() => _TwrTagsScreenState();
}

class _TwrTagsScreenState extends State<TwrTagsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _assetsTabController;
  final IsolateController _controller = Get.find<IsolateController>();

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // Dropdown States
  String _selectedDwg = "22A0102D01.DWG (default) · Markups";
  String _selectedEquipClassFilter = "All";
  String _selectedStatusFilter = "All";
  String _selectedTypeFilter = "All";
  String _selectedLoopFilter = "All";
  String _selectedPositionFilter = "All";
  String _selectedScaffoldFilter = "All";
  String _selectedHeightFilter = "All";
  String _selectedLiveLineFilter = "All";
  String _selectedFaFilter = "All";
  String _selectedHydroFilter = "All";

  // Diagram Hotspot selection state
  String? _selectedHotspotTag;

  // CSV Import state
  bool _updateExistingTwr = false;
  String _selectedFileName = "no file selected";

  final List<String> _dwgFiles = [
    "22A0102D01.DWG (default) · Markups",
    "22A0102D02.DWG · Markups",
    "01A0105A11.DWG · Markups",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _assetsTabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      setState(() {
        _searchController.clear();
        _searchQuery = "";
        _selectedHotspotTag = null;
      });
    });

    _assetsTabController.addListener(() {
      setState(() {
        _searchController.clear();
        _searchQuery = "";
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _assetsTabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _nextDwg() {
    int index = _dwgFiles.indexOf(_selectedDwg);
    if (index < _dwgFiles.length - 1) {
      setState(() {
        _selectedDwg = _dwgFiles[index + 1];
        _selectedHotspotTag = null;
      });
    }
  }

  void _prevDwg() {
    int index = _dwgFiles.indexOf(_selectedDwg);
    if (index > 0) {
      setState(() {
        _selectedDwg = _dwgFiles[index - 1];
        _selectedHotspotTag = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width >= 800;
    final activeProject = _controller.selectedProject.value;

    return Scaffold(
      backgroundColor: isWide ? const Color(0xFFF4F6F9) : lightBackground,
      appBar: isWide
          ? null
          : CommonAppBar(
              userName: "",
              greeting: activeProject?.name ?? "Turnaround Project",
            ),
      body: SafeArea(
        child: Column(
          children: [
            // Wide Screen Top Header Bar (matches screenshots)
            if (isWide) _buildWideHeader(context, activeProject),

            // Tab bar
            Container(
              color: Colors.white,
              width: double.infinity,
              alignment: isWide ? Alignment.centerLeft : Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: isWide ? 40 : 0),
              child: TabBar(
                controller: _tabController,
                indicatorColor: primary,
                labelColor: primary,
                unselectedLabelColor: lightTextColor,
                isScrollable: false,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'BricolageGrotesque',
                ),
                tabs: const [
                  // Tab(
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Icon(Icons.map_outlined, size: 18),
                  //       SizedBox(width: 8),
                  //       Text("Diagram"),
                  //     ],
                  //   ),
                  // ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.file_copy_outlined, size: 18),
                        SizedBox(width: 8),
                        Text("TWR"),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.layers_outlined, size: 18),
                        SizedBox(width: 8),
                        Text("Assets"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tab contents
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics:
                    const NeverScrollableScrollPhysics(), // Prevent horizontal swipe to preserve layout actions
                children: [
                  // _buildDiagramTab(isWide),
                  _buildTwrTab(isWide),
                  _buildAssetsTab(isWide),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // WIDE SCREEN HEADER
  // ===========================================================================
  Widget _buildWideHeader(BuildContext context, IsolateProject? project) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Breadcrumbs
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.layers, color: primary, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Dashboard',
                style: TextStyle(
                  color: Color(0xFF8C9BA5),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'BricolageGrotesque',
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF8C9BA5),
                size: 16,
              ),
              const SizedBox(width: 8),
              const Text(
                'Projects',
                style: TextStyle(
                  color: Color(0xFF8C9BA5),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'BricolageGrotesque',
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF8C9BA5),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                project?.name ?? "No Project Selected",
                style: const TextStyle(
                  color: Color(0xFF0F2C59),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BricolageGrotesque',
                ),
              ),
            ],
          ),

          // DWG Selector & Tools
          Row(
            children: [
              // TWR only badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'TWR only',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8C9BA5),
                    fontFamily: 'BricolageGrotesque',
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Equip Class label / dropdown placeholder
              const Text(
                'Equip class',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8C9BA5),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BricolageGrotesque',
                ),
              ),
              const Icon(
                Icons.arrow_drop_down,
                color: Color(0xFF8C9BA5),
                size: 18,
              ),
              const SizedBox(width: 16),

              // DWG Selector with Left / Right chevrons
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.chevron_left,
                  color: Color(0xFF5A6A85),
                  size: 20,
                ),
                onPressed: _prevDwg,
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _selectedDwg,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F2C59),
                        fontFamily: 'BricolageGrotesque',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF0F2C59),
                      size: 16,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF5A6A85),
                  size: 20,
                ),
                onPressed: _nextDwg,
              ),
              const SizedBox(width: 16),

              // Toolbar action icons
              const Icon(
                Icons.edit_outlined,
                color: Color(0xFF5A6A85),
                size: 20,
              ),
              const SizedBox(width: 12),
              const Icon(Icons.list, color: Color(0xFF5A6A85), size: 20),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 1. DIAGRAM TAB
  // ===========================================================================
  Widget _buildDiagramTab(bool isWide) {
    if (!isWide) {
      // Mobile View: list of drawings that can be selected to open fullscreen
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Drawing Sheets',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: mainTextColor,
                fontFamily: 'BricolageGrotesque',
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tap a drawing to open the interactive blueprint markup viewer.',
              style: TextStyle(
                fontSize: 12,
                color: lightTextColor,
                fontFamily: 'BricolageGrotesque',
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _dwgFiles.length,
                itemBuilder: (context, idx) {
                  final filename = _dwgFiles[idx].split(' ')[0];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    color: Colors.white,
                    child: ListTile(
                      leading: const Icon(Icons.picture_as_pdf, color: primary),
                      title: Text(
                        filename,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'BricolageGrotesque',
                        ),
                      ),
                      subtitle: const Text(
                        'Interactive isolation markups available',
                        style: TextStyle(fontSize: 11),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: primary,
                      ),
                      onTap: () {
                        // Open Blueprint fullscreen
                        Get.to(
                          () => Scaffold(
                            backgroundColor: const Color(0xFF0F172A),
                            appBar: AppBar(
                              backgroundColor: const Color(0xFF1E293B),
                              iconTheme: const IconThemeData(
                                color: Colors.white,
                              ),
                              title: Text(
                                filename,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            body: _buildDrawingViewer(filename),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    // Wide Layout View
    final drawingFilename = _selectedDwg.split(' ')[0];
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF020617), // Dark blueprints background
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  _buildDrawingViewer(drawingFilename),
                  if (_selectedHotspotTag != null)
                    Positioned(
                      left: 24,
                      right: 24,
                      bottom: 24,
                      child: _buildDetailsPanel(),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              '© 2026 - EZTRAK Software, LLC. All Rights Reserved.',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF8C9BA5),
                fontFamily: 'BricolageGrotesque',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawingViewer(String filename) {
    return InteractiveViewer(
      maxScale: 5.0,
      minScale: 0.5,
      boundaryMargin: const EdgeInsets.all(100),
      child: Center(
        child: AspectRatio(
          aspectRatio: 1.5,
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Stack(
              children: [
                CustomPaint(
                  painter: DynamicBlueprintPainter(
                    filename: filename,
                    selectedTag: _selectedHotspotTag,
                  ),
                  child: Container(),
                ),
                // Render hotspots dynamically depending on active file selection
                if (filename.contains("22A0102D01")) ...[
                  Positioned(left: 120, top: 140, child: _buildHotspot('#226')),
                  Positioned(left: 280, top: 140, child: _buildHotspot('#225')),
                  Positioned(
                    left: 180,
                    top: 220,
                    child: _buildHotspot('B-226-1'),
                  ),
                  Positioned(left: 360, top: 80, child: _buildHotspot('#7')),
                ] else if (filename.contains("22A0102D02")) ...[
                  Positioned(left: 150, top: 110, child: _buildHotspot('#54')),
                  Positioned(
                    left: 260,
                    top: 190,
                    child: _buildHotspot('B-007-1'),
                  ),
                ] else if (filename.contains("01A0105A11")) ...[
                  Positioned(left: 200, top: 160, child: _buildHotspot('#122')),
                  Positioned(
                    left: 310,
                    top: 210,
                    child: _buildHotspot('B-122-1'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHotspot(String tag) {
    final bool isSelected = _selectedHotspotTag == tag;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedHotspotTag = isSelected ? null : tag;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? primary
              : const Color(0xFF1E293B).withOpacity(0.8),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? Colors.white : primary,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.3),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Text(
          tag,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsPanel() {
    final isBlind = _selectedHotspotTag!.startsWith('B-');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155), width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Markup Details: $_selectedHotspotTag',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'BricolageGrotesque',
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close, color: Colors.white60, size: 18),
                onPressed: () {
                  setState(() {
                    _selectedHotspotTag = null;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildPanelDetail('Equip No.', '22E-3'),
              const SizedBox(width: 20),
              _buildPanelDetail(
                'Status',
                isBlind ? 'Installed (Blind)' : 'Installed/Confirmed (Valve)',
              ),
              const SizedBox(width: 20),
              _buildPanelDetail('TWR Ref.', 'T-01P-001'),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isBlind
                ? 'This blind flanged gasket is installed on the inlet line flange of HGO Pumparound to isolate Exchanger 22E-3.'
                : 'Double-block-and-bleed valve shut and locked out to isolate Coker turnaround works on Exchanger 22E-3.',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white70,
              height: 1.4,
              fontFamily: 'BricolageGrotesque',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanelDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white60,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // 2. TWR TAB
  // ===========================================================================
  Widget _buildTwrTab(bool isWide) {
    return Obx(() {
      // Filter list of items based on Search query & Equip Class Filter dropdown
      final items = _controller.twrItems.where((i) {
        final matchesSearch =
            i.twr.toLowerCase().contains(_searchQuery) ||
            i.equipNo.toLowerCase().contains(_searchQuery) ||
            i.equipClass.toLowerCase().contains(_searchQuery) ||
            i.serviceType.toLowerCase().contains(_searchQuery);
        final matchesFilter =
            _selectedEquipClassFilter == "All" ||
            i.equipClass.toLowerCase() ==
                _selectedEquipClassFilter.toLowerCase();
        return matchesSearch && matchesFilter;
      }).toList();

      if (!isWide) {
        // Mobile layout: card list
        return Scaffold(
          backgroundColor: lightBackground,
          body: Column(
            children: [
              _buildSearchField('Search TWR, Equipment number...'),
              Expanded(
                child: items.isEmpty
                    ? _buildEmptyState('No TWR items found.')
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, idx) =>
                            _buildMobileTwrCard(items[idx]),
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: primary,
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _showAddTWRDialog(context, null),
          ),
        );
      }

      // Wide desktop layout matching screenshot
      return Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                ),
                padding: const EdgeInsets.all(32),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Heading and upper buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'TWR',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F2C59),
                              fontFamily: 'BricolageGrotesque',
                            ),
                          ),
                          Row(
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => _showImportCSVDialog(context),
                                icon: const Icon(
                                  Icons.file_upload_outlined,
                                  size: 16,
                                  color: Color(0xFF5A6A85),
                                ),
                                label: const Text(
                                  'Import CSV',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF5A6A85),
                                    fontFamily: 'BricolageGrotesque',
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.grey.shade300),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: () =>
                                    _showAddTWRDialog(context, null),
                                icon: const Icon(
                                  Icons.add,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'Add New TWR',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'BricolageGrotesque',
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Filter dropdown row
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Equip Class',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8C9BA5),
                              fontFamily: 'BricolageGrotesque',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 240,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedEquipClassFilter,
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Color(0xFF0F2C59),
                                ),
                                items:
                                    [
                                          "All",
                                          "Piping",
                                          "Valves",
                                          "Vessels",
                                          "Exchangers",
                                          "Pumps",
                                        ]
                                        .map(
                                          (val) => DropdownMenuItem(
                                            value: val,
                                            child: Text(val),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      _selectedEquipClassFilter = val;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Desktop Table
                      items.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 40.0),
                                child: Text('No matching TWR items found.'),
                              ),
                            )
                          : _buildTwrDataTable(items),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                '© 2026 - EZTRAK Software, LLC. All Rights Reserved.',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF8C9BA5),
                  fontFamily: 'BricolageGrotesque',
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTwrDataTable(List<TWRItem> items) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Table Header
          Container(
            color: const Color(0xFFF9FAFB),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Equip Class',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF0F2C59),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'TWR',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF0F2C59),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Service',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF0F2C59),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Equip#',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF0F2C59),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Equip Desc.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF0F2C59),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'PID',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF0F2C59),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'OPS Pkg',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF0F2C59),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Map',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF0F2C59),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Actions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF0F2C59),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          // Table Rows
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, idx) {
              final item = items[idx];
              final isAlternating = idx % 2 == 1;

              return Container(
                decoration: BoxDecoration(
                  color: isAlternating ? const Color(0xFFF9FAFB) : Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        item.equipClass,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF5A6A85),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        item.twr,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF5A6A85),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        item.serviceType,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF5A6A85),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        item.equipNo,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF5A6A85),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        item.equipClass == "Piping"
                            ? "Crude/Hot MPA Exchanger"
                            : "Equipment Description",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF5A6A85),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        item.pid,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF5A6A85),
                        ),
                      ),
                    ),
                    // Progress bar for OPS Pkg
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        margin: const EdgeInsets.only(right: 16),
                        child: const Center(
                          child: Text(
                            '0%',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5A6A85),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        '—',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF5A6A85),
                        ),
                      ),
                    ),
                    // Action Buttons (Edit & Delete)
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: Colors.orange,
                              size: 18,
                            ),
                            onPressed: () => _showAddTWRDialog(context, item),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 18,
                            ),
                            onPressed: () => _confirmDeleteTWR(item),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMobileTwrCard(TWRItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.twr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'BricolageGrotesque',
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                item.equipClass,
                style: const TextStyle(
                  color: primary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(
              'Service: ${item.serviceType}',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 12,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.build_circle_outlined,
                      size: 14,
                      color: lightTextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Equip#: ${item.equipNo}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: lightTextColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.picture_in_picture_alt,
                      size: 14,
                      color: lightTextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'PID: ${item.pid}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: lightTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange, size: 18),
              onPressed: () => _showAddTWRDialog(context, item),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 18),
              onPressed: () => _confirmDeleteTWR(item),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteTWR(TWRItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Delete TWR',
          style: TextStyle(fontFamily: 'BricolageGrotesque'),
        ),
        content: Text(
          'Are you sure you want to delete TWR ${item.twr}?',
          style: const TextStyle(fontFamily: 'BricolageGrotesque'),
        ),
        actions: [
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF5A6A85)),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              _controller.twrItems.removeWhere((i) => i.id == item.id);
              Navigator.pop(context);
              Get.snackbar(
                'TWR Deleted',
                'TWR ${item.twr} has been deleted.',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            },
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 3. ASSETS TAB
  // ===========================================================================
  Widget _buildAssetsTab(bool isWide) {
    if (!isWide) {
      // Mobile View: search bar, Sub-tab bar (Isolations vs Blinds), and cards list
      return Scaffold(
        backgroundColor: lightBackground,
        body: Column(
          children: [
            // Sub-TabBar
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _assetsTabController,
                indicatorColor: primary,
                labelColor: primary,
                unselectedLabelColor: lightTextColor,
                tabs: const [
                  Tab(text: "Isolations"),
                  Tab(text: "Blinds"),
                ],
              ),
            ),
            _buildSearchField('Search assets by tag, location...'),
            Expanded(
              child: TabBarView(
                controller: _assetsTabController,
                children: [
                  _buildMobileIsolationsList(),
                  _buildMobileBlindsList(),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Wide View: Sub-TabBar buttons, Filter row, Data table
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200, width: 1),
              ),
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sub-tabs styled as buttons
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            setState(() => _assetsTabController.index = 0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: _assetsTabController.index == 0
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _assetsTabController.index == 0
                                  ? Colors.grey.shade300
                                  : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'Isolations',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _assetsTabController.index == 0
                                  ? primary
                                  : const Color(0xFF5A6A85),
                              fontFamily: 'BricolageGrotesque',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () =>
                            setState(() => _assetsTabController.index = 1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: _assetsTabController.index == 1
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _assetsTabController.index == 1
                                  ? Colors.grey.shade300
                                  : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'Blinds',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _assetsTabController.index == 1
                                  ? primary
                                  : const Color(0xFF5A6A85),
                              fontFamily: 'BricolageGrotesque',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Filter Row
                  _buildAssetsFilterRow(),
                  const SizedBox(height: 24),

                  // Table area
                  Expanded(
                    child: _assetsTabController.index == 0
                        ? _buildIsolationsDataTable()
                        : _buildBlindsDataTable(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              '© 2026 - EZTRAK Software, LLC. All Rights Reserved.',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF8C9BA5),
                fontFamily: 'BricolageGrotesque',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetsFilterRow() {
    final bool isIsolations = _assetsTabController.index == 0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Search Input
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Search',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8C9BA5),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) =>
                      setState(() => _searchQuery = val.toLowerCase()),
                  decoration: InputDecoration(
                    hintText: isIsolations
                        ? 'Search tag, description'
                        : 'Search tag, location, e',
                    prefixIcon: const Icon(Icons.search, size: 18),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),

        // Status Dropdown
        _buildFilterDropdown(
          'Status',
          _selectedStatusFilter,
          (val) => setState(() => _selectedStatusFilter = val),
          ['All', 'Entered', 'Confirmed', 'Installed', 'Removed'],
        ),
        const SizedBox(width: 12),

        // Type Dropdown
        _buildFilterDropdown(
          'Type',
          _selectedTypeFilter,
          (val) => setState(() => _selectedTypeFilter = val),
          ['All', 'Isolation Valve', 'Blind', 'Flange', 'Piping'],
        ),
        const SizedBox(width: 12),

        if (isIsolations) ...[
          _buildFilterDropdown(
            'Loop',
            _selectedLoopFilter,
            (val) => setState(() => _selectedLoopFilter = val),
            ['All', 'Bubble Tower', 'Hot Fee', 'Coker'],
          ),
          const SizedBox(width: 12),
          _buildFilterDropdown(
            'Position',
            _selectedPositionFilter,
            (val) => setState(() => _selectedPositionFilter = val),
            ['All', 'Inlet', 'Outlet', 'Suction', 'Discharge'],
          ),
          const SizedBox(width: 12),
          _buildFilterDropdown(
            'Scaffold',
            _selectedScaffoldFilter,
            (val) => setState(() => _selectedScaffoldFilter = val),
            ['All', 'Yes', 'No'],
          ),
          const SizedBox(width: 12),
          _buildFilterDropdown(
            'Height',
            _selectedHeightFilter,
            (val) => setState(() => _selectedHeightFilter = val),
            ['All', '6 ft', '12 ft', '18 ft'],
          ),
        ] else ...[
          _buildFilterDropdown(
            'Live Line',
            _selectedLiveLineFilter,
            (val) => setState(() => _selectedLiveLineFilter = val),
            ['All', 'Yes', 'No'],
          ),
          const SizedBox(width: 12),
          _buildFilterDropdown(
            'F/A',
            _selectedFaFilter,
            (val) => setState(() => _selectedFaFilter = val),
            ['All', 'Yes', 'No'],
          ),
          const SizedBox(width: 12),
          _buildFilterDropdown(
            'Hydro',
            _selectedHydroFilter,
            (val) => setState(() => _selectedHydroFilter = val),
            ['All', 'Yes', 'No'],
          ),
          const SizedBox(width: 12),
          _buildFilterDropdown(
            'Scaffold',
            _selectedScaffoldFilter,
            (val) => setState(() => _selectedScaffoldFilter = val),
            ['All', 'Yes', 'No'],
          ),
        ],

        // Export Button (Green)
        TextButton.icon(
          onPressed: () {
            Get.snackbar(
              'Export Successful',
              'The assets sheet has been exported to CSV.',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          },
          icon: const Icon(Icons.download, size: 16, color: Colors.green),
          label: const Text(
            'Export',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
              fontFamily: 'BricolageGrotesque',
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String value,
    Function(String) onChanged,
    List<String> options,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8C9BA5),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFF0F2C59),
                ),
                items: options
                    .map(
                      (v) => DropdownMenuItem(
                        value: v,
                        child: Text(v, style: const TextStyle(fontSize: 12)),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) onChanged(val);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Isolations Table
  Widget _buildIsolationsDataTable() {
    return Obx(() {
      final items = _controller.isolationItems.where((i) {
        final matchesSearch =
            i.tagNo.toLowerCase().contains(_searchQuery) ||
            i.location.toLowerCase().contains(_searchQuery) ||
            i.twr.toLowerCase().contains(_searchQuery) ||
            i.status.toLowerCase().contains(_searchQuery);

        final matchesStatus =
            _selectedStatusFilter == "All" ||
            i.status.toLowerCase() == _selectedStatusFilter.toLowerCase();
        final matchesType =
            _selectedTypeFilter == "All" ||
            i.type.toLowerCase().contains(_selectedTypeFilter.toLowerCase());

        return matchesSearch && matchesStatus && matchesType;
      }).toList();

      if (items.isEmpty) {
        return const Center(child: Text('No isolation items found.'));
      }

      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: const Color(0xFFF9FAFB),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF0F2C59),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Isolation Type',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF0F2C59),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Tag #',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF0F2C59),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF0F2C59),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Location',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF0F2C59),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Loop',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF0F2C59),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, idx) {
                  final item = items[idx];
                  final isAlternating = idx % 2 == 1;

                  Color statusColor = Colors.grey;
                  if (item.status == "Installed") statusColor = Colors.green;
                  if (item.status == "Confirmed") statusColor = Colors.orange;
                  if (item.status == "Removed") statusColor = Colors.red;

                  return Container(
                    decoration: BoxDecoration(
                      color: isAlternating
                          ? const Color(0xFFF9FAFB)
                          : Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            item.type,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF5A6A85),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () => _showStatusUpdateDialog(
                              context,
                              item.tagNo,
                              item.status,
                              true,
                            ),
                            child: Text(
                              item.tagNo,
                              style: const TextStyle(
                                fontSize: 13,
                                color: primary,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            item.tagNo == "#226"
                                ? "22E3 Bypass Block Valve"
                                : "Equipment isolation valve markup",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF5A6A85),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            item.location,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF5A6A85),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            item.tagNo == "#226"
                                ? "Bubble Tower"
                                : "Process Line Loop",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF5A6A85),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  // Blinds Table
  Widget _buildBlindsDataTable() {
    return Obx(() {
      final items = _controller.blindItems.where((b) {
        final matchesSearch =
            b.tagNo.toLowerCase().contains(_searchQuery) ||
            b.twr.toLowerCase().contains(_searchQuery) ||
            b.flangeSize.toLowerCase().contains(_searchQuery) ||
            b.status.toLowerCase().contains(_searchQuery);

        final matchesStatus =
            _selectedStatusFilter == "All" ||
            b.status.toLowerCase() == _selectedStatusFilter.toLowerCase();

        return matchesSearch && matchesStatus;
      }).toList();

      if (items.isEmpty) {
        return const Center(child: Text('No blind items found.'));
      }

      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          scrollDirection:
              Axis.horizontal, // Large blinds table requires horizontal scroll
          child: SizedBox(
            width: 1400, // Fixed wide container for columns
            child: Column(
              children: [
                Container(
                  color: const Color(0xFFF9FAFB),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Status',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF0F2C59),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Tag #',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF0F2C59),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Flange Size',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF0F2C59),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Flange Type',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF0F2C59),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Pressure Rating',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF0F2C59),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Service',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF0F2C59),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Live Flare?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF0F2C59),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'N/S/E/W',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF0F2C59),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Equip #',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF0F2C59),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Height',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF0F2C59),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Max PSIG',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF0F2C59),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Hydro Req?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF0F2C59),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Min. Thick',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF0F2C59),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, idx) {
                    final item = items[idx];
                    final isAlternating = idx % 2 == 1;

                    Color statusColor = Colors.grey;
                    if (item.status == "Installed") statusColor = Colors.green;
                    if (item.status == "Confirmed") statusColor = Colors.orange;
                    if (item.status == "Removed") statusColor = Colors.red;

                    return Container(
                      decoration: BoxDecoration(
                        color: isAlternating
                            ? const Color(0xFFF9FAFB)
                            : Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () => _showStatusUpdateDialog(
                                context,
                                item.tagNo,
                                item.status,
                                false,
                              ),
                              child: Text(
                                item.tagNo,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item.flangeSize,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF5A6A85),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item.flangeType,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF5A6A85),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item.rating,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF5A6A85),
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 3,
                            child: Text(
                              'HGO Inlet Bypass line isolation',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF5A6A85),
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Text(
                              'No',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF5A6A85),
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Text(
                              'E',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF5A6A85),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item.twr,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF5A6A85),
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Text(
                              '—',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF5A6A85),
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Text(
                              '150',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF5A6A85),
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF5A6A85),
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Text(
                              '0.25"',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF5A6A85),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // Mobile list builders
  Widget _buildMobileIsolationsList() {
    return Obx(() {
      final items = _controller.isolationItems.where((i) {
        return i.tagNo.toLowerCase().contains(_searchQuery) ||
            i.location.toLowerCase().contains(_searchQuery);
      }).toList();

      if (items.isEmpty) return _buildEmptyState('No Isolation items.');

      return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: items.length,
        itemBuilder: (context, idx) {
          final item = items[idx];
          Color color = Colors.grey;
          if (item.status == "Installed") color = Colors.green;
          if (item.status == "Confirmed") color = Colors.orange;
          if (item.status == "Removed") color = Colors.red;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.tagNo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'BricolageGrotesque',
                    ),
                  ),
                  _buildStatusBadge(item.status, color),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text('Location: ${item.location}'),
                  const SizedBox(height: 4),
                  Text(
                    'Type: ${item.type} · TWR: ${item.twr}',
                    style: const TextStyle(fontSize: 11, color: lightTextColor),
                  ),
                ],
              ),
              onTap: () => _showStatusUpdateDialog(
                context,
                item.tagNo,
                item.status,
                true,
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildMobileBlindsList() {
    return Obx(() {
      final items = _controller.blindItems.where((b) {
        return b.tagNo.toLowerCase().contains(_searchQuery) ||
            b.twr.toLowerCase().contains(_searchQuery);
      }).toList();

      if (items.isEmpty) return _buildEmptyState('No Blind items.');

      return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: items.length,
        itemBuilder: (context, idx) {
          final item = items[idx];
          Color color = Colors.grey;
          if (item.status == "Installed") color = Colors.green;
          if (item.status == "Confirmed") color = Colors.orange;
          if (item.status == "Removed") color = Colors.red;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.tagNo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'BricolageGrotesque',
                    ),
                  ),
                  _buildStatusBadge(item.status, color),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    'Size: ${item.flangeSize} (${item.flangeType}) · Rating: ${item.rating}',
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'TWR: ${item.twr}',
                    style: const TextStyle(fontSize: 11, color: lightTextColor),
                  ),
                ],
              ),
              onTap: () => _showStatusUpdateDialog(
                context,
                item.tagNo,
                item.status,
                false,
              ),
            ),
          );
        },
      );
    });
  }

  // ===========================================================================
  // COMMON HELPER WIDGETS
  // ===========================================================================
  Widget _buildSearchField(String hintText) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: TextField(
        controller: _searchController,
        onChanged: (val) {
          setState(() {
            _searchQuery = val.toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search, color: lightTextColor),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = "";
                    });
                  },
                )
              : null,
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
          fontFamily: 'BricolageGrotesque',
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.layers_clear_outlined,
            size: 48,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(
              color: lightTextColor,
              fontFamily: 'BricolageGrotesque',
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // POPUP FORMS & DIALOGS
  // ===========================================================================
  void _showAddTWRDialog(BuildContext context, TWRItem? existingItem) {
    final formKey = GlobalKey<FormState>();
    final bool isEditing = existingItem != null;

    String equipClass = isEditing
        ? existingItem.equipClass
        : _controller.equipClasses.first;
    String twr = isEditing ? existingItem.twr : "";
    String description = isEditing ? "Equipment Description" : "";
    String serviceType = isEditing ? existingItem.serviceType : "";
    String equipNo = isEditing ? existingItem.equipNo : "";
    String equipDesc = isEditing ? "Equipment Description Details" : "";
    String pid = isEditing ? existingItem.pid : "";

    showDialog(
      context: context,
      builder: (context) {
        final bool isWide = MediaQuery.of(context).size.width >= 800;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(24),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEditing ? 'Edit TWR' : 'Add New TWR',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BricolageGrotesque',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: isWide ? 700 : 340,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(),
                    const SizedBox(height: 16),
                    if (isWide) ...[
                      Row(
                        children: [
                          Expanded(
                            child: FormDropdownField(
                              label: 'Equip Class',
                              placeholder: 'Select Equip Class',
                              selectedValue: equipClass,
                              items: _controller.equipClasses,
                              isRequired: true,
                              onChanged: (val) {
                                if (val != null) equipClass = val;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: FormTextField(
                              label: 'TWR',
                              placeholder: 'e.g. T-01P-101',
                              controller: TextEditingController(text: twr),
                              isRequired: true,
                              validator: (val) => val == null || val.isEmpty
                                  ? 'Required'
                                  : null,
                              onChanged: (val) => twr = val,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: FormTextField(
                              label: 'Description',
                              placeholder: 'e.g. Main pipeline description',
                              controller: TextEditingController(
                                text: description,
                              ),
                              isRequired: true,
                              validator: (val) => val == null || val.isEmpty
                                  ? 'Required'
                                  : null,
                              onChanged: (val) => description = val,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: FormTextField(
                              label: 'Service Type',
                              placeholder: 'e.g. HGO Pumparound',
                              controller: TextEditingController(
                                text: serviceType,
                              ),
                              isRequired: true,
                              validator: (val) => val == null || val.isEmpty
                                  ? 'Required'
                                  : null,
                              onChanged: (val) => serviceType = val,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: FormTextField(
                              label: 'Equip #',
                              placeholder: 'e.g. 22E-3',
                              controller: TextEditingController(text: equipNo),
                              isRequired: true,
                              validator: (val) => val == null || val.isEmpty
                                  ? 'Required'
                                  : null,
                              onChanged: (val) => equipNo = val,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: FormTextField(
                              label: 'Equip. Description',
                              placeholder: 'e.g. Crude exchanger',
                              controller: TextEditingController(
                                text: equipDesc,
                              ),
                              isRequired: true,
                              validator: (val) => val == null || val.isEmpty
                                  ? 'Required'
                                  : null,
                              onChanged: (val) => equipDesc = val,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: FormTextField(
                              label: 'PID',
                              placeholder: 'e.g. 22A0102D01',
                              controller: TextEditingController(text: pid),
                              isRequired: true,
                              validator: (val) => val == null || val.isEmpty
                                  ? 'Required'
                                  : null,
                              onChanged: (val) => pid = val,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          const Expanded(child: SizedBox()),
                        ],
                      ),
                    ] else ...[
                      // Mobile single column form
                      FormDropdownField(
                        label: 'Equip Class',
                        placeholder: 'Select class',
                        selectedValue: equipClass,
                        items: _controller.equipClasses,
                        isRequired: true,
                        onChanged: (val) {
                          if (val != null) equipClass = val;
                        },
                      ),
                      const SizedBox(height: 12),
                      FormTextField(
                        label: 'TWR Tag #',
                        placeholder: 'e.g. T-01P-101',
                        controller: TextEditingController(text: twr),
                        isRequired: true,
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Required' : null,
                        onChanged: (val) => twr = val,
                      ),
                      const SizedBox(height: 12),
                      FormTextField(
                        label: 'Service Type',
                        placeholder: 'e.g. Suction Manifold',
                        controller: TextEditingController(text: serviceType),
                        isRequired: true,
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Required' : null,
                        onChanged: (val) => serviceType = val,
                      ),
                      const SizedBox(height: 12),
                      FormTextField(
                        label: 'Equipment Number',
                        placeholder: 'e.g. 22E-3',
                        controller: TextEditingController(text: equipNo),
                        isRequired: true,
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Required' : null,
                        onChanged: (val) => equipNo = val,
                      ),
                      const SizedBox(height: 12),
                      FormTextField(
                        label: 'PID Drawing #',
                        placeholder: 'e.g. 22A0102D01',
                        controller: TextEditingController(text: pid),
                        isRequired: true,
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Required' : null,
                        onChanged: (val) => pid = val,
                      ),
                    ],
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF64748B),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              final newItem = TWRItem(
                                id: isEditing
                                    ? existingItem.id
                                    : DateTime.now().millisecondsSinceEpoch
                                          .toString(),
                                equipClass: equipClass,
                                serviceType: serviceType,
                                twr: twr,
                                equipNo: equipNo,
                                pid: pid,
                              );

                              if (isEditing) {
                                _controller.updateTWR(newItem);
                              } else {
                                _controller.addTWR(newItem);
                              }

                              Navigator.pop(context);
                              Get.snackbar(
                                'Success',
                                'TWR $twr ${isEditing ? 'updated' : 'created'} successfully!',
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showImportCSVDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: const EdgeInsets.all(24),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Import TWR from CSV',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'BricolageGrotesque',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              content: SizedBox(
                width: 550,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Upload a comma-separated file to create TWR entries in bulk. The first row must be a header row.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: Color(0xFF5A6A85),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Required columns',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F2C59),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• Equip Class',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF5A6A85),
                                height: 1.3,
                              ),
                            ),
                            Text(
                              '• TWR',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF5A6A85),
                                height: 1.3,
                              ),
                            ),
                            Text(
                              '• Description',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF5A6A85),
                                height: 1.3,
                              ),
                            ),
                            Text(
                              '• Service Type',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF5A6A85),
                                height: 1.3,
                              ),
                            ),
                            Text(
                              '• Equip#',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF5A6A85),
                                height: 1.3,
                              ),
                            ),
                            Text(
                              '• Equip. Description',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF5A6A85),
                                height: 1.3,
                              ),
                            ),
                            Text(
                              '• PID',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF5A6A85),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'All columns are required on every data row. Empty rows are ignored. If a TWR value already exists in this project, that row is skipped unless Update existing is enabled.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: Color(0xFF8C9BA5),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Download template button
                      OutlinedButton.icon(
                        onPressed: () {
                          Get.snackbar(
                            'Template Downloaded',
                            'twr_import_template.csv saved successfully.',
                            backgroundColor: Colors.blue,
                            colorText: Colors.white,
                          );
                        },
                        icon: const Icon(
                          Icons.download,
                          size: 16,
                          color: Color(0xFF5A6A85),
                        ),
                        label: const Text(
                          'Download template',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5A6A85),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Toggle Switch
                      Row(
                        children: [
                          Switch(
                            value: _updateExistingTwr,
                            activeColor: primary,
                            onChanged: (val) {
                              setModalState(() {
                                _updateExistingTwr = val;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Update existing TWR entries when TWR value matches',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF5A6A85),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // File picker box
                      const Text(
                        'CSV file',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F2C59),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setModalState(() {
                                  _selectedFileName =
                                      "twr_isolation_bulk_list.csv";
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEDF1F7),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text(
                                'Choose File',
                                style: TextStyle(
                                  color: Color(0xFF5A6A85),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _selectedFileName,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF8C9BA5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Modal Actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedFileName = "no file selected";
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF64748B),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              if (_selectedFileName == "no file selected") {
                                Get.snackbar(
                                  'No File selected',
                                  'Please select a CSV file first.',
                                  backgroundColor: Colors.orange,
                                  colorText: Colors.white,
                                );
                                return;
                              }
                              // Mock importing two TWR rows
                              _controller.addTWR(
                                TWRItem(
                                  id: "csv1",
                                  equipClass: "Piping",
                                  serviceType: "Vent Line",
                                  twr: "T-01P-105",
                                  equipNo: "22E-3",
                                  pid: "22A0102D01",
                                ),
                              );
                              _controller.addTWR(
                                TWRItem(
                                  id: "csv2",
                                  equipClass: "Valves",
                                  serviceType: "Drain Valve",
                                  twr: "T-01V-106",
                                  equipNo: "22C-1",
                                  pid: "22A0102D02",
                                ),
                              );

                              setState(() {
                                _selectedFileName = "no file selected";
                              });
                              Navigator.pop(context);

                              Get.snackbar(
                                'Import Complete',
                                'Bulk imported 2 new TWR entries successfully!',
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Import',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showStatusUpdateDialog(
    BuildContext context,
    String tagNo,
    String currentStatus,
    bool isIsolation,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Update Status for $tagNo',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: mainTextColor,
                  fontFamily: 'BricolageGrotesque',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Current Status: $currentStatus',
                style: const TextStyle(
                  fontSize: 13,
                  color: lightTextColor,
                  fontFamily: 'BricolageGrotesque',
                ),
              ),
              const Divider(),
              const SizedBox(height: 8),
              _buildStatusOption(
                context,
                tagNo,
                'Entered',
                Colors.blue,
                isIsolation,
              ),
              _buildStatusOption(
                context,
                tagNo,
                'Confirmed',
                Colors.orange,
                isIsolation,
              ),
              _buildStatusOption(
                context,
                tagNo,
                'Installed',
                Colors.green,
                isIsolation,
              ),
              _buildStatusOption(
                context,
                tagNo,
                'Removed',
                Colors.red,
                isIsolation,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusOption(
    BuildContext context,
    String tagNo,
    String status,
    Color color,
    bool isIsolation,
  ) {
    return ListTile(
      leading: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      title: Text(
        status,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: mainTextColor,
          fontFamily: 'BricolageGrotesque',
        ),
      ),
      onTap: () {
        if (isIsolation) {
          _controller.updateIsolationStatus(tagNo, status);
        } else {
          _controller.updateBlindStatus(tagNo, status);
        }
        Navigator.pop(context);
        Get.snackbar(
          'Status Updated',
          'Tag $tagNo is now $status.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
    );
  }
}

// Vector Blueprint painter drawing pipes, lines, grid and schematic symbols
class DynamicBlueprintPainter extends CustomPainter {
  final String filename;
  final String? selectedTag;

  DynamicBlueprintPainter({required this.filename, this.selectedTag});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFF1E293B).withOpacity(0.4)
      ..strokeWidth = 0.5;

    // 1. Draw Grid Lines
    const double gridSpace = 25.0;
    for (double i = 0; i < size.width; i += gridSpace) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += gridSpace) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    final pipePaint = Paint()
      ..color =
          const Color(0xFF38BDF8) // Light blue pipe lines
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final vesselPaint = Paint()
      ..color = const Color(0xFF64748B)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const textStyle = TextStyle(
      color: Color(0xFF94A3B8),
      fontSize: 10,
      fontWeight: FontWeight.bold,
      fontFamily: 'BricolageGrotesque',
    );

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    if (filename.contains("22A0102D01")) {
      // Draw 22E-3 Exchanger Loop
      final path = Path()
        ..moveTo(20, 150)
        ..lineTo(220, 150)
        ..lineTo(220, 240)
        ..lineTo(320, 240);
      canvas.drawPath(path, pipePaint);

      final path2 = Path()
        ..moveTo(220, 150)
        ..lineTo(450, 150)
        ..lineTo(450, 90)
        ..lineTo(550, 90);
      canvas.drawPath(path2, pipePaint);

      // Heat Exchanger Shell
      canvas.drawRect(const Rect.fromLTWH(180, 110, 100, 80), vesselPaint);
      final zigPath = Path()
        ..moveTo(180, 150)
        ..lineTo(200, 130)
        ..lineTo(220, 170)
        ..lineTo(240, 130)
        ..lineTo(260, 170)
        ..lineTo(280, 150);
      canvas.drawPath(zigPath, pipePaint);

      textPainter.text = const TextSpan(text: 'HE-22E-3', style: textStyle);
      textPainter.layout();
      textPainter.paint(canvas, const Offset(195, 115));

      textPainter.text = const TextSpan(text: 'HGO INLET', style: textStyle);
      textPainter.layout();
      textPainter.paint(canvas, const Offset(30, 132));

      textPainter.text = const TextSpan(
        text: 'OUTLET TO COLUMN',
        style: textStyle,
      );
      textPainter.layout();
      textPainter.paint(canvas, const Offset(430, 72));
    } else if (filename.contains("22A0102D02")) {
      // Draw Coker Column top reflux
      final path = Path()
        ..moveTo(50, 200)
        ..lineTo(250, 200)
        ..lineTo(250, 80)
        ..lineTo(480, 80);
      canvas.drawPath(path, pipePaint);

      // Coker Column structure
      canvas.drawRect(const Rect.fromLTWH(60, 50, 80, 220), vesselPaint);
      // Divider plates inside column
      canvas.drawLine(
        const Offset(60, 100),
        const Offset(140, 100),
        vesselPaint,
      );
      canvas.drawLine(
        const Offset(60, 150),
        const Offset(140, 150),
        vesselPaint,
      );
      canvas.drawLine(
        const Offset(60, 200),
        const Offset(140, 200),
        vesselPaint,
      );

      textPainter.text = const TextSpan(
        text: 'COKER COLUMN 22C-1',
        style: textStyle,
      );
      textPainter.layout();
      textPainter.paint(canvas, const Offset(65, 60));

      textPainter.text = const TextSpan(
        text: 'TOP REFLUX LINE',
        style: textStyle,
      );
      textPainter.layout();
      textPainter.paint(canvas, const Offset(260, 95));

      textPainter.text = const TextSpan(
        text: 'VENT TO FLARE',
        style: textStyle,
      );
      textPainter.layout();
      textPainter.paint(canvas, const Offset(400, 60));
    } else if (filename.contains("01A0105A11")) {
      // Draw Pump P-101A Suction Manifold
      final path = Path()
        ..moveTo(30, 120)
        ..lineTo(200, 120)
        ..lineTo(200, 220)
        ..lineTo(500, 220);
      canvas.drawPath(path, pipePaint);

      // Pump shell symbol
      canvas.drawCircle(const Offset(350, 220), 30, vesselPaint);
      final pumpLine = Path()
        ..moveTo(320, 220)
        ..lineTo(380, 220)
        ..moveTo(350, 190)
        ..lineTo(350, 250);
      canvas.drawPath(pumpLine, vesselPaint);

      textPainter.text = const TextSpan(text: 'PUMP P-101A', style: textStyle);
      textPainter.layout();
      textPainter.paint(canvas, const Offset(315, 150));

      textPainter.text = const TextSpan(
        text: 'CRUDE SUCTION MANIFOLD',
        style: textStyle,
      );
      textPainter.layout();
      textPainter.paint(canvas, const Offset(50, 98));

      textPainter.text = const TextSpan(
        text: 'DISCHARGE TO EXCHANGERS',
        style: textStyle,
      );
      textPainter.layout();
      textPainter.paint(canvas, const Offset(380, 235));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
