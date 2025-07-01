import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../providers/auth_provider.dart';
import '../../providers/document_provider.dart';
import '../../providers/user_provider.dart';
import '../../services/user_sync_service.dart';
import '../../core/constants/app_colors.dart';

/// Enhanced Admin Dashboard with unlimited query capabilities
class EnhancedAdminDashboard extends StatefulWidget {
  const EnhancedAdminDashboard({super.key});

  @override
  State<EnhancedAdminDashboard> createState() => _EnhancedAdminDashboardState();
}

class _EnhancedAdminDashboardState extends State<EnhancedAdminDashboard> {
  bool _isLoading = false;
  Map<String, dynamic> _statistics = {};
  String? _errorMessage;

  // OPTIMIZATION: Add caching for statistics to prevent unnecessary reloads
  DateTime? _lastStatisticsLoad;
  static const Duration _statisticsCacheDuration = Duration(minutes: 3);

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  /// Load statistics with intelligent caching to prevent unnecessary Firebase calls
  Future<void> _loadStatistics() async {
    // Check if we have recent statistics data
    if (_lastStatisticsLoad != null &&
        DateTime.now().difference(_lastStatisticsLoad!) <
            _statisticsCacheDuration &&
        _statistics.isNotEmpty) {
      debugPrint('📊 Using cached admin statistics');
      return; // Use cached data
    }

    if (_isLoading) return; // Prevent multiple simultaneous calls

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );
      final stats = await documentProvider.getDocumentStatistics();

      if (mounted) {
        setState(() {
          _statistics = stats;
          _lastStatisticsLoad = DateTime.now();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, DocumentProvider>(
      builder: (context, authProvider, documentProvider, child) {
        return FutureBuilder<bool>(
          future: authProvider.isCurrentUserAdmin,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || !snapshot.data!) {
              return _buildAccessDenied();
            }

            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Enhanced Admin Dashboard',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _loadStatistics,
                    tooltip: 'Refresh Statistics',
                  ),
                ],
              ),
              body: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                  ? _buildErrorState()
                  : _buildDashboardContent(authProvider, documentProvider),
            );
          },
        );
      },
    );
  }

  Widget _buildAccessDenied() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Access Denied',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'Admin Access Required',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You need administrator privileges to access this dashboard.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(
            'Error Loading Dashboard',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage ?? 'Unknown error occurred',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadStatistics,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(
    AuthProvider authProvider,
    DocumentProvider documentProvider,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCapabilitiesCard(authProvider),
          const SizedBox(height: 16),
          _buildStatisticsCard(),
          const SizedBox(height: 16),
          _buildActionsCard(documentProvider),
        ],
      ),
    );
  }

  Widget _buildCapabilitiesCard(AuthProvider authProvider) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Admin Capabilities',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            FutureBuilder<bool>(
              future: authProvider.canPerformUnlimitedQueries(),
              builder: (context, snapshot) {
                return _buildCapabilityItem(
                  'Unlimited Queries',
                  snapshot.data ?? false,
                  Icons.all_inclusive,
                );
              },
            ),
            FutureBuilder<bool>(
              future: authProvider.canAccessStorageManagement(),
              builder: (context, snapshot) {
                return _buildCapabilityItem(
                  'Storage Management',
                  snapshot.data ?? false,
                  Icons.storage,
                );
              },
            ),
            FutureBuilder<bool>(
              future: authProvider.canManageUsers(),
              builder: (context, snapshot) {
                return _buildCapabilityItem(
                  'User Management',
                  snapshot.data ?? false,
                  Icons.people,
                );
              },
            ),
            FutureBuilder<bool>(
              future: authProvider.canViewAnalytics(),
              builder: (context, snapshot) {
                return _buildCapabilityItem(
                  'Analytics Access',
                  snapshot.data ?? false,
                  Icons.analytics,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCapabilityItem(String title, bool enabled, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: enabled ? Colors.green : Colors.grey),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: enabled ? Colors.green.shade700 : Colors.grey.shade600,
            ),
          ),
          const Spacer(),
          Icon(
            enabled ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: enabled ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'System Statistics',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            if (_statistics.isEmpty)
              const Text('No statistics available')
            else
              ..._buildStatisticsItems(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStatisticsItems() {
    final items = <Widget>[];

    // Firestore statistics
    if (_statistics['firestore'] != null) {
      final firestoreStats = _statistics['firestore'] as Map<String, dynamic>;
      items.add(
        _buildStatItem(
          'Firestore Documents',
          firestoreStats['total']?.toString() ?? '0',
        ),
      );
    }

    // Storage statistics
    if (_statistics['storage'] != null) {
      final storageStats = _statistics['storage'] as Map<String, dynamic>;
      items.add(
        _buildStatItem(
          'Storage Files',
          storageStats['totalFiles']?.toString() ?? '0',
        ),
      );
      items.add(
        _buildStatItem(
          'Storage Size',
          _formatBytes(storageStats['totalSize'] ?? 0),
        ),
      );
    }

    // Local statistics
    if (_statistics['local'] != null) {
      final localStats = _statistics['local'] as Map<String, dynamic>;
      items.add(
        _buildStatItem(
          'Local Documents',
          localStats['totalDocuments']?.toString() ?? '0',
        ),
      );
      items.add(
        _buildStatItem(
          'Filtered Documents',
          localStats['filteredDocuments']?.toString() ?? '0',
        ),
      );
      items.add(
        _buildStatItem(
          'Categories',
          localStats['categories']?.toString() ?? '0',
        ),
      );
    }

    return items;
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 14)),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsCard(DocumentProvider documentProvider) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Admin Actions',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              'Load All Documents (Unlimited)',
              Icons.download,
              () => documentProvider.loadAllDocumentsUnlimited(),
            ),
            _buildActionButton(
              'Sync Storage Files',
              Icons.sync,
              () => documentProvider.loadDocumentsFromStorageUnlimited(),
            ),
            _buildActionButton(
              'Refresh Download URLs',
              Icons.refresh,
              () => documentProvider.refreshAllDownloadUrls(),
            ),
            _buildActionButton(
              'Refresh Statistics',
              Icons.analytics,
              _loadStatistics,
            ),
            _buildActionButton(
              'Sync Firebase Auth Users',
              Icons.people_alt,
              _syncFirebaseAuthUsers,
            ),
            _buildActionButton(
              'Clear Cache & Reload',
              Icons.cached,
              _clearCacheAndReload,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(title),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  void _syncFirebaseAuthUsers() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Syncing Firebase Auth users...'),
          backgroundColor: AppColors.primary,
        ),
      );

      final userSyncService = UserSyncService.instance;
      final result = await userSyncService.manualSync();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'User sync completed'),
            backgroundColor: result['success'] == true
                ? AppColors.success
                : AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _clearCacheAndReload() async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Clearing phantom files and cache...'),
          backgroundColor: AppColors.primary,
        ),
      );

      // Get providers
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // ENHANCED: Clear all phantom file cache first
      await documentProvider.clearAllCache();

      // Reload document data from Storage only
      await documentProvider.loadAllDocumentsUnlimited();
      await documentProvider.loadDocumentsFromStorageUnlimited();

      // Reload user data
      await userProvider.loadUsers();

      // Reload statistics
      await _loadStatistics();

      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Phantom files cleared! Only real files from Storage shown',
          backgroundColor: AppColors.success,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Error clearing cache: ${e.toString()}',
          backgroundColor: AppColors.error,
          textColor: Colors.white,
        );
      }
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
