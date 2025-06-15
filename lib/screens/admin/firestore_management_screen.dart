import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/firestore_bulk_delete_service.dart';

class FirestoreManagementScreen extends StatefulWidget {
  const FirestoreManagementScreen({super.key});

  @override
  State<FirestoreManagementScreen> createState() =>
      _FirestoreManagementScreenState();
}

class _FirestoreManagementScreenState extends State<FirestoreManagementScreen> {
  final FirestoreBulkDeleteService _deleteService =
      FirestoreBulkDeleteService.instance;

  bool _isLoading = false;
  Map<String, dynamic>? _databaseOverview;
  Map<String, dynamic>? _lastOperationResult;
  List<String> _selectedCollections = [];
  bool _confirmationChecked = false;

  @override
  void initState() {
    super.initState();
    _loadDatabaseOverview();
  }

  Future<void> _loadDatabaseOverview() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final overview = await _deleteService.getDatabaseOverview();
      setState(() {
        _databaseOverview = overview;
      });
    } catch (e) {
      _showErrorDialog('Failed to load database overview: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Firestore Management',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWarningCard(),
                  const SizedBox(height: 20),
                  _buildDatabaseOverview(),
                  const SizedBox(height: 20),
                  _buildCollectionSelector(),
                  const SizedBox(height: 20),
                  _buildConfirmationSection(),
                  const SizedBox(height: 20),
                  _buildActionButtons(),
                  if (_lastOperationResult != null) ...[
                    const SizedBox(height: 20),
                    _buildResultDisplay(),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildWarningCard() {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.warning, color: Colors.red[700], size: 48),
            const SizedBox(height: 12),
            Text(
              'DANGER ZONE',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This tool can permanently delete all data from your Firestore database. '
              'This action cannot be undone. Please proceed with extreme caution.',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.red[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatabaseOverview() {
    if (_databaseOverview == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Failed to load database overview'),
        ),
      );
    }

    final collections = _databaseOverview!['collections'] as List? ?? [];
    final totalDocs = _databaseOverview!['total_documents'] as int? ?? 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.storage, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  'Database Overview',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _loadDatabaseOverview,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Total Collections: ${collections.length}',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            Text(
              'Total Documents: $totalDocs',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ...collections.map(
              (collection) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.folder, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      collection['name'],
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    const Spacer(),
                    Text(
                      '${collection['document_count']} docs',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionSelector() {
    if (_databaseOverview == null) return const SizedBox.shrink();

    final collections = _databaseOverview!['collections'] as List? ?? [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Collections to Delete',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedCollections = collections
                          .map((c) => c['name'] as String)
                          .toList();
                    });
                  },
                  child: const Text('Select All'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedCollections.clear();
                    });
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...collections.map((collection) {
              final name = collection['name'] as String;
              final count = collection['document_count'] as int;
              return CheckboxListTile(
                title: Text(name),
                subtitle: Text('$count documents'),
                value: _selectedCollections.contains(name),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedCollections.add(name);
                    } else {
                      _selectedCollections.remove(name);
                    }
                  });
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationSection() {
    return Card(
      color: Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirmation Required',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.orange[700],
              ),
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              title: Text(
                'I understand that this action will permanently delete all selected data and cannot be undone',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              value: _confirmationChecked,
              onChanged: (bool? value) {
                setState(() {
                  _confirmationChecked = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _selectedCollections.isNotEmpty
                    ? () => _performOperation(dryRun: true)
                    : null,
                icon: const Icon(Icons.preview),
                label: const Text('Dry Run (Preview)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed:
                    _selectedCollections.isNotEmpty && _confirmationChecked
                    ? () => _performOperation(dryRun: false)
                    : null,
                icon: const Icon(Icons.delete_forever),
                label: const Text('DELETE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _confirmationChecked
                ? () => _deleteAllCollections(dryRun: false)
                : null,
            icon: const Icon(Icons.delete_sweep),
            label: const Text('DELETE ALL COLLECTIONS'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[900],
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultDisplay() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Operation Result',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _formatResult(_lastOperationResult!),
                style: GoogleFonts.robotoMono(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performOperation({required bool dryRun}) async {
    if (_selectedCollections.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _deleteService.deleteSpecificCollections(
        _selectedCollections,
        dryRun: dryRun,
      );

      setState(() {
        _lastOperationResult = result;
      });

      if (!dryRun) {
        await _loadDatabaseOverview();
        setState(() {
          _selectedCollections.clear();
          _confirmationChecked = false;
        });
      }
    } catch (e) {
      _showErrorDialog('Operation failed: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteAllCollections({required bool dryRun}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _deleteService.deleteAllDocumentsFromAllCollections(
        dryRun: dryRun,
      );

      setState(() {
        _lastOperationResult = result;
      });

      if (!dryRun) {
        await _loadDatabaseOverview();
        setState(() {
          _selectedCollections.clear();
          _confirmationChecked = false;
        });
      }
    } catch (e) {
      _showErrorDialog('Operation failed: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatResult(Map<String, dynamic> result) {
    final buffer = StringBuffer();
    buffer.writeln('Operation: ${result['operation'] ?? 'Unknown'}');
    buffer.writeln('Dry Run: ${result['dry_run'] ?? false}');
    buffer.writeln('Total Deleted: ${result['total_deleted'] ?? 0}');
    buffer.writeln('Total Errors: ${result['total_errors'] ?? 0}');

    if (result['collections_processed'] != null) {
      buffer.writeln('\nCollections:');
      for (final collection in result['collections_processed']) {
        buffer.writeln(
          '  ${collection['collection']}: ${collection['deleted_count']} docs',
        );
      }
    }

    return buffer.toString();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
