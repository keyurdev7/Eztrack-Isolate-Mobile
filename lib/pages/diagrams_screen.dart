import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eztrack_rental/theme/color.dart';
import 'package:eztrack_rental/controllers/isolate_controller.dart';
import '../widgets/common_app_bar.dart';

class DrawingItem {
  final String filename;
  final String description;
  final String revision;
  final int markupCount;
  final String updatedDate;

  DrawingItem({
    required this.filename,
    required this.description,
    required this.revision,
    required this.markupCount,
    required this.updatedDate,
  });
}

class DiagramsScreen extends StatefulWidget {
  const DiagramsScreen({Key? key}) : super(key: key);

  @override
  _DiagramsScreenState createState() => _DiagramsScreenState();
}

class _DiagramsScreenState extends State<DiagramsScreen> {
  final IsolateController _controller = Get.find<IsolateController>();

  final List<DrawingItem> _drawings = [
    DrawingItem(
      filename: "22A0102D01.DWG",
      description: "HGO Pumparound & Feed Exchanger Loop",
      revision: "Rev. 4 (Active)",
      markupCount: 8,
      updatedDate: "June 12, 2026",
    ),
    DrawingItem(
      filename: "22A0102D02.DWG",
      description: "Coker Column Top Reflux Line",
      revision: "Rev. 2",
      markupCount: 3,
      updatedDate: "May 28, 2026",
    ),
    DrawingItem(
      filename: "01A0105A11.DWG",
      description: "Crude Unit Suction & Discharge manifold",
      revision: "Rev. 5 (Active)",
      markupCount: 5,
      updatedDate: "June 20, 2026",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: const CommonAppBar(
        userName: "",
        greeting: "P&ID Diagrams",
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Project Drawing Sheets',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: mainTextColor,
                  fontFamily: 'BricolageGrotesque',
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Select a DWG file to view interactive isolation and blind markups.',
                style: TextStyle(
                  fontSize: 13,
                  color: lightTextColor,
                  fontFamily: 'BricolageGrotesque',
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _drawings.length,
                  itemBuilder: (context, index) {
                    final drawing = _drawings[index];
                    return _buildDrawingCard(drawing);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawingCard(DrawingItem drawing) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.picture_as_pdf_outlined, color: primary, size: 24),
        ),
        title: Text(
          drawing.filename,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: mainTextColor,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              drawing.description,
              style: TextStyle(
                fontSize: 12,
                color: lightTextColor,
                fontFamily: 'BricolageGrotesque',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildCardBadge(drawing.revision, Colors.grey.shade100, lightTextColor),
                const SizedBox(width: 8),
                _buildCardBadge(
                  '${drawing.markupCount} Markups',
                  Colors.green.shade50,
                  Colors.green.shade700,
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.open_in_new, size: 18, color: primary),
        onTap: () {
          Get.to(() => BlueprintViewerScreen(drawing: drawing));
        },
      ),
    );
  }

  Widget _buildCardBadge(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
          fontFamily: 'BricolageGrotesque',
        ),
      ),
    );
  }
}

class BlueprintViewerScreen extends StatefulWidget {
  final DrawingItem drawing;

  const BlueprintViewerScreen({Key? key, required this.drawing}) : super(key: key);

  @override
  State<BlueprintViewerScreen> createState() => _BlueprintViewerScreenState();
}

class _BlueprintViewerScreenState extends State<BlueprintViewerScreen> {
  String? _selectedTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark blue/slate background for blueprint style
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.drawing.filename,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'BricolageGrotesque',
              ),
            ),
            Text(
              widget.drawing.description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontFamily: 'BricolageGrotesque',
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Blueprint vector canvas with zoom and pan
          InteractiveViewer(
            maxScale: 5.0,
            minScale: 0.5,
            boundaryMargin: const EdgeInsets.all(100),
            child: Center(
              child: AspectRatio(
                aspectRatio: 1.5,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF020617), // Deep space black
                    border: Border.all(color: const Color(0xFF334155), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 20,
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Vector blueprint drawings (pipes, valves, exchangers)
                      CustomPaint(
                        painter: BlueprintPainter(
                          selectedTag: _selectedTag,
                          onTagSelected: (tag) {
                            setState(() {
                              _selectedTag = tag;
                            });
                          },
                        ),
                        child: Container(),
                      ),
                      // Clickable Tag Hotspots overlay
                      Positioned(
                        left: 120,
                        top: 140,
                        child: _buildClickableTag('#226', 'Valve #226 (Installed)'),
                      ),
                      Positioned(
                        left: 280,
                        top: 140,
                        child: _buildClickableTag('#225', 'Valve #225 (Confirmed)'),
                      ),
                      Positioned(
                        left: 180,
                        top: 220,
                        child: _buildClickableTag('B-226-1', 'Blind B-226-1 (Installed)'),
                      ),
                      Positioned(
                        left: 360,
                        top: 80,
                        child: _buildClickableTag('#7', 'Valve #7 (Installed)'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Selection details panel floating at bottom
          if (_selectedTag != null)
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: _buildDetailsPanel(),
            ),
        ],
      ),
    );
  }

  Widget _buildClickableTag(String tag, String label) {
    final isSelected = _selectedTag == tag;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTag = isSelected ? null : tag;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? primary : const Color(0xFF1E293B).withOpacity(0.8),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Markup Details: $_selectedTag',
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
                    _selectedTag = null;
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
              _buildPanelDetail('Status', _selectedTag!.contains('B-') ? 'Installed (Blind)' : 'Installed/Confirmed (Valve)'),
              const SizedBox(width: 20),
              _buildPanelDetail('TWR Ref.', 'T-01P-001'),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _selectedTag!.contains('B-') 
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

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Drawing Navigation', style: TextStyle(color: Colors.white, fontFamily: 'BricolageGrotesque')),
        content: const Text(
          'Pinch to zoom, double tap to reset, or drag to pan around the drawing sheet.\n\nTap on highlighted red tag boxes to display details about that isolation point.',
          style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4, fontFamily: 'BricolageGrotesque'),
        ),
        actions: [
          TextButton(
            child: const Text('Got it', style: TextStyle(color: primary)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

// Vector Blueprint painter drawing pipes, lines, grid and schematic symbols
class BlueprintPainter extends CustomPainter {
  final String? selectedTag;
  final Function(String) onTagSelected;

  BlueprintPainter({this.selectedTag, required this.onTagSelected});

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
      ..color = const Color(0xFF38BDF8) // Light blue pipe lines
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final dashPaint = Paint()
      ..color = const Color(0xFF64748B)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // 2. Draw Pipes (Main Process flow lines)
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

    // 3. Draw Exchangers / Vessels (Vessel 22E-3)
    final vesselPaint = Paint()
      ..color = const Color(0xFF64748B)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Heat Exchanger Shell
    canvas.drawRect(const Rect.fromLTWH(180, 110, 100, 80), vesselPaint);
    // Draw internal tube bundle line (zig-zag)
    final zigPath = Path()
      ..moveTo(180, 150)
      ..lineTo(200, 130)
      ..lineTo(220, 170)
      ..lineTo(240, 130)
      ..lineTo(260, 170)
      ..lineTo(280, 150);
    canvas.drawPath(zigPath, pipePaint);

    // Text Labels
    const textStyle = TextStyle(
      color: Color(0xFF94A3B8),
      fontSize: 10,
      fontWeight: FontWeight.bold,
      fontFamily: 'BricolageGrotesque',
    );
    
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Label 22E-3 Exchanger
    textPainter.text = const TextSpan(text: 'HE-22E-3', style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, const Offset(195, 115));

    // Label Feed In
    textPainter.text = const TextSpan(text: 'HGO INLET', style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, const Offset(30, 132));

    // Label Feed Out
    textPainter.text = const TextSpan(text: 'OUTLET TO COLUMN', style: style);
    textPainter.layout();
    textPainter.paint(canvas, const Offset(430, 72));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

const style = TextStyle(
  color: Color(0xFF94A3B8),
  fontSize: 10,
  fontWeight: FontWeight.bold,
  fontFamily: 'BricolageGrotesque',
);
