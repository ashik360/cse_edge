import 'package:flutter/material.dart';

class DocumentViewerPage extends StatefulWidget {
  const DocumentViewerPage({
    required this.title,
    required this.courseCode,
    this.isPdf = true,
    super.key,
  });

  final String title;
  final String courseCode;
  final bool isPdf;

  @override
  State<DocumentViewerPage> createState() => _DocumentViewerPageState();
}

class _DocumentViewerPageState extends State<DocumentViewerPage> {
  double _zoomLevel = 1.0;
  int _currentPage = 1;
  final int _totalPages = 24; // Mock data for total pages

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: const TextStyle(fontSize: 16)),
            Text(widget.courseCode, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.download_rounded)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_add_outlined)),
        ],
      ),
      body: Column(
        children: [
          // Toolbar for Zoom and Navigation
          _buildReaderToolbar(),
          
          Expanded(
            child: GestureDetector(
              onScaleUpdate: (details) {
                setState(() {
                  _zoomLevel = details.scale.clamp(1.0, 3.0);
                });
              },
              child: SingleChildScrollView(
                child: Center(
                  child: Transform.scale(
                    scale: _zoomLevel,
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(24),
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "LECTURE NOTES: ${widget.title}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const Divider(height: 32),
                          const Text(
                            "Key Topics Covered:\n"
                            "• Understanding the core architecture.\n"
                            "• Logic implementation and memory management.\n"
                            "• Expected exam questions from this section.\n\n"
                            "Detailed Explanation:\n"
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                            "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
                            "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris "
                            "nisi ut aliquip ex ea commodo consequat...",
                            style: TextStyle(fontSize: 16, height: 1.6),
                          ),
                          // Placeholder for diagrams
                          Container(
                            height: 150,
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade100),
                            ),
                            child: const Center(child: Icon(Icons.account_tree_outlined, size: 50, color: Colors.blue)),
                          ),
                          const Text(
                            "Formula Recap:\n"
                            "F = m * a\n"
                            "E = mc²\n",
                            style: TextStyle(fontFamily: 'monospace', fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildPageIndicator(),
    );
  }

  Widget _buildReaderToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.zoom_in, size: 20),
              const SizedBox(width: 8),
              Text("${(_zoomLevel * 100).toInt()}%"),
            ],
          ),
          const Text("Night Mode Off", style: TextStyle(fontSize: 12)),
          const Icon(Icons.search, size: 20),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back_ios)),
            Text("Page $_currentPage of $_totalPages", style: const TextStyle(fontWeight: FontWeight.bold)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward_ios)),
          ],
        ),
      ),
    );
  }
}