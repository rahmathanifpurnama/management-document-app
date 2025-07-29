# Page-by-Page Technical Specifications

## Overview

This document provides detailed technical specifications for each screen/page in the SimDoc application, including state management patterns, widget hierarchies, Firebase integration points, and navigation flows.

## Authentication Flow

### 1. Splash Screen
**File**: `lib/screens/auth/splash_screen.dart`

#### Purpose
- Initialize Firebase services
- Check authentication state
- Handle app startup logic
- Navigate to appropriate screen

#### State Management
```dart
// BLoC Usage
- AuthBloc: Authentication state management
  - Events: Initialize, CheckAuthState
  - States: Initial, Loading, Authenticated, Unauthenticated, Error

// Riverpod Usage
- firebaseInitializationProvider: Firebase service status
- authStateProvider: Stream of authentication changes
```

#### Widget Hierarchy
```dart
SplashScreen (StatefulWidget)
├── Scaffold
│   └── SafeArea
│       └── Column
│           ├── Expanded (Logo Section)
│           │   └── Center
│           │       └── SvgPicture.asset('assets/simdoc_bapeltan.svg')
│           ├── CircularProgressIndicator
│           └── Padding (Version Text)
│               └── Text('Version 1.0.0')
```

#### Firebase Integration
- Firebase initialization check
- Authentication state stream subscription
- Error handling for Firebase connection issues

#### Navigation Logic
```dart
void _handleAuthState(AuthState state) {
  state.when(
    authenticated: (user) => Navigator.pushReplacementNamed(context, AppRoutes.home),
    unauthenticated: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
    error: (message) => _showErrorDialog(message),
    loading: () => {}, // Show loading indicator
  );
}
```

#### OOP Patterns
- **Inheritance**: Extends StatefulWidget
- **Encapsulation**: Private methods for navigation logic
- **Abstraction**: Uses abstract AuthBloc interface

### 2. Login Screen
**File**: `lib/screens/auth/login_screen.dart`

#### Purpose
- User authentication with email/password
- Remember Me functionality
- Forgot password handling
- Input validation

#### State Management
```dart
// BLoC Usage
- AuthBloc: Login operations
  - Events: Login, ForgotPassword, ClearError
  - States: Initial, Loading, Success, Error

// Riverpod Usage
- authStateProvider: Reactive auth state
- rememberMeProvider: Remember Me checkbox state
```

#### Widget Hierarchy
```dart
LoginScreen (ConsumerStatefulWidget)
├── Scaffold
│   └── SafeArea
│       └── Stack
│           ├── SingleChildScrollView
│           │   └── Form
│           │       ├── Column
│           │       │   ├── SizedBox (Spacing)
│           │       │   ├── SvgPicture.asset (Logo)
│           │       │   ├── SizedBox (Spacing)
│           │       │   ├── TextFormField (Email)
│           │       │   ├── SizedBox (Spacing)
│           │       │   ├── TextFormField (Password)
│           │       │   ├── Row (Remember Me)
│           │       │   │   ├── Checkbox
│           │       │   │   └── Text
│           │       │   ├── SizedBox (Spacing)
│           │       │   ├── ElevatedButton (Login)
│           │       │   └── TextButton (Forgot Password)
│           └── Consumer (Loading Overlay)
│               └── LoadingOverlay
```

#### Form Validation
```dart
String? _validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email tidak boleh kosong';
  }
  
  final allowedDomains = ['gmail.com', 'yahoo.com', 'outlook.com', 'hotmail.com'];
  final emailRegex = RegExp(r'^[^@]+@([^@]+)$');
  final match = emailRegex.firstMatch(value);
  
  if (match == null) {
    return 'Format email tidak valid';
  }
  
  final domain = match.group(1);
  if (!allowedDomains.contains(domain)) {
    return 'Domain email tidak diizinkan';
  }
  
  return null;
}

String? _validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password tidak boleh kosong';
  }
  if (value.length < 6) {
    return 'Password minimal 6 karakter';
  }
  return null;
}
```

#### Firebase Integration
- Firebase Authentication sign-in
- Error handling for auth failures
- SharedPreferences for Remember Me

#### Navigation Flow
```dart
void _handleLoginSuccess(UserModel user) {
  Navigator.pushNamedAndRemoveUntil(
    context,
    AppRoutes.home,
    (Route<dynamic> route) => false,
  );
}
```

## Dashboard & Home

### 3. Home Screen
**File**: `lib/screens/common/home_screen.dart`

#### Purpose
- Main dashboard with statistics
- Recent files display
- Search functionality
- Quick access to features

#### State Management
```dart
// BLoC Usage
- DocumentBloc: Document operations
  - Events: LoadRecentDocuments, SearchDocuments, RefreshDocuments
  - States: Initial, Loading, Loaded, Error

- CategoryBloc: Category management
  - Events: LoadCategories, RefreshCategories
  - States: Initial, Loading, Loaded, Error

- SyncBloc: Data synchronization
  - Events: PerformAutoSync, OnPullToRefresh
  - States: Idle, Syncing, Success, Error

// Riverpod Usage
- currentUserSyncProvider: Current user data
- notificationProvider: Notification state
- fileSelectionProvider: File selection state
```

#### Widget Hierarchy
```dart
HomeScreen (ConsumerStatefulWidget with RouteAware)
├── BlocBuilder<AuthBloc, AuthState>
│   └── AppScaffoldWithNavigation
│       ├── AppBar
│       │   ├── Title ('Beranda')
│       │   └── Actions
│       │       └── BellNotificationWidget
│       └── Column
│           ├── FileSelectionBar (Conditional)
│           └── Expanded
│               └── RefreshIndicator
│                   └── SingleChildScrollView
│                       └── Container (Background)
│                           └── Column
│                               ├── SizedBox (Spacing)
│                               ├── HomeGreetingSection
│                               ├── ResponsiveStatsGrid (Admin only)
│                               ├── HomeSearchSection
│                               ├── HomeFileListSection
│                               └── SizedBox (Bottom spacing)
```

#### Component Breakdown

##### HomeGreetingSection
```dart
class HomeGreetingSection extends StatelessWidget {
  final AuthState authState;
  final String currentGreeting;
  final VoidCallback onProfileTap;

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentGreeting, style: TextStyle(color: Colors.white)),
                Text(authState.currentUser?.fullName ?? '', 
                     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          GestureDetector(
            onTap: onProfileTap,
            child: CircleAvatar(
              backgroundImage: authState.currentUser?.profileImage != null
                ? NetworkImage(authState.currentUser!.profileImage!)
                : null,
              child: authState.currentUser?.profileImage == null
                ? Icon(Icons.person)
                : null,
            ),
          ),
        ],
      ),
    );
  }
}
```

##### ResponsiveStatsGrid (Admin Only)
```dart
class ResponsiveStatsGrid extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Row 1: 4 widgets
          Row(
            children: [
              Expanded(child: UnifiedStatsWidget(type: StatsType.totalFiles)),
              SizedBox(width: 8),
              Expanded(child: UnifiedStatsWidget(type: StatsType.totalUsers)),
              SizedBox(width: 8),
              Expanded(child: UnifiedStatsWidget(type: StatsType.totalCategories)),
              SizedBox(width: 8),
              Expanded(child: UnifiedStatsWidget(type: StatsType.storageUsed)),
            ],
          ),
          SizedBox(height: 8),
          // Row 2: 2 widgets with spacing
          Row(
            children: [
              Expanded(child: UnifiedStatsWidget(type: StatsType.recycleBin)),
              SizedBox(width: 8),
              Expanded(child: UnifiedStatsWidget(type: StatsType.favorites)),
              Expanded(flex: 2, child: SizedBox()), // Empty space for future expansion
            ],
          ),
        ],
      ),
    );
  }
}
```

##### HomeSearchSection
```dart
class HomeSearchSection extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: searchController,
        onChanged: onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Cari dokumen...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
```

##### HomeFileListSection
```dart
class HomeFileListSection extends ConsumerWidget {
  final String searchQuery;
  final Function(DocumentModel) onDocumentTap;
  final Function(DocumentModel) onDocumentMenu;
  final VoidCallback onFilterTap;

  Widget build(BuildContext context, WidgetRef ref) {
    return BlocBuilder<DocumentBloc, DocumentState>(
      builder: (context, state) {
        return state.when(
          loading: () => SkeletonLoader(),
          loaded: (documents) => Column(
            children: [
              // Header with filter
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('File Terbaru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed: onFilterTap,
                    ),
                  ],
                ),
              ),
              // File list
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final document = documents[index];
                  return FileListTile(
                    document: document,
                    onTap: () => onDocumentTap(document),
                    onMenuTap: () => onDocumentMenu(document),
                  );
                },
              ),
            ],
          ),
          error: (message) => ErrorWidget(message: message),
        );
      },
    );
  }
}
```

#### Firebase Integration
- Real-time document listening
- Category data synchronization
- User statistics fetching
- Activity logging

#### Performance Optimizations
- Lazy loading of file lists
- Image caching for profile pictures
- Debounced search functionality
- Optimized rebuild strategies

#### Navigation Flows
```dart
void _navigateToFilePreview(DocumentModel document) {
  Navigator.pushNamed(
    context,
    AppRoutes.filePreview,
    arguments: document,
  );
}

void _showProfileMenu(AuthState authState) {
  showModalBottomSheet(
    context: context,
    builder: (context) => ProfileMenuBottomSheet(user: authState.currentUser),
  );
}

void _showDocumentMenu(DocumentModel document) {
  showModalBottomSheet(
    context: context,
    builder: (context) => DocumentMenuBottomSheet(document: document),
  );
}
```

## File Management

### 4. Total Files Screen
**File**: `lib/screens/files/total_files_screen.dart`

#### Purpose
- Display all files in the system
- Advanced search and filtering
- Bulk operations
- File management actions

#### State Management
```dart
// BLoC Usage
- DocumentBloc: File operations
  - Events: LoadAllDocuments, SearchDocuments, FilterDocuments, BulkDelete
  - States: Initial, Loading, Loaded, Error

// Riverpod Usage
- fileSelectionProvider: Multi-select state
- searchFilterProvider: Search and filter state
- bulkOperationsProvider: Bulk operation state
```

#### Widget Hierarchy
```dart
TotalFilesScreen (ConsumerStatefulWidget)
├── Scaffold (no bottom navigation)
│   ├── AppBar
│   │   ├── Leading (Back button)
│   │   ├── Title ('Total Files')
│   │   └── Actions
│   │       └── IconButton (Bulk select toggle)
│   └── Column
│       ├── SearchWidget
│       │   ├── TextField (Search input)
│       │   └── IconButton (Filter)
│       ├── Container (Title and filter section)
│       │   └── Row
│       │       ├── Text ('Semua File')
│       │       ├── Spacer
│       │       └── FilterChip (Active filters)
│       └── Expanded
│           └── FileListSection
│               ├── BlocBuilder<DocumentBloc, DocumentState>
│               │   ├── LoadingState → SkeletonLoader
│               │   ├── LoadedState → ListView.builder
│               │   │   └── FileListTile (with selection)
│               │   └── ErrorState → ErrorWidget
│               └── FloatingActionButton (Bulk actions)
```

#### Search and Filter Implementation
```dart
class SearchFilterWidget extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final activeFilters = ref.watch(activeFiltersProvider);

    return Column(
      children: [
        // Search input
        Padding(
          padding: EdgeInsets.all(16),
          child: TextField(
            onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
            decoration: InputDecoration(
              hintText: 'Cari berdasarkan nama file...',
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () => _showFilterDialog(context, ref),
              ),
            ),
          ),
        ),
        // Active filters
        if (activeFilters.isNotEmpty)
          Container(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: activeFilters.length,
              itemBuilder: (context, index) {
                final filter = activeFilters[index];
                return Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: FilterChip(
                    label: Text(filter.label),
                    onDeleted: () => _removeFilter(ref, filter),
                    deleteIcon: Icon(Icons.close),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
```

#### Bulk Operations
```dart
class BulkOperationsService {
  static Future<void> performBulkDelete(
    List<DocumentModel> documents,
    BuildContext context,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Hapus'),
        content: Text('Hapus ${documents.length} file yang dipilih?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      for (final document in documents) {
        context.read<DocumentBloc>().add(
          DocumentEvent.deleteDocument(document.id),
        );
      }
    }
  }
}
```

### 5. Recycle Bin Screen
**File**: `lib/screens/recycle_bin/recycle_bin_screen.dart`

#### Purpose
- Display deleted files
- Restore functionality
- Permanent deletion (Admin only)
- Recycle bin statistics

#### State Management
```dart
// BLoC Usage
- DocumentBloc: Deleted document operations
  - Events: LoadDeletedDocuments, RestoreDocument, PermanentlyDeleteDocument
  - States: Initial, Loading, Loaded, Error

// Riverpod Usage
- recycleBinStatsProvider: Recycle bin statistics
- bulkRestoreProvider: Bulk restore operations
```

#### Widget Hierarchy
```dart
RecycleBinScreen (ConsumerStatefulWidget)
├── Scaffold (no bottom navigation)
│   ├── AppBar
│   │   ├── Leading (Back button)
│   │   └── Title ('Recycle Bin')
│   └── Column
│       ├── QuickAccessWidget (4 cards, stats grid style)
│       │   ├── Card (Total Deleted Files)
│       │   ├── Card (Storage Recoverable)
│       │   ├── Card (Files This Week)
│       │   └── Card (Auto-Delete In)
│       └── Expanded
│           └── BlocBuilder<DocumentBloc, DocumentState>
│               ├── LoadingState → SkeletonLoader
│               ├── LoadedState → DeletedFilesList
│               │   └── ListView.builder
│               │       └── DeletedFileListTile
│               │           ├── File info
│               │           ├── Deletion timestamp
│               │           └── Action buttons
│               │               ├── IconButton (Restore)
│               │               └── IconButton (Permanent delete - Admin only)
│               └── ErrorState → ErrorWidget
```

#### Deleted File List Tile
```dart
class DeletedFileListTile extends StatelessWidget {
  final DocumentModel document;
  final VoidCallback onRestore;
  final VoidCallback? onPermanentDelete; // Admin only

  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(
          _getFileIcon(document.fileType),
          color: Colors.grey,
        ),
        title: Text(
          document.fileName,
          style: TextStyle(
            decoration: TextDecoration.lineThrough,
            color: Colors.grey[600],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dihapus: ${_formatDate(document.deletedAt)}'),
            Text('Oleh: ${document.deletedBy}'),
            Text('Ukuran: ${_formatFileSize(document.fileSize)}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.restore, color: Colors.green),
              onPressed: onRestore,
              tooltip: 'Pulihkan',
            ),
            if (onPermanentDelete != null)
              IconButton(
                icon: Icon(Icons.delete_forever, color: Colors.red),
                onPressed: onPermanentDelete,
                tooltip: 'Hapus Permanen',
              ),
          ],
        ),
      ),
    );
  }
}
```

#### Auto-Delete Policy
```dart
class RecycleBinPolicy {
  static const Duration retentionPeriod = Duration(days: 7);
  
  static bool isExpired(DocumentModel document) {
    if (document.deletedAt == null) return false;
    
    final expiryDate = document.deletedAt!.add(retentionPeriod);
    return DateTime.now().isAfter(expiryDate);
  }
  
  static Duration timeUntilExpiry(DocumentModel document) {
    if (document.deletedAt == null) return Duration.zero;
    
    final expiryDate = document.deletedAt!.add(retentionPeriod);
    final remaining = expiryDate.difference(DateTime.now());
    
    return remaining.isNegative ? Duration.zero : remaining;
  }
}
```

## Category Management

### 6. Manage Categories Screen
**File**: `lib/screens/category/manage_category_screen.dart`

#### Purpose
- Category CRUD operations
- Permission management
- Document count tracking
- Category organization

#### State Management
```dart
// BLoC Usage
- CategoryBloc: Category operations
  - Events: LoadCategories, CreateCategory, UpdateCategory, DeleteCategory
  - States: Initial, Loading, Loaded, Error

// Riverpod Usage
- categorySelectionProvider: Category selection state
- categoryFormProvider: Category form state
```

#### Widget Hierarchy
```dart
ManageCategoryScreen (ConsumerStatefulWidget)
├── AppScaffoldWithNavigation
│   ├── AppBar
│   │   └── Title ('Manage Categories')
│   ├── FloatingActionButton (Add Category)
│   └── BlocBuilder<CategoryBloc, CategoryState>
│       ├── LoadingState → SkeletonLoader
│       ├── LoadedState → CategoryList
│       │   ├── ListView.builder
│       │   │   └── CategoryCard
│       │   │       ├── Container (Category info)
│       │   │       │   ├── Row
│       │   │       │   │   ├── Icon (Category icon)
│       │   │       │   │   ├── Column
│       │   │       │   │   │   ├── Text (Category name)
│       │   │       │   │   │   ├── Text (Description)
│       │   │       │   │   │   └── Text (Document count)
│       │   │       │   │   └── PopupMenuButton (Actions)
│       │   │       │   │       ├── Edit
│       │   │       │   │       ├── View Files
│       │   │       │   │       ├── Permissions
│       │   │       │   │       └── Delete
│       │   │       └── Container (Status indicator)
│       │   └── EmptyState (No categories)
│       └── ErrorState → ErrorWidget
```

#### Category Card Implementation
```dart
class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onViewFiles;
  final VoidCallback onManagePermissions;

  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Category icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getCategoryColor(category).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getCategoryIcon(category),
                color: _getCategoryColor(category),
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            // Category info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (category.description.isNotEmpty)
                    Text(
                      category.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.description, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        '${category.documentCount ?? 0} dokumen',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(
                        category.isActive ? Icons.check_circle : Icons.cancel,
                        size: 16,
                        color: category.isActive ? Colors.green : Colors.red,
                      ),
                      SizedBox(width: 4),
                      Text(
                        category.isActive ? 'Aktif' : 'Nonaktif',
                        style: TextStyle(
                          fontSize: 12,
                          color: category.isActive ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Action menu
            PopupMenuButton<String>(
              onSelected: (value) => _handleMenuAction(value),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'files',
                  child: Row(
                    children: [
                      Icon(Icons.folder_open, size: 20),
                      SizedBox(width: 8),
                      Text('Lihat File'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'permissions',
                  child: Row(
                    children: [
                      Icon(Icons.security, size: 20),
                      SizedBox(width: 8),
                      Text('Kelola Izin'),
                    ],
                  ),
                ),
                PopupMenuDivider(),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Hapus', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'edit':
        onEdit();
        break;
      case 'files':
        onViewFiles();
        break;
      case 'permissions':
        onManagePermissions();
        break;
      case 'delete':
        onDelete();
        break;
    }
  }
}
```

#### Category Form Dialog
```dart
class CategoryFormDialog extends StatefulWidget {
  final CategoryModel? category; // null for create, non-null for edit

  @override
  _CategoryFormDialogState createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _descriptionController.text = widget.category!.description;
      _isActive = widget.category!.isActive;
    }
  }

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.category == null ? 'Tambah Kategori' : 'Edit Kategori'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nama Kategori',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama kategori tidak boleh kosong';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('Aktif'),
              value: _isActive,
              onChanged: (value) => setState(() => _isActive = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _saveCategory,
          child: Text(widget.category == null ? 'Tambah' : 'Simpan'),
        ),
      ],
    );
  }

  void _saveCategory() {
    if (_formKey.currentState!.validate()) {
      final category = CategoryModel(
        id: widget.category?.id ?? const Uuid().v4(),
        name: _nameController.text,
        description: _descriptionController.text,
        createdBy: widget.category?.createdBy ?? 'current_user_id',
        createdAt: widget.category?.createdAt ?? DateTime.now(),
        permissions: widget.category?.permissions ?? [],
        isActive: _isActive,
      );

      Navigator.pop(context, category);
    }
  }
}
```

