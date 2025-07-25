import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl; 
  const PdfViewerScreen({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _totalPages = 0;
  int _currentPage = 0;
  String? _localFilePath; 
  bool _isLoading = true; 

  @override
  void initState() {
    super.initState();
    _downloadAndOpenPdf();
  }

  Future<void> _downloadAndOpenPdf() async {
    try {
      
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = '${tempDir.path}/downloaded.pdf';

      final Dio dio = Dio();
      await dio.download(widget.pdfUrl, filePath);

      
      setState(() {
        _localFilePath = filePath;
        _isLoading = false; 
      });

      
      _startAutoScroll();
    } catch (e) {
      
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load PDF: $e')),
      );
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      int nextPage = _currentPage + 1;

      if (nextPage >= _totalPages) {
        _timer?.cancel(); 
      } else {
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
        _currentPage = nextPage;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) 
          : PDFView(
              filePath: _localFilePath,
              fitEachPage: true,
              fitPolicy: FitPolicy.BOTH,
              onRender: (pages) {
                setState(() {
                  _totalPages = pages ?? 0;
                });
              },
              onPageChanged: (page, _) {
                setState(() {
                  _currentPage = page ?? 0;
                });
              },
            ),
    );
  }
}
