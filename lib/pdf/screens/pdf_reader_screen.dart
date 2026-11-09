
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../models/pdf_book_model.dart';
import '../providers/pdf_library_provider.dart';

class PdfReaderScreen extends StatefulWidget {
  final PdfBook pdfBook;

  const PdfReaderScreen({
    super.key,
    required this.pdfBook,
  });

  @override
  State<PdfReaderScreen> createState() => _PdfReaderScreenState();
}

class _PdfReaderScreenState extends State<PdfReaderScreen> {
  final PdfViewerController _pdfController = PdfViewerController();

  late final Future<bool> _fileExistsFuture;

  final ValueNotifier<int> _currentPage = ValueNotifier<int>(1);
  final ValueNotifier<int> _totalPages = ValueNotifier<int>(0);

  bool _isSavingProgress = false;

  @override
  void initState() {
    super.initState();

    _currentPage.value = widget.pdfBook.lastReadPage;

    final pdfFile = File(widget.pdfBook.filePath);
    _fileExistsFuture = pdfFile.exists();
  }

  Future<void> _saveReadingProgress(int page) async {
    if (_isSavingProgress) return;

    _isSavingProgress = true;

    try {
      await context.read<PdfLibraryProvider>().updateReadingProgress(
            widget.pdfBook.id,
            page,
          );
    } finally {
      _isSavingProgress = false;
    }
  }

  void _goToPreviousPage() {
    if (_currentPage.value > 1) {
      _pdfController.previousPage();
    }
  }

  void _goToNextPage() {
    if (_currentPage.value < _totalPages.value) {
      _pdfController.nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pdfFile = File(widget.pdfBook.filePath);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pdfBook.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFF8F7F3),
      ),
      body: FutureBuilder<bool>(
        future: _fileExistsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data != true) {
            return const Center(
              child: Text('File PDF tidak ditemukan.'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SfPdfViewer.file(
                  pdfFile,
                  controller: _pdfController,
                  onDocumentLoaded: (details) {
                    _totalPages.value = details.document.pages.count;

                    final lastPage = widget.pdfBook.lastReadPage;

                    if (lastPage > 1 &&
                        lastPage <= _totalPages.value) {
                      _pdfController.jumpToPage(lastPage);
                    }
                  },
                  onPageChanged: (details) {
                    _currentPage.value = details.newPageNumber;

                    _saveReadingProgress(details.newPageNumber);
                  },
                  onDocumentLoadFailed: (details) {
                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Gagal membuka PDF: ${details.error}',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                ),
              ),
              _buildPageNavigation(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPageNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ValueListenableBuilder<int>(
            valueListenable: _currentPage,
            builder: (context, currentPage, child) {
              return IconButton(
                onPressed:
                    currentPage > 1 ? _goToPreviousPage : null,
                icon: const Icon(Icons.chevron_left),
              );
            },
          ),
          ValueListenableBuilder<int>(
            valueListenable: _totalPages,
            builder: (context, totalPages, child) {
              return ValueListenableBuilder<int>(
                valueListenable: _currentPage,
                builder: (context, currentPage, child) {
                  return Text(
                    totalPages > 0
                        ? 'Halaman $currentPage dari $totalPages'
                        : 'Memuat halaman...',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              );
            },
          ),
          ValueListenableBuilder<int>(
            valueListenable: _currentPage,
            builder: (context, currentPage, child) {
              return ValueListenableBuilder<int>(
                valueListenable: _totalPages,
                builder: (context, totalPages, child) {
                  return IconButton(
                    onPressed: currentPage < totalPages
                        ? _goToNextPage
                        : null,
                    icon: const Icon(Icons.chevron_right),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _currentPage.dispose();
    _totalPages.dispose();
    _pdfController.dispose();

    super.dispose();
  }
}
