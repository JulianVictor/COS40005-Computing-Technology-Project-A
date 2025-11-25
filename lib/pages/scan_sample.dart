import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_first_app/pages/labour_cost.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'sample_result.dart';

class ScanSamplePage extends StatefulWidget {
  final int sampleNumber;
  const ScanSamplePage({super.key, this.sampleNumber = 1});

  @override
  State<ScanSamplePage> createState() => _ScanSamplePageState();
}

class _ScanSamplePageState extends State<ScanSamplePage> {
  final Color purple = const Color(0xFF2D108E);

  late int sampleNumber;
  double average = 0;
  int cumulative = 0;
  double eil = 1.50;

  // Each pod now holds List of images and total egg count
  final List<List<File>> _podImages = List.generate(5, (_) => <File>[]);
  final List<int> podResults = List.filled(5, 0);
  final Map<int, bool> _isProcessing = {};

  final ImagePicker _picker = ImagePicker();
  Interpreter? _interpreter;

  @override
  void initState() {
    super.initState();
    sampleNumber = widget.sampleNumber;
    _loadModel();
  }

  // ==============================================
  // 1. LOAD MODEL
  // ==============================================
  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('lib/models/yolo11float32.tflite');
      debugPrint('Model loaded: 640x640 → 5x8400');
    } catch (e) {
      debugPrint('Model load failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load AI model: $e')),
        );
      }
    }
  }

  // ==============================================
  // 2. PREPROCESS
  // ==============================================
  Future<Float32List?> _preprocess(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: 640,
        targetHeight: 640,
      );
      final frame = await codec.getNextFrame();
      final img = frame.image;

      final byteData = await img.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (byteData == null) return null;

      final rgba = byteData.buffer.asUint8List();
      final rgb = Float32List(640 * 640 * 3);
      for (int i = 0, j = 0; i < rgba.length; i += 4, j += 3) {
        rgb[j]     = rgba[i] / 255.0;
        rgb[j + 1] = rgba[i + 1] / 255.0;
        rgb[j + 2] = rgba[i + 2] / 255.0;
      }
      return rgb;
    } catch (e) {
      debugPrint('Preprocess error: $e');
      return null;
    }
  }

  // ==============================================
  // 3. RUN INFERENCE ON SINGLE IMAGE
  // ==============================================
  Future<int> _runInference(File file) async {
    if (_interpreter == null) return 0;

    final input = await _preprocess(file);
    if (input == null) return 0;

    final inputBatch = input.reshape([1, 640, 640, 3]);
    final output = List.filled(1 * 5 * 8400, 0.0).reshape([1, 5, 8400]);

    _interpreter!.run(inputBatch, output);

    final raw = (output[0] as List).cast<List<double>>();
    final pred = Float32List(5 * 8400);
    for (int c = 0; c < 5; c++) {
      for (int i = 0; i < 8400; i++) {
        pred[c * 8400 + i] = 1.0 / (1.0 + math.exp(-raw[c][i]));
      }
    }

    return _countEggs(pred);
  }

  int _countEggs(Float32List pred) {
    const double confThres = 0.15;
    const double iouThres = 0.35;

    final List<List<double>> boxes = [];
    final List<double> scores = [];

    for (int i = 0; i < 8400; i++) {
      final conf = pred[4 * 8400 + i];
      if (conf > confThres) {
        boxes.add([
          pred[0 * 8400 + i],
          pred[1 * 8400 + i],
          pred[2 * 8400 + i],
          pred[3 * 8400 + i],
        ]);
        scores.add(conf);
      }
    }

    if (boxes.isEmpty) return 0;

    final xyxy = boxes.map((b) => [
      b[0] - b[2] / 2,
      b[1] - b[3] / 2,
      b[0] + b[2] / 2,
      b[1] + b[3] / 2,
    ]).toList();

    final order = List.generate(scores.length, (i) => i)
      ..sort((a, b) => scores[b].compareTo(scores[a]));
    final keep = <int>[];
    final suppressed = List.filled(scores.length, false);

    for (final i in order) {
      if (suppressed[i]) continue;
      keep.add(i);
      for (int j = 0; j < order.length; j++) {
        final k = order[j];
        if (suppressed[k] || k == i) continue;
        if (_iou(xyxy[i], xyxy[k]) > iouThres) {
          suppressed[k] = true;
        }
      }
    }

    return keep.length;
  }

  double _iou(List<double> a, List<double> b) {
    final x1 = math.max(a[0], b[0]);
    final y1 = math.max(a[1], b[1]);
    final x2 = math.min(a[2], b[2]);
    final y2 = math.min(a[3], b[3]);
    final inter = math.max(0.0, x2 - x1) * math.max(0.0, y2 - y1);
    final areaA = (a[2] - a[0]) * (a[3] - a[1]);
    final areaB = (b[2] - b[0]) * (b[3] - b[1]);
    return inter / (areaA + areaB - inter + 1e-6);
  }

  // ==============================================
  // 4. ADD PHOTO TO POD → RUN AI ON ALL
  // ==============================================
  Future<void> _addPhotoToPod(int podIndex) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () => Navigator.pop(context, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from Gallery'),
              onTap: () => Navigator.pop(context, 'gallery'),
            ),
          ],
        ),
      ),
    );

    if (action == null) return;

    final xFile = await _picker.pickImage(
      source: action == 'camera' ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 90,
    );
    if (xFile == null) return;

    final file = File(xFile.path);

    setState(() {
      _podImages[podIndex].add(file);
      _isProcessing[podIndex] = true;
    });

    // Run AI on this new image
    final count = await _runInference(file);

    setState(() {
      podResults[podIndex] += count;  // Add to total
      _isProcessing[podIndex] = false;
      _updateResults();
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pod ${podIndex + 1}: +$count egg${count == 1 ? "" : "s"} (Total: ${podResults[podIndex]})'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // ==============================================
  // 5. UPDATE CUMULATIVE & AVERAGE
  // ==============================================
  void _updateResults() {
    cumulative = podResults.reduce((a, b) => a + b);
    average = cumulative / podResults.length;
  }

  // ==============================================
  // 6. UI: POD WITH MULTIPLE THUMBNAILS
  // ==============================================
  @override
  Widget build(BuildContext context) {
    bool treat = average >= eil;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LabourCostPage()),
            );
          },
        ),
        centerTitle: true,
        title: const Text("Sampling Result", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: purple, width: 1),
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.black),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('dd MMM yyyy').format(DateTime.now()),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            _label("Sample"), _readonlyBox(sampleNumber.toString()),
            _label("Cumulative No. of CPB Eggs"), _readonlyBox(cumulative.toString()),
            _label("Average CPB Eggs/Sample"), _readonlyBox(average.toStringAsFixed(2)),

            _label("Number of CPB Eggs/Pod"),
            const SizedBox(height: 8),

            // 5 Pods
            ...List.generate(5, (i) {
              final images = _podImages[i];
              final count = podResults[i];
              final loading = _isProcessing[i] == true;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (i > 0) const SizedBox(height: 12),
                  Text("Pod ${i + 1}", style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => _addPhotoToPod(i),
                    child: Container(
                      height: 80,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[50],
                      ),
                      child: Row(
                        children: [
                          // Thumbnails
                          Expanded(
                            child: images.isEmpty
                                ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo_outlined, size: 28, color: Colors.grey),
                                  Text("Add Photo", style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            )
                                : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: images.length,
                              itemBuilder: (context, idx) => Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(images[idx], width: 60, height: 60, fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),

                          // Count Badge
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: count > 0 ? Colors.green : Colors.grey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                '$count',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),

                          // Loading
                          if (loading)
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.purple),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),

            const SizedBox(height: 30),
            const Text("Decision:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sample $sampleNumber", style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      treat ? "Treat" : "Continue taking sample",
                      style: TextStyle(color: treat ? Colors.red : Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(cumulative.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      average.toStringAsFixed(2),
                      style: TextStyle(color: treat ? Colors.red : Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _bottomButton("Previous", purple, () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LabourCostPage()),
                  );
                }),
                const SizedBox(width: 10),
                _bottomButton("Submit", purple, () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SampleResultPage(
                        scanData: {
                          "totalEggs": cumulative > 0 ? cumulative : 0,
                          "average": cumulative > 0 ? average : 0.0,
                          "decision": cumulative > 0
                              ? (average >= eil ? "TREAT" : "Continue taking sample")
                              : "-",
                          "pods": podResults,
                        },
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(top: 14, bottom: 6),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
  );

  Widget _readonlyBox(String value) {
    return TextField(
      readOnly: true,
      controller: TextEditingController(text: value)..selection = TextSelection.fromPosition(TextPosition(offset: value.length)),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
    );
  }

  Widget _bottomButton(String text, Color color, VoidCallback onTap) {
    return Expanded(
      child: SizedBox(
        height: 45,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
          onPressed: onTap,
          child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }
}