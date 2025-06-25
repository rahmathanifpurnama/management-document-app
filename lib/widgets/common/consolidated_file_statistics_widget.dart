import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../models/document_model.dart';
import '../../utils/file_size_formatter.dart';

/// Consolidated file statistics widget with performance optimizations
/// Handles large numbers of files (1000+) with efficient computation
/// and responsive design across all screen sizes
class ConsolidatedFileStatisticsWidget extends StatefulWidget {
  final List<DocumentModel> documents;
  final bool showDetailedStats;
  final bool enableAnimations;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final int maxItemsToProcess; // Performance optimization
  final VoidCallback? onRefresh;
  final String? title;

  const ConsolidatedFileStatisticsWidget({
    super.key,
    required this.documents,
    this.showDetailedStats = true,
    this.enableAnimations = true,
    this.padding,
    this.margin,
    this.maxItemsToProcess = 1000, // Limit for performance
    this.onRefresh,
    this.title,
  });

  @override
  State<ConsolidatedFileStatisticsWidget> createState() =>
      _ConsolidatedFileStatisticsWidgetState();
}

class _ConsolidatedFileStatisticsWidgetState
    extends State<ConsolidatedFileStatisticsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Cached statistics for performance
  Map<String, dynamic>? _cachedStats;
  int _lastDocumentCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _computeStatistics();
  }

  @override
  void didUpdateWidget(ConsolidatedFileStatisticsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only recompute if document count changed significantly
    if (widget.documents.length != _lastDocumentCount) {
      _computeStatistics();
    }
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    if (widget.enableAnimations) {
      _animationController.forward();
    } else {
      _animationController.value = 1.0;
    }
  }

  /// Compute statistics with performance optimization for large datasets
  void _computeStatistics() {
    final documents = widget.documents;
    _lastDocumentCount = documents.length;

    // Performance optimization: limit processing for very large datasets
    final documentsToProcess = documents.length > widget.maxItemsToProcess
        ? documents.take(widget.maxItemsToProcess).toList()
        : documents;

    final stats = <String, dynamic>{};

    // Basic statistics
    stats['totalFiles'] = documents.length;
    stats['processedFiles'] = documentsToProcess.length;
    stats['isLimitedProcessing'] = documents.length > widget.maxItemsToProcess;

    if (documentsToProcess.isEmpty) {
      _cachedStats = stats;
      return;
    }

    // File type distribution
    final fileTypeStats = <String, int>{};
    int totalSize = 0;
    int recentFiles = 0;
    final now = DateTime.now();

    for (final doc in documentsToProcess) {
      // File type counting
      fileTypeStats[doc.fileType] = (fileTypeStats[doc.fileType] ?? 0) + 1;

      // Size calculation
      totalSize += doc.fileSize;

      // Recent files (last 7 days)
      if (now.difference(doc.uploadedAt).inDays <= 7) {
        recentFiles++;
      }
    }

    stats['totalSize'] = totalSize;
    stats['averageSize'] = documentsToProcess.isNotEmpty
        ? totalSize / documentsToProcess.length
        : 0;
    stats['recentFiles'] = recentFiles;
    stats['fileTypeStats'] = fileTypeStats;
    stats['largestFile'] = documentsToProcess.isNotEmpty
        ? documentsToProcess.reduce((a, b) => a.fileSize > b.fileSize ? a : b)
        : null;

    _cachedStats = stats;
  }

  @override
  Widget build(BuildContext context) {
    if (_cachedStats == null) {
      return _buildLoadingState();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final isTablet = screenWidth >= 768;

    final responsivePadding =
        widget.padding ??
        EdgeInsets.all(isSmallScreen ? 12.0 : (isTablet ? 20.0 : 16.0));

    final responsiveMargin =
        widget.margin ??
        EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 8.0 : 16.0,
          vertical: 8.0,
        );

    Widget content = Container(
      margin: responsiveMargin,
      padding: responsivePadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isSmallScreen, isTablet),
          SizedBox(height: isSmallScreen ? 12 : 16),
          _buildMainStats(isSmallScreen, isTablet),
          if (widget.showDetailedStats) ...[
            SizedBox(height: isSmallScreen ? 12 : 16),
            _buildDetailedStats(isSmallScreen, isTablet),
          ],
          if (_cachedStats!['isLimitedProcessing'] == true) ...[
            SizedBox(height: isSmallScreen ? 8 : 12),
            _buildPerformanceNotice(isSmallScreen),
          ],
        ],
      ),
    );

    if (widget.enableAnimations) {
      content = SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(opacity: _fadeAnimation, child: content),
      );
    }

    return content;
  }

  Widget _buildLoadingState() {
    return Container(
      margin:
          widget.margin ??
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: widget.padding ?? const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildHeader(bool isSmallScreen, bool isTablet) {
    return Row(
      children: [
        Icon(
          Icons.analytics_outlined,
          color: AppColors.primary,
          size: isSmallScreen ? 18 : (isTablet ? 24 : 20),
        ),
        SizedBox(width: isSmallScreen ? 6 : 8),
        Expanded(
          child: Text(
            widget.title ?? 'File Statistics',
            style: GoogleFonts.poppins(
              fontSize: isSmallScreen ? 14 : (isTablet ? 18 : 16),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (widget.onRefresh != null)
          IconButton(
            onPressed: widget.onRefresh,
            icon: Icon(
              Icons.refresh,
              size: isSmallScreen ? 18 : 20,
              color: AppColors.textSecondary,
            ),
            padding: EdgeInsets.all(isSmallScreen ? 4 : 8),
            constraints: const BoxConstraints(),
          ),
      ],
    );
  }

  Widget _buildMainStats(bool isSmallScreen, bool isTablet) {
    final stats = _cachedStats!;
    final totalFiles = stats['totalFiles'] as int;
    final totalSize = stats['totalSize'] as int;
    final recentFiles = stats['recentFiles'] as int;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Files',
            totalFiles.toString(),
            Icons.description_outlined,
            AppColors.primary,
            isSmallScreen,
            isTablet,
          ),
        ),
        SizedBox(width: isSmallScreen ? 8 : 12),
        Expanded(
          child: _buildStatCard(
            'Total Size',
            FileSizeFormatter.formatBytes(totalSize),
            Icons.storage_outlined,
            AppColors.info,
            isSmallScreen,
            isTablet,
          ),
        ),
        SizedBox(width: isSmallScreen ? 8 : 12),
        Expanded(
          child: _buildStatCard(
            'Recent',
            recentFiles.toString(),
            Icons.access_time_outlined,
            AppColors.success,
            isSmallScreen,
            isTablet,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isSmallScreen,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 8 : (isTablet ? 16 : 12)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: isSmallScreen ? 16 : (isTablet ? 24 : 20),
          ),
          SizedBox(height: isSmallScreen ? 4 : 6),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: isSmallScreen ? 12 : (isTablet ? 16 : 14),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallScreen ? 2 : 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: isSmallScreen ? 10 : (isTablet ? 12 : 11),
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedStats(bool isSmallScreen, bool isTablet) {
    final stats = _cachedStats!;
    final fileTypeStats = stats['fileTypeStats'] as Map<String, int>;
    final averageSize = stats['averageSize'] as double;
    final largestFile = stats['largestFile'] as DocumentModel?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'File Type Distribution',
          style: GoogleFonts.poppins(
            fontSize: isSmallScreen ? 12 : (isTablet ? 16 : 14),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: isSmallScreen ? 6 : 8),
        _buildFileTypeDistribution(fileTypeStats, isSmallScreen, isTablet),
        SizedBox(height: isSmallScreen ? 8 : 12),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                'Average Size',
                FileSizeFormatter.formatBytes(averageSize.round()),
                Icons.analytics_outlined,
                isSmallScreen,
                isTablet,
              ),
            ),
            if (largestFile != null) ...[
              SizedBox(width: isSmallScreen ? 8 : 12),
              Expanded(
                child: _buildInfoCard(
                  'Largest File',
                  FileSizeFormatter.formatBytes(largestFile.fileSize),
                  Icons.file_present_outlined,
                  isSmallScreen,
                  isTablet,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildFileTypeDistribution(
    Map<String, int> fileTypeStats,
    bool isSmallScreen,
    bool isTablet,
  ) {
    if (fileTypeStats.isEmpty) {
      return Text(
        'No file type data available',
        style: GoogleFonts.poppins(
          fontSize: isSmallScreen ? 11 : 12,
          color: AppColors.textSecondary,
        ),
      );
    }

    // Sort by count and take top 5 for performance
    final sortedTypes = fileTypeStats.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topTypes = sortedTypes.take(5).toList();

    return Wrap(
      spacing: isSmallScreen ? 6 : 8,
      runSpacing: isSmallScreen ? 4 : 6,
      children: topTypes.map((entry) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 6 : 8,
            vertical: isSmallScreen ? 3 : 4,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Text(
            '${entry.key}: ${entry.value}',
            style: GoogleFonts.poppins(
              fontSize: isSmallScreen ? 10 : (isTablet ? 12 : 11),
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInfoCard(
    String label,
    String value,
    IconData icon,
    bool isSmallScreen,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 8 : (isTablet ? 12 : 10)),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.textSecondary,
            size: isSmallScreen ? 14 : (isTablet ? 18 : 16),
          ),
          SizedBox(width: isSmallScreen ? 6 : 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: isSmallScreen ? 11 : (isTablet ? 14 : 12),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: isSmallScreen ? 9 : (isTablet ? 11 : 10),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceNotice(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.warning,
            size: isSmallScreen ? 14 : 16,
          ),
          SizedBox(width: isSmallScreen ? 6 : 8),
          Expanded(
            child: Text(
              'Statistics computed from ${_cachedStats!['processedFiles']} of ${_cachedStats!['totalFiles']} files for performance',
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 10 : 11,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