## User Management

### 7. User Management Screen
**File**: `lib/screens/admin/user_management_screen.dart`

#### Purpose
- Admin-only user administration
- User creation, editing, deletion
- Role and status management
- User activity monitoring

#### State Management
```dart
// BLoC Usage
- UserBloc: User operations
  - Events: LoadUsers, CreateUser, UpdateUser, DeleteUser, ChangeUserStatus
  - States: Initial, Loading, Loaded, Error

// Riverpod Usage
- userSelectionProvider: User selection state
- userFilterProvider: User filtering state
```

#### Widget Hierarchy
```dart
UserManagementScreen (ConsumerStatefulWidget)
├── Scaffold (no bottom navigation)
│   ├── AppBar
│   │   ├── Leading (Back button)
│   │   ├── Title ('User Management')
│   │   └── Actions
│   │       └── IconButton (Search)
│   ├── FloatingActionButton (Create User)
│   └── Column
│       ├── UserFilterTabs
│       │   ├── Tab (All Users)
│       │   ├── Tab (Active)
│       │   ├── Tab (Inactive)
│       │   └── Tab (Admins)
│       └── Expanded
│           └── BlocBuilder<UserBloc, UserState>
│               ├── LoadingState → SkeletonLoader
│               ├── LoadedState → UserList
│               │   └── ListView.builder
│               │       └── UserCard
│               └── ErrorState → ErrorWidget
```

### 8. Activity Screen
**File**: `lib/screens/activity/new_activity_page.dart`

#### Purpose
- Display user activity logs
- Activity filtering and search
- Performance monitoring
- Audit trail management

#### State Management
```dart
// BLoC Usage
- ActivityBloc: Activity operations
  - Events: LoadActivities, FilterActivities, LoadMoreActivities
  - States: Initial, Loading, Loaded, Error

// Riverpod Usage
- activityFilterProvider: Activity filtering state
- activityPaginationProvider: Pagination state
```

#### Widget Hierarchy
```dart
NewActivityPage (ConsumerStatefulWidget)
├── Scaffold (no bottom navigation)
│   ├── AppBar
│   │   ├── Leading (Back button)
│   │   └── Title ('Activity')
│   └── Column
│       ├── QuickAccessWidget (4 cards, stats grid style)
│       │   ├── Card (Today's Activities)
│       │   ├── Card (This Week)
│       │   ├── Card (Failed Actions)
│       │   └── Card (Most Active User)
│       ├── ActivityFilterBar
│       │   └── Row
│       │       ├── FilterChip (Login/Logout)
│       │       ├── FilterChip (File Operations)
│       │       ├── FilterChip (User Management)
│       │       └── FilterChip (System Events)
│       └── Expanded
│           └── ActivityList
│               ├── ListView.builder (25 items per page)
│               │   └── ActivityCard
│               │       ├── Leading (Color-coded icon)
│               │       ├── Title (Activity description)
│               │       ├── Subtitle (User and timestamp)
│               │       └── Trailing (Status indicator)
│               └── InfiniteScrollLoader
```

### 9. Upload Document Screen
**File**: `lib/screens/upload/upload_document_screen.dart`

#### Purpose
- File upload with validation
- Category selection
- Progress tracking
- Hybrid cloud processing

#### State Management
```dart
// BLoC Usage
- UploadBloc: Upload operations
  - Events: SelectFile, UploadFile, CancelUpload, RetryUpload
  - States: Initial, FileSelected, Uploading, Success, Error

// Riverpod Usage
- fileSelectionProvider: Selected file state
- uploadProgressProvider: Upload progress state
- categorySelectionProvider: Category selection state
```

#### Widget Hierarchy
```dart
UploadDocumentScreen (ConsumerStatefulWidget)
├── AppScaffoldWithNavigation
│   ├── AppBar
│   │   └── Title ('Upload Document')
│   └── Padding
│       └── Form
│           └── Column
│               ├── FileSelectionArea
│               │   ├── DottedBorder
│               │   │   └── InkWell
│               │   │       └── Column
│               │   │           ├── Icon (Upload icon)
│               │   │           ├── Text ('Tap to select file')
│               │   │           └── Text ('Max 15MB')
│               │   └── SelectedFilePreview (if file selected)
│               ├── SizedBox (Spacing)
│               ├── CategoryDropdown
│               │   └── DropdownButtonFormField
│               ├── SizedBox (Spacing)
│               ├── UploadProgressIndicator (if uploading)
│               │   ├── LinearProgressIndicator
│               │   ├── Text (Progress percentage)
│               │   └── Text (Upload speed)
│               ├── SizedBox (Spacing)
│               └── Row
│                   ├── Expanded
│                   │   └── ElevatedButton (Cancel)
│                   ├── SizedBox (Spacing)
│                   └── Expanded
│                       └── ElevatedButton (Upload)
```

## Navigation Patterns

### Bottom Navigation Structure
```dart
class AppScaffoldWithNavigation extends StatelessWidget {
  final String title;
  final Widget body;
  final int currentNavIndex;
  final bool showAppBar;
  final List<Widget>? actions;

  static const List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Beranda',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.folder_outlined),
      activeIcon: Icon(Icons.folder),
      label: 'Kategori',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add_circle_outline),
      activeIcon: Icon(Icons.add_circle),
      label: 'Upload',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: 'Profil',
    ),
    // Admin only
    BottomNavigationBarItem(
      icon: Icon(Icons.admin_panel_settings_outlined),
      activeIcon: Icon(Icons.admin_panel_settings),
      label: 'Admin',
    ),
  ];

  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final isAdmin = ref.watch(isAdminProvider);
        final navItems = isAdmin ? _navItems : _navItems.take(4).toList();

        return Scaffold(
          appBar: showAppBar ? AppBar(
            title: Text(title),
            actions: actions,
          ) : null,
          body: body,
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentNavIndex,
            onTap: (index) => _onNavTap(context, index),
            items: navItems,
          ),
        );
      },
    );
  }

  void _onNavTap(BuildContext context, int index) {
    if (index == currentNavIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.manageCategories);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.uploadDocument);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.profile);
        break;
      case 4: // Admin only
        Navigator.pushReplacementNamed(context, AppRoutes.userManagement);
        break;
    }
  }
}
```

### Route Management
```dart
class AppRoutes {
  // Authentication
  static const String splash = '/';
  static const String login = '/login';

  // Main navigation
  static const String home = '/home';
  static const String manageCategories = '/categories';
  static const String uploadDocument = '/upload';
  static const String profile = '/profile';

  // File management
  static const String totalFiles = '/files';
  static const String recycleBin = '/recycle-bin';
  static const String favorites = '/favorites';
  static const String filePreview = '/file-preview';

  // Category management
  static const String categoryFiles = '/category-files';
  static const String addFilesToCategory = '/add-files-to-category';

  // User management (Admin only)
  static const String userManagement = '/admin/users';
  static const String createUser = '/admin/users/create';
  static const String editUser = '/admin/users/edit';
  static const String userDetails = '/admin/users/details';

  // Profile management
  static const String personalInfo = '/profile/personal-info';
  static const String editProfile = '/profile/edit';
  static const String settings = '/profile/settings';
  static const String changePassword = '/profile/change-password';

  // Activity and monitoring
  static const String activity = '/activity';
  static const String storageHistory = '/storage-history';
  static const String notificationCenter = '/notifications';
}
```

This comprehensive page-by-page specification provides detailed technical information for implementing each screen in the SimDoc application with proper state management, widget hierarchies, Firebase integration, and navigation patterns following object-oriented design principles.
