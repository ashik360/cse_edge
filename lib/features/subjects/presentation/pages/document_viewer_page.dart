import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DocumentViewerPage extends StatefulWidget {
  const DocumentViewerPage({
    required this.title,
    required this.courseCode,
    required this.fileUrl,
    required this.fileType,
    super.key,
  });

  final String title;
  final String courseCode;
  final String fileUrl;
  final String fileType;

  @override
  State<DocumentViewerPage> createState() => _DocumentViewerPageState();
}

class _DocumentViewerPageState extends State<DocumentViewerPage> {
  PdfViewerController? _pdfViewerController;
  int _currentPage = 1;
  int _totalPages = 0;
  double _zoomLevel = 1.0;

  late final WebViewController _webViewController;
  bool _isWebViewReady = false;
  bool _isLoadingWeb = true;

  bool get _isPdf => widget.fileType.toLowerCase() == 'pdf';
  bool get _isDrive => widget.fileType.toLowerCase() == 'drive';
  bool get _isImage {
    final type = widget.fileType.toLowerCase();
    return type == 'image' ||
        type == 'jpg' ||
        type == 'jpeg' ||
        type == 'png' ||
        type == 'webp';
  }

  @override
  void initState() {
    super.initState();

    if (_isPdf) {
      _pdfViewerController = PdfViewerController();
    }

    if (_isDrive) {
      _webViewController =
          WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(
              NavigationDelegate(
                onPageStarted: (_) {
                  if (mounted) {
                    setState(() => _isLoadingWeb = true);
                  }
                },
                onPageFinished: (_) {
                  if (mounted) {
                    setState(() => _isLoadingWeb = false);
                  }
                },
              ),
            )
            ..loadRequest(Uri.parse(widget.fileUrl));

      _isWebViewReady = true;
    }
  }

  Future<void> _openExternally() async {
    final uri = Uri.tryParse(widget.fileUrl);
    if (uri == null) return;

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: const TextStyle(fontSize: 16)),
            Text(
              widget.courseCode,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _openExternally,
            icon: const Icon(Icons.open_in_new_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(child: _buildBody()),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.fileType.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
          ),
          if (_isPdf) Text("Page $_currentPage / $_totalPages", selectionColor: Colors.blue,),
          if (_isDrive) Text(_isLoadingWeb ? "Loading..." : "Google Drive", selectionColor: Colors.blue),
          if (_isImage) Text("${(_zoomLevel * 100).toInt()}%"),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isPdf) {
      return SfPdfViewer.network(
        widget.fileUrl,
        controller: _pdfViewerController,
        onPageChanged: (details) {
          setState(() {
            _currentPage = details.newPageNumber;
          });
        },
        onDocumentLoaded: (details) {
          setState(() {
            _totalPages = details.document.pages.count;
          });
        },
        onZoomLevelChanged: (details) {
          setState(() {
            _zoomLevel = details.newZoomLevel;
          });
        },
      );
    }

    if (_isDrive && _isWebViewReady) {
      return Stack(
        children: [
          WebViewWidget(controller: _webViewController),
          if (_isLoadingWeb)
            const Center(child: CircularProgressIndicator()),
        ],
      );
    }

    if (_isImage) {
      return InteractiveViewer(
        minScale: 1,
        maxScale: 4,
        onInteractionUpdate: (_) {},
        child: Center(
          child: Image.network(
            widget.fileUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Text('Failed to load image'),
              );
            },
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.insert_drive_file_outlined, size: 56),
            const SizedBox(height: 16),
            Text(
              'This file type is not supported in-app yet.\nOpen it externally.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _openExternally,
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open File'),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildBottomBar() {
    if (_isPdf) {
      return BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  _pdfViewerController?.previousPage();
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              Text(
                "Page $_currentPage of $_totalPages",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  _pdfViewerController?.nextPage();
                },
                icon: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ),
      );
    }

    return null;
  }
}