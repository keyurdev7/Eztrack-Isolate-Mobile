import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eztrack_rental/theme/color.dart';
import 'package:eztrack_rental/controllers/isolate_controller.dart';
import '../widgets/common_app_bar.dart';

class DashbordPage extends StatefulWidget {
  const DashbordPage({Key? key}) : super(key: key);

  @override
  _DashbordPageState createState() => _DashbordPageState();
}

class _DashbordPageState extends State<DashbordPage> {
  final IsolateController _controller = Get.find<IsolateController>();
  String _selectedProjectDropdown = 'All Projects';
  String _selectedLoopDropdown = 'BL HDT Hot Fee';

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      // appBar: isWide
      //     ? null
      //     : CommonAppBar(
      //         userName: "",
      //         greeting:
      //             _controller.selectedProject.value?.name ??
      //             "Turnaround Project",
      //       ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 500));
          },
          color: primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(isWide ? 24 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  Top Dashboard Header (Only shown when wide, otherwise handled by AppBar + page title)
                if (isWide) _buildWideHeader(),
                if (isWide) const SizedBox(height: 24),

                // Mobile Title & Subtitle (Only shown when mobile)
                if (!isWide) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dashboard',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0F2C59),
                                fontFamily: 'BricolageGrotesque',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Real-time isolation & blind tracking status',
                              style: TextStyle(
                                fontSize: 10,
                                color: const Color(0xFF8C9BA5),
                                fontFamily: 'BricolageGrotesque',
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildDropdownSelector(),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Responsive Grid of 6 Cards
                LayoutBuilder(
                  builder: (context, constraints) {
                    final double width = constraints.maxWidth;
                    int crossAxisCount = 1;
                    double childAspectRatio = 1.3;

                    if (width >= 1050) {
                      crossAxisCount = 3;
                      childAspectRatio = 1.25;
                    } else if (width >= 650) {
                      crossAxisCount = 2;
                      childAspectRatio = 1.2;
                    } else {
                      crossAxisCount = 1;
                      childAspectRatio = 1.4;
                    }

                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: childAspectRatio,
                      children: [
                        _buildCard1(),
                        _buildCard2(),
                        _buildCard3(),
                        _buildCard4(),
                        _buildCard5(),
                        _buildCard6(width),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Footer Copyright Notice
                Center(
                  child: Text(
                    '© 2026 - EZTRAK Software, LLC. All Rights Reserved.',
                    style: TextStyle(
                      fontSize: 11,
                      color: const Color(0xFF8C9BA5),
                      fontFamily: 'BricolageGrotesque',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Header Widgets ---

  Widget _buildWideHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 5,
              height: 28,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F2C59),
                fontFamily: 'BricolageGrotesque',
              ),
            ),
          ],
        ),
        _buildDropdownSelector(),
      ],
    );
  }

  Widget _buildDropdownSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedProjectDropdown,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF0F2C59)),
          style: const TextStyle(
            color: Color(0xFF0F2C59),
            fontWeight: FontWeight.bold,
            fontFamily: 'BricolageGrotesque',
            fontSize: 13,
          ),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedProjectDropdown = newValue;
              });
            }
          },
          items:
              <String>[
                'All Projects',
                '22 Coker TA27',
                '01 Crude TA27',
                '06 Hydro TA26',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
        ),
      ),
    );
  }

  // --- Base Card Template ---

  Widget _buildDashboardCard({
    required int index,
    required String title,
    required Widget content,
    Widget? headerAction,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header of Card
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A4B84),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      index.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'BricolageGrotesque',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F2C59),
                      fontFamily: 'BricolageGrotesque',
                    ),
                  ),
                ],
              ),
              if (headerAction != null) headerAction,
            ],
          ),
          const SizedBox(height: 16),
          // Content of Card
          Expanded(child: content),
        ],
      ),
    );
  }

  // --- Status Detail Dialog ---

  void _showStatusDetail({
    required String title,
    required String status,
    required int value,
    String? extra,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.analytics_outlined,
                  color: primary,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F2C59),
                  fontFamily: 'BricolageGrotesque',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Divider(color: Colors.grey.shade100, height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    status,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5A6A85),
                      fontFamily: 'BricolageGrotesque',
                    ),
                  ),
                  Text(
                    value.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primary,
                      fontFamily: 'BricolageGrotesque',
                    ),
                  ),
                ],
              ),
              if (extra != null) ...[
                const SizedBox(height: 10),
                Text(
                  extra,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF8C9BA5),
                    fontFamily: 'BricolageGrotesque',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'BricolageGrotesque',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Specific Cards ---

  // Card 1: Isolation Status
  Widget _buildCard1() {
    return _buildDashboardCard(
      index: 1,
      title: 'Isolation Status',
      content: _CustomBarChart(
        maxValue: 200,
        yInterval: 40,
        data: const [
          BarChartData('Entered', 159, Color(0xFFD82C6B)),
          BarChartData('Confirmed', 0, Color(0xFF82B1E1)),
          BarChartData('Installed', 0, Color(0xFF10B981)),
          BarChartData('Removed', 0, Color(0xFFFF6B35)),
        ],
        onBarTapped: (bar) {
          _showStatusDetail(
            title: 'Isolation Status Detail',
            status: bar.label,
            value: bar.value.toInt(),
            extra:
                'Number of isolation valve tags currently in "${bar.label}" status.',
          );
        },
      ),
    );
  }

  // Card 2: Isolation Scaffold Jobs
  Widget _buildCard2() {
    return _buildDashboardCard(
      index: 2,
      title: 'Isolation Scaffold Jobs',
      content: _CustomDonutChart(
        centerCount: '4',
        centerLabel: 'Total',
        slices: [
          DonutSlice('Installed', 0, const Color(0xFF82B1E1)),
          DonutSlice('Not Installed', 4, const Color(0xFFF8C8A5)),
        ],
        onSliceTapped: (slice) {
          _showStatusDetail(
            title: 'Isolation Scaffold Jobs',
            status: slice.label,
            value: slice.value.toInt(),
            extra:
                'Scaffold construction jobs associated with isolation tag installations.',
          );
        },
        onVisualTapped: () {
          _showStatusDetail(
            title: 'Isolation Scaffold Jobs',
            status: 'Total Jobs',
            value: 4,
            extra:
                'Combined total of installed and not installed scaffold jobs.',
          );
        },
      ),
    );
  }

  // Card 3: Isolations
  Widget _buildCard3() {
    return _buildDashboardCard(
      index: 3,
      title: 'Isolations',
      content: _CustomDonutChart(
        centerCount: '159',
        centerLabel: 'Total',
        slices: [
          DonutSlice('Open', 66, const Color(0xFF10B981)),
          DonutSlice('Closed', 93, const Color(0xFFFA8C16)),
        ],
        onSliceTapped: (slice) {
          _showStatusDetail(
            title: 'Isolations Status',
            status: slice.label,
            value: slice.value.toInt(),
            extra: 'Isolation tag points currently marked as "${slice.label}".',
          );
        },
        onVisualTapped: () {
          _showStatusDetail(
            title: 'Isolations Status',
            status: 'Total Isolations',
            value: 159,
            extra: 'Total number of active tracked isolations in the project.',
          );
        },
      ),
    );
  }

  // Card 4: Blind Status
  Widget _buildCard4() {
    return _buildDashboardCard(
      index: 4,
      title: 'Blind Status',
      content: _CustomBarChart(
        maxValue: 7,
        yInterval: 1,
        data: const [
          BarChartData('Entered', 5, Color(0xFFD82C6B)),
          BarChartData('Confirmed', 6, Color(0xFF82B1E1)),
          BarChartData('Installed', 0, Color(0xFF10B981)),
          BarChartData('Removed', 0, Color(0xFFFF6B35)),
        ],
        onBarTapped: (bar) {
          _showStatusDetail(
            title: 'Blind Status Detail',
            status: bar.label,
            value: bar.value.toInt(),
            extra:
                'Number of blind piping gasket tags currently in "${bar.label}" status.',
          );
        },
      ),
    );
  }

  // Card 5: Blind Scaffold Jobs
  Widget _buildCard5() {
    return _buildDashboardCard(
      index: 5,
      title: 'Blind Scaffold Jobs',
      content: _CustomDonutChart(
        centerCount: '9',
        centerLabel: 'Total',
        slices: [
          DonutSlice('Installed', 0, const Color(0xFF82B1E1)),
          DonutSlice('Not Installed', 9, const Color(0xFFF8C8A5)),
        ],
        onSliceTapped: (slice) {
          _showStatusDetail(
            title: 'Blind Scaffold Jobs',
            status: slice.label,
            value: slice.value.toInt(),
            extra:
                'Scaffold construction jobs associated with blind tag installations.',
          );
        },
        onVisualTapped: () {
          _showStatusDetail(
            title: 'Blind Scaffold Jobs',
            status: 'Total Jobs',
            value: 9,
            extra:
                'Combined total of installed and not installed scaffold jobs.',
          );
        },
      ),
    );
  }

  // Card 6: Loop Stats
  Widget _buildCard6(double availableWidth) {
    final loopDropdown = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF82B1E1), width: 1.2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLoopDropdown,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Color(0xFF82B1E1),
            size: 16,
          ),
          style: const TextStyle(
            color: Color(0xFF82B1E1),
            fontWeight: FontWeight.bold,
            fontFamily: 'BricolageGrotesque',
            fontSize: 10,
          ),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedLoopDropdown = newValue;
              });
            }
          },
          items:
              <String>[
                'BL HDT Hot Fee',
                'Coker Column Top',
                'Crude Suction Man.',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
        ),
      ),
    );

    // Responsive Loop Mini Cards layout to prevent overflow on mobile
    Widget loopContent;
    if (availableWidth < 500) {
      // 2x2 grid for very narrow mobile screens
      loopContent = GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 2.2,
        children: [
          _buildLoopMiniCard(
            icon: Icons.hourglass_empty,
            iconColor: const Color(0xFFD82C6B),
            bgColor: const Color(0xFFFFF0F2),
            value: '1',
            label: 'Isolations',
          ),
          _buildLoopMiniCard(
            icon: Icons.construction,
            iconColor: const Color(0xFFFA8C16),
            bgColor: const Color(0xFFFFF7E6),
            value: '1',
            label: 'Scaffold Jobs',
          ),
          _buildLoopMiniCard(
            icon: Icons.text_fields_outlined,
            iconColor: const Color(0xFF1890FF),
            bgColor: const Color(0xFFE6F7FF),
            value: '0',
            label: 'Test Points',
          ),
          _buildProgressMiniCard(),
        ],
      );
    } else {
      // Horizontal row for tablets and wide mobile layouts
      loopContent = Row(
        children: [
          Expanded(
            child: _buildLoopMiniCard(
              icon: Icons.hourglass_empty,
              iconColor: const Color(0xFFD82C6B),
              bgColor: const Color(0xFFFFF0F2),
              value: '1',
              label: 'Isolations',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildLoopMiniCard(
              icon: Icons.construction,
              iconColor: const Color(0xFFFA8C16),
              bgColor: const Color(0xFFFFF7E6),
              value: '1',
              label: 'Scaffold Jobs',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildLoopMiniCard(
              icon: Icons.text_fields_outlined,
              iconColor: const Color(0xFF1890FF),
              bgColor: const Color(0xFFE6F7FF),
              value: '0',
              label: 'Test Points',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: _buildProgressMiniCard()),
        ],
      );
    }

    return _buildDashboardCard(
      index: 6,
      title: 'Loop Stats',
      headerAction: loopDropdown,
      content: loopContent,
    );
  }

  Widget _buildLoopMiniCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F2C59),
                    fontFamily: 'BricolageGrotesque',
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 8,
                    color: Color(0xFF8C9BA5),
                    fontFamily: 'BricolageGrotesque',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressMiniCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: 0.0,
                  strokeWidth: 3,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF10B981),
                  ),
                ),
                const Text(
                  '0%',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F2C59),
                    fontFamily: 'BricolageGrotesque',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '0%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F2C59),
                    fontFamily: 'BricolageGrotesque',
                  ),
                ),
                Text(
                  '% Installed',
                  style: TextStyle(
                    fontSize: 8,
                    color: Color(0xFF8C9BA5),
                    fontFamily: 'BricolageGrotesque',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// CUSTOM BAR CHART WIDGET
// =============================================================================

class _CustomBarChart extends StatefulWidget {
  final List<BarChartData> data;
  final double maxValue;
  final double yInterval;
  final Function(BarChartData)? onBarTapped;

  const _CustomBarChart({
    Key? key,
    required this.data,
    required this.maxValue,
    required this.yInterval,
    this.onBarTapped,
  }) : super(key: key);

  @override
  State<_CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<_CustomBarChart> {
  int? _selectedBarIndex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalHeight = constraints.maxHeight;
        final double xAxisHeight = 20.0;
        final double chartHeight =
            totalHeight -
            xAxisHeight -
            16; // reserve space for text value & x-axis

        return Row(
          children: [
            // Y-Axis Labels
            SizedBox(
              width: 24,
              height: chartHeight + 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(
                  (widget.maxValue / widget.yInterval).round() + 1,
                  (index) {
                    final double val =
                        widget.maxValue - (index * widget.yInterval);
                    return Text(
                      val.toInt().toString(),
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF8C9BA5),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'BricolageGrotesque',
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Chart Bars Area
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Horizontal Grid Lines
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 10,
                    height: chartHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        (widget.maxValue / widget.yInterval).round() + 1,
                        (index) =>
                            Container(height: 1, color: Colors.grey.shade100),
                      ),
                    ),
                  ),
                  // Bars and Labels
                  Positioned.fill(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: widget.data.asMap().entries.map((entry) {
                        final int index = entry.key;
                        final bar = entry.value;
                        final double rawBarHeight =
                            (bar.value / widget.maxValue) * chartHeight;
                        final double barHeight = rawBarHeight.clamp(
                          0,
                          chartHeight,
                        );
                        final bool isSelected = _selectedBarIndex == index;

                        return Stack(
                          alignment: Alignment.bottomCenter,
                          clipBehavior: Clip.none,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedBarIndex = isSelected ? null : index;
                                });
                                widget.onBarTapped?.call(bar);
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Value above bar
                                  Text(
                                    bar.value.toInt().toString(),
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: bar.value > 0
                                          ? const Color(0xFF0F2C59)
                                          : const Color(0xFF8C9BA5),
                                      fontFamily: 'BricolageGrotesque',
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  // Bar shape
                                  Container(
                                    width: 24,
                                    height: barHeight,
                                    decoration: BoxDecoration(
                                      color: bar.color,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(3),
                                        topRight: Radius.circular(3),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // X-Axis label
                                  SizedBox(
                                    height: xAxisHeight,
                                    child: Text(
                                      bar.label,
                                      style: const TextStyle(
                                        fontSize: 9,
                                        color: Color(0xFF7A8B9E),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'BricolageGrotesque',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Tooltip bubble positioned absolutely
                            if (isSelected)
                              Positioned(
                                bottom: barHeight + xAxisHeight + 10,
                                child: _buildTooltipBubble(bar),
                              ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTooltipBubble(BarChartData bar) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF262626),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                bar.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BricolageGrotesque',
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: bar.color,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${bar.label}: ${bar.value.toInt()}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'BricolageGrotesque',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Arrow
        Transform.translate(
          offset: const Offset(0, -1),
          child: Transform.rotate(
            angle: pi / 4,
            child: Container(
              width: 8,
              height: 8,
              color: const Color(0xFF262626),
            ),
          ),
        ),
      ],
    );
  }
}

class BarChartData {
  final String label;
  final double value;
  final Color color;

  const BarChartData(this.label, this.value, this.color);
}

// =============================================================================
// CUSTOM DONUT CHART WIDGET & PAINTER
// =============================================================================

class _CustomDonutChart extends StatefulWidget {
  final String centerCount;
  final String centerLabel;
  final List<DonutSlice> slices;
  final Function(DonutSlice)? onSliceTapped;
  final VoidCallback? onVisualTapped;

  const _CustomDonutChart({
    Key? key,
    required this.centerCount,
    required this.centerLabel,
    required this.slices,
    this.onSliceTapped,
    this.onVisualTapped,
  }) : super(key: key);

  @override
  State<_CustomDonutChart> createState() => _CustomDonutChartState();
}

class _CustomDonutChartState extends State<_CustomDonutChart> {
  int? _selectedSliceIndex;

  @override
  Widget build(BuildContext context) {
    int? selectedIndex = _selectedSliceIndex;
    double? tooltipX;
    double? tooltipY;
    DonutSlice? selectedSlice;

    if (selectedIndex != null) {
      selectedSlice = widget.slices[selectedIndex];
      double total = 0;
      for (var s in widget.slices) {
        total += s.value;
      }

      double startAngle = -pi / 2;
      for (int i = 0; i < widget.slices.length; i++) {
        final double sweepAngle = total > 0
            ? 2 * pi * (widget.slices[i].value / total)
            : 0;
        if (i == selectedIndex) {
          double midAngle = startAngle + sweepAngle / 2;
          tooltipX = 50 + 38 * cos(midAngle);
          tooltipY = 50 + 38 * sin(midAngle);
          break;
        }
        startAngle += sweepAngle;
      }
    }

    return Row(
      children: [
        // Donut circle visual with interactive tap coordinates
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTapDown: (details) {
                final double centerX = 50.0;
                final double centerY = 50.0;
                final double dx = details.localPosition.dx - centerX;
                final double dy = details.localPosition.dy - centerY;
                final double dist = sqrt(dx * dx + dy * dy);

                // Ignore if clicked too far or too close
                if (dist < 15 || dist > 55) {
                  setState(() {
                    _selectedSliceIndex = null;
                  });
                  return;
                }

                double angle = atan2(dy, dx);
                if (angle < 0) {
                  angle += 2 * pi;
                }

                double total = 0;
                for (var s in widget.slices) {
                  total += s.value;
                }
                if (total == 0) return;

                double startAngle = -pi / 2;
                if (startAngle < 0) {
                  startAngle += 2 * pi;
                }

                int? tappedIndex;
                for (int i = 0; i < widget.slices.length; i++) {
                  final slice = widget.slices[i];
                  if (slice.value == 0) continue;
                  final double sweepAngle = 2 * pi * (slice.value / total);
                  double endAngle = startAngle + sweepAngle;

                  double normStart = startAngle % (2 * pi);
                  double normEnd = endAngle % (2 * pi);

                  bool inside = false;
                  if (normEnd < normStart) {
                    inside = angle >= normStart || angle <= normEnd;
                  } else {
                    inside = angle >= normStart && angle <= normEnd;
                  }

                  if (inside) {
                    tappedIndex = i;
                    break;
                  }
                  startAngle = endAngle;
                }

                if (tappedIndex != null) {
                  setState(() {
                    _selectedSliceIndex = (_selectedSliceIndex == tappedIndex)
                        ? null
                        : tappedIndex;
                  });
                  if (_selectedSliceIndex != null) {
                    widget.onSliceTapped?.call(
                      widget.slices[_selectedSliceIndex!],
                    );
                  }
                } else {
                  setState(() {
                    _selectedSliceIndex = null;
                  });
                }
              },
              child: SizedBox(
                width: 100,
                height: 100,
                child: CustomPaint(
                  painter: DonutChartPainter(
                    slices: widget.slices,
                    strokeWidth: 16.0,
                  ),
                ),
              ),
            ),
            // Center text
            GestureDetector(
              onTap: widget.onVisualTapped,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.centerCount,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F2C59),
                      fontFamily: 'BricolageGrotesque',
                    ),
                  ),
                  Text(
                    widget.centerLabel,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF8C9BA5),
                      fontFamily: 'BricolageGrotesque',
                    ),
                  ),
                ],
              ),
            ),
            // Tooltip bubble positioned dynamically
            if (selectedIndex != null &&
                tooltipX != null &&
                tooltipY != null &&
                selectedSlice != null)
              Positioned(
                left: tooltipX - 50,
                top: tooltipY - 60,
                child: _buildDonutTooltipBubble(selectedSlice),
              ),
          ],
        ),
        const SizedBox(width: 20),
        // Legend of slices
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.slices.asMap().entries.map((entry) {
              final int idx = entry.key;
              final slice = entry.value;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSliceIndex = (_selectedSliceIndex == idx)
                        ? null
                        : idx;
                  });
                  if (_selectedSliceIndex != null) {
                    widget.onSliceTapped?.call(slice);
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: slice.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${slice.label} ${slice.value.toInt()}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF5A6A85),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'BricolageGrotesque',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDonutTooltipBubble(DonutSlice slice) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF262626),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                slice.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BricolageGrotesque',
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: slice.color,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${slice.label}: ${slice.value.toInt()}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'BricolageGrotesque',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Downward Arrow pointing to the slice
        Transform.translate(
          offset: const Offset(0, -1),
          child: Transform.rotate(
            angle: pi / 4,
            child: Container(
              width: 8,
              height: 8,
              color: const Color(0xFF262626),
            ),
          ),
        ),
      ],
    );
  }
}

class DonutSlice {
  final String label;
  final double value;
  final Color color;

  DonutSlice(this.label, this.value, this.color);
}

class DonutChartPainter extends CustomPainter {
  final List<DonutSlice> slices;
  final double strokeWidth;

  DonutChartPainter({required this.slices, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);
    final Rect rect = Rect.fromCircle(
      center: center,
      radius: radius - strokeWidth / 2,
    );

    double startAngle = -pi / 2; // Start from top (-90 degrees)
    double total = 0;
    for (var slice in slices) {
      total += slice.value;
    }

    if (total == 0) {
      // Draw background gray/peach circle if total is 0
      final paint = Paint()
        ..color = const Color(0xFFF8C8A5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawArc(rect, 0, 2 * pi, false, paint);
      return;
    }

    for (var slice in slices) {
      if (slice.value == 0) continue;
      final double sweepAngle = 2 * pi * (slice.value / total);
      final paint = Paint()
        ..color = slice.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
