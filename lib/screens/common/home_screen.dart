import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/document_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/file_selection_provider.dart';
import '../../widgets/common/app_bottom_navigation.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/file_filter_widget.dart';
import '../../widgets/common/file_selection_bar.dart';
import '../../models/document_model.dart';

import '../../services/ui_refresh_service.dart';
import '../../services/file_download_service.dart';
import '../../services/share_service.dart';
import '../../services/bulk_operations_service.dart';
import '../../core/services/greeting_service.dart';
import '../../utils/download_location_helper.dart';
import '../../config/firebase_config.dart';
import '../../services/firebase_storage_direct_service.dart';
import '../../core/utils/circuit_breaker.dart';
part 'components/home_greeting_section.dart';
part 'components/home_dashboard_stats.dart';
part 'components/home_search_section.dart';
part 'components/home_file_list_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool _dataLoaded = false;
  final TextEditingController _searchController = TextEditingController();
  final ShareService _shareService = ShareService();
  Timer? _searchTimer;
  Timer? _refreshTimer;
  late GreetingSet _currentGreeting;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateSessionActivity();
    _searchController.addListener(_onSearchChanged);
    _startAutoRefresh();
    _generateNewGreeting();

    // Sync search controller with DocumentProvider on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );
      _searchController.text = documentProvider.searchQuery;
    });

    // CRITICAL FIX: Disable real-time sync service to prevent duplicate listeners
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint(
        '⚠️ Real-time sync service disabled to prevent duplicate listeners and excessive operations',
      );
      // DISABLED: Real-time sync was causing duplicate listeners and excessive Firestore operations
      // if (FirebaseConfig.shouldEnableRealtimeSync) {
      //   RealtimeSyncService.instance.initialize(context);
      //   RealtimeSyncService.instance.startDocumentSync();
      // } else {
      //   debugPrint('Real-time sync disabled in FirebaseConfig');
      // }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    _searchTimer?.cancel();
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Refresh UI when app comes back to foreground (user returns from upload screen)
    if (state == AppLifecycleState.resumed) {
      debugPrint('🔄 App resumed - triggering UI refresh');
      UIRefreshService.refreshAllProviders(context);
    }
  }

  void _startAutoRefresh() {
    // CRITICAL FIX: Disable auto-refresh to prevent excessive background operations
    debugPrint(
      '⚠️ Auto-refresh disabled to prevent excessive Firestore operations',
    );
    return;

    // DISABLED: Auto-refresh was causing excessive document creation
    // Only start auto-refresh if enabled in config
    if (!FirebaseConfig.shouldAutoRefresh) {
      debugPrint('Auto-refresh disabled in FirebaseConfig');
      return;
    }

    // Use configurable refresh interval
    _refreshTimer = Timer.periodic(FirebaseConfig.autoRefreshInterval, (timer) {
      if (mounted) {
        _refreshData();
      }
    });
  }

  void _generateNewGreeting() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userName = authProvider.currentUser?.fullName;
    _currentGreeting = GreetingService.instance.getSmartGreeting(userName);
  }

  Future<void> _refreshData() async {
    try {
      // Reset circuit breakers on manual refresh
      CircuitBreaker.resetAllCircuits();
      debugPrint('🔄 Circuit breakers reset for manual refresh');

      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final categoryProvider = Provider.of<CategoryProvider>(
        context,
        listen: false,
      );

      await Future.wait([
        documentProvider.refreshDocuments(),
        userProvider.refreshUsers(),
        categoryProvider.refreshCategories(),
      ]);

      // Generate new greeting on refresh
      _generateNewGreeting();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      // Silently handle refresh errors to avoid disrupting user experience
      debugPrint('Auto-refresh error: $e');
    }
  }

  /// Handle exit from selection mode - refresh UI without re-fetching data
  void _onExitSelectionMode() {
    try {
      // Only trigger UI refresh using existing cached data
      // No need to re-fetch from server as data hasn't changed
      if (mounted) {
        // Use a brief delay to ensure smooth transition
        Future.microtask(() {
          if (mounted) {
            setState(() {
              // This will rebuild the UI with current cached data
              // The DocumentProvider already has the files in memory
            });
          }
        });
      }
    } catch (e) {
      // Handle any potential errors gracefully
      debugPrint('Error during selection mode exit: $e');
      // Even if there's an error, ensure UI is refreshed
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _onSearchChanged() {
    if (_searchTimer?.isActive ?? false) _searchTimer!.cancel();

    // Perform search immediately if there's at least 1 character or if clearing search
    final searchText = _searchController.text.trim();
    if (searchText.isNotEmpty || searchText.isEmpty) {
      // Use minimal delay for better performance while still preventing excessive calls
      _searchTimer = Timer(const Duration(milliseconds: 100), () {
        _performSearch();
      });
    }
  }

  void _performSearch() {
    final documentProvider = Provider.of<DocumentProvider>(
      context,
      listen: false,
    );
    documentProvider.searchDocuments(_searchController.text.trim());
  }

  // Update session activity when user is active
  void _updateSessionActivity() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.updateSessionActivity();
    });
  }

  Future<void> _loadData() async {
    if (_dataLoaded) return;

    try {
      debugPrint('🏠 Home screen: Starting data load...');
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );
      final categoryProvider = Provider.of<CategoryProvider>(
        context,
        listen: false,
      );

      // ENHANCED: Check if documents are already loaded to avoid unnecessary loading
      if (documentProvider.allDocuments.isEmpty) {
        debugPrint('🏠 Home screen: Documents empty, forcing load...');
      } else {
        debugPrint(
          '🏠 Home screen: ${documentProvider.allDocuments.length} documents already loaded',
        );
      }

      // Load data with proper error handling and immediate UI updates
      await Future.wait([
        userProvider.loadUsers(),
        documentProvider.loadDocuments(),
        categoryProvider.loadCategories(),
      ]);

      debugPrint('🏠 Home screen: Data load completed successfully');
      debugPrint(
        '🏠 Home screen: Final document count: ${documentProvider.allDocuments.length}',
      );

      _dataLoaded = true;

      // Force UI update after data is loaded
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('❌ Home screen: Error loading data: $e');

      // Fallback: Try to load documents individually if batch loading fails
      if (mounted) {
        try {
          final documentProvider = Provider.of<DocumentProvider>(
            context,
            listen: false,
          );
          await documentProvider.loadDocuments();
          debugPrint('🏠 Home screen: Fallback document loading completed');
          _dataLoaded = true;
          if (mounted) {
            setState(() {});
          }
        } catch (fallbackError) {
          debugPrint(
            '🏠 Home screen: Fallback loading also failed: $fallbackError',
          );
          // Still mark as loaded to prevent infinite loading attempts
          _dataLoaded = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.currentUser == null) {
          return const PageLoadingWidget(message: 'Memuat data pengguna...');
        }

        // Load data after user is authenticated
        if (!_dataLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadData();
          });
        }

        // ADDITIONAL TRIGGER: Ensure documents are loaded even if _dataLoaded is true
        // This handles cases where data loading completed but documents are still empty
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final documentProvider = Provider.of<DocumentProvider>(
            context,
            listen: false,
          );
          if (documentProvider.allDocuments.isEmpty &&
              !documentProvider.isLoading) {
            debugPrint(
              '🏠 Home screen: Additional trigger - documents empty, loading...',
            );
            documentProvider.loadDocuments();
          }
        });

        return AppScaffoldWithNavigation(
          title: 'Beranda',
          currentNavIndex: 0, // Home is index 0
          showAppBar: true, // Use standard app bar like other pages
          body: Column(
            children: [
              // File selection bar (appears when files are selected)
              FileSelectionBar(onExitSelection: _onExitSelectionMode),
              // Main dashboard content
              Expanded(child: _buildDashboard()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDashboard() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Get responsive spacing - REDUCED VALUES
        final screenWidth = MediaQuery.of(context).size.width;
        final responsiveSpacing = screenWidth < 400
            ? 8.0
            : 12.0; // Reduced from 12-16

        return RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              color: AppColors.background,
              child: Column(
                children: [
                  SizedBox(
                    height: responsiveSpacing / 1,
                  ), // Reduced top spacing
                  // Greeting Section - Using new component
                  HomeGreetingSection(
                    authProvider: authProvider,
                    currentGreeting: _currentGreeting,
                    onProfileTap: () => _showProfileMenu(authProvider),
                  ),

                  SizedBox(height: responsiveSpacing / 3),

                  // Dashboard Statistics Section (Admin only) - Using new component
                  if (authProvider.isAdmin) ...[
                    const HomeDashboardStats(),
                    SizedBox(height: responsiveSpacing / 3),
                  ],

                  // Search Section - Using new component
                  HomeSearchSection(
                    searchController: _searchController,
                    onSearchChanged: _performSearch,
                  ),

                  SizedBox(
                    height: responsiveSpacing / 12,
                  ), // Reduced spacing before file list
                  // File List Section - Using new component
                  HomeFileListSection(
                    searchQuery: _searchController.text,
                    onDocumentTap: _navigateToFilePreview,
                    onDocumentMenu: _showDocumentMenu,
                    onFilterTap: _showFilterMenu,
                  ),

                  SizedBox(height: responsiveSpacing * 1),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => FileFilterWidget(
        onFilterApplied: () {
          // Sync search controller with DocumentProvider after filter changes
          final documentProvider = Provider.of<DocumentProvider>(
            context,
            listen: false,
          );
          if (_searchController.text != documentProvider.searchQuery) {
            _searchController.text = documentProvider.searchQuery;
          }
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(DocumentModel document) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Delete File',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${document.fileName}"? This action cannot be undone.',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteFile(document);
              },
              child: Text(
                'Delete',
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteFile(DocumentModel document) async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Text('Deleting ${document.fileName}...'),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      // Get current user ID for logging
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentUserId = authProvider.currentUser?.id ?? 'unknown';

      // Get document provider and remove the document permanently
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );
      await documentProvider.removeDocument(document.id, currentUserId);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${document.fileName} deleted permanently from storage',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete file: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Helper methods for document display

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '${bytes}B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)}KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  void _showDocumentMenu(DocumentModel document) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.download),
              title: Text('Download', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pop(context);
                _downloadFile(document);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: Text('Share', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pop(context);
                _shareDocument(document);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(
                'Delete',
                style: GoogleFonts.poppins(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(document);
              },
            ),

            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text('Details', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pop(context);
                _showDocumentDetails(document);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToFilePreview(DocumentModel document) {
    Navigator.of(context).pushNamed(AppRoutes.filePreview, arguments: document);
  }

  void _showDocumentDetails(DocumentModel document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Document Details',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            final user = userProvider.getUserById(document.uploadedBy);
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Name', document.fileName),
                _buildDetailRow('Owner', user?.fullName ?? 'Unknown'),
                _buildDetailRow('Size', _formatFileSize(document.fileSize)),
                _buildDetailRow('Type', document.fileType),
                _buildDetailRow('Uploaded', _formatDate(document.uploadedAt)),
                _buildDetailRow('Status', 'ACTIVE'),
                if (document.metadata.description.isNotEmpty)
                  _buildDetailRow('Description', document.metadata.description),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  // Share document using ShareService
  Future<void> _shareDocument(DocumentModel document) async {
    try {
      // Show loading message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Preparing to share ${document.fileName}...'),
                ),
              ],
            ),
            duration: const Duration(seconds: 5),
            backgroundColor: AppColors.primary,
          ),
        );
      }

      // Share with link (default behavior)
      await _shareService.shareFileWithLink(
        document: document,
        linkExpiration: const Duration(hours: 24),
        customMessage: 'I\'m sharing a document with you from Management Doc:',
      );

      // Hide loading message and show success
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text('Document shared successfully!')),
              ],
            ),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Failed to share document: ${e.toString()}'),
                ),
              ],
            ),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                _shareDocument(document);
              },
            ),
          ),
        );
      }
    }
  }

  // Download file to device storage
  Future<void> _downloadFile(DocumentModel document) async {
    final downloadService = FileDownloadService();

    try {
      // Show initial download message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text('Downloading ${document.fileName}...')),
              ],
            ),
            duration: const Duration(seconds: 30), // Long duration for download
            backgroundColor: AppColors.primary,
          ),
        );
      }

      // Download the file
      await downloadService.downloadFile(
        document,
        onProgress: (progress) {
          // You could update a progress indicator here if needed
          debugPrint(
            'Download progress: ${(progress * 100).toStringAsFixed(1)}%',
          );
        },
      );

      // Show success message with location info
      if (mounted) {
        final locationDescription = await downloadService
            .getDownloadLocationDescription();
        final actualPath = await downloadService.getDownloadDirectoryPath();

        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'File downloaded successfully!',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'File: ${document.fileName}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Location: $locationDescription',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Path: $actualPath',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 8),
              action: SnackBarAction(
                label: 'Find File',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  DownloadLocationHelper.showDownloadLocationInfo(context);
                },
              ),
            ),
          );
        }
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.error, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(child: Text('Download failed')),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  e.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                _downloadFile(document); // Retry download
              },
            ),
          ),
        );
      }
    }
  }

  void _showProfileMenu(AuthProvider authProvider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Custom Profile Header dengan Avatar Besar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40, // Avatar besar dengan radius 40
                    backgroundColor: AppColors.primaryLight,
                    backgroundImage:
                        authProvider.currentUser?.profileImage != null
                        ? NetworkImage(authProvider.currentUser!.profileImage!)
                        : null,
                    child: authProvider.currentUser?.profileImage == null
                        ? Text(
                            authProvider.currentUser?.fullName
                                    .substring(0, 1)
                                    .toUpperCase() ??
                                'U',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 24, // Font size untuk avatar radius 40
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authProvider.currentUser?.fullName ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          authProvider.currentUser?.role.toUpperCase() ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text(AppStrings.profile),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(AppRoutes.profile);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text(AppStrings.settings),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(AppRoutes.settings);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: const Text(
                AppStrings.logout,
                style: TextStyle(color: AppColors.error),
              ),
              onTap: () {
                Navigator.pop(context);
                _logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout();

      if (mounted) {
        // Clear all routes and navigate to login
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.login,
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to logout: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
