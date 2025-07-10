// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_selection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FileSelectionState {
  bool get isSelectionMode => throw _privateConstructorUsedError;
  Set<String> get selectedFileIds => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<DocumentModel> get availableFiles => throw _privateConstructorUsedError;
  bool get isUpdatingAvailableFiles => throw _privateConstructorUsedError;
  String? get lastAvailableFilesHash => throw _privateConstructorUsedError;

  /// Create a copy of FileSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FileSelectionStateCopyWith<FileSelectionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileSelectionStateCopyWith<$Res> {
  factory $FileSelectionStateCopyWith(
    FileSelectionState value,
    $Res Function(FileSelectionState) then,
  ) = _$FileSelectionStateCopyWithImpl<$Res, FileSelectionState>;
  @useResult
  $Res call({
    bool isSelectionMode,
    Set<String> selectedFileIds,
    @JsonKey(includeFromJson: false, includeToJson: false)
    List<DocumentModel> availableFiles,
    bool isUpdatingAvailableFiles,
    String? lastAvailableFilesHash,
  });
}

/// @nodoc
class _$FileSelectionStateCopyWithImpl<$Res, $Val extends FileSelectionState>
    implements $FileSelectionStateCopyWith<$Res> {
  _$FileSelectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FileSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSelectionMode = null,
    Object? selectedFileIds = null,
    Object? availableFiles = null,
    Object? isUpdatingAvailableFiles = null,
    Object? lastAvailableFilesHash = freezed,
  }) {
    return _then(
      _value.copyWith(
            isSelectionMode: null == isSelectionMode
                ? _value.isSelectionMode
                : isSelectionMode // ignore: cast_nullable_to_non_nullable
                      as bool,
            selectedFileIds: null == selectedFileIds
                ? _value.selectedFileIds
                : selectedFileIds // ignore: cast_nullable_to_non_nullable
                      as Set<String>,
            availableFiles: null == availableFiles
                ? _value.availableFiles
                : availableFiles // ignore: cast_nullable_to_non_nullable
                      as List<DocumentModel>,
            isUpdatingAvailableFiles: null == isUpdatingAvailableFiles
                ? _value.isUpdatingAvailableFiles
                : isUpdatingAvailableFiles // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastAvailableFilesHash: freezed == lastAvailableFilesHash
                ? _value.lastAvailableFilesHash
                : lastAvailableFilesHash // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FileSelectionStateImplCopyWith<$Res>
    implements $FileSelectionStateCopyWith<$Res> {
  factory _$$FileSelectionStateImplCopyWith(
    _$FileSelectionStateImpl value,
    $Res Function(_$FileSelectionStateImpl) then,
  ) = __$$FileSelectionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isSelectionMode,
    Set<String> selectedFileIds,
    @JsonKey(includeFromJson: false, includeToJson: false)
    List<DocumentModel> availableFiles,
    bool isUpdatingAvailableFiles,
    String? lastAvailableFilesHash,
  });
}

/// @nodoc
class __$$FileSelectionStateImplCopyWithImpl<$Res>
    extends _$FileSelectionStateCopyWithImpl<$Res, _$FileSelectionStateImpl>
    implements _$$FileSelectionStateImplCopyWith<$Res> {
  __$$FileSelectionStateImplCopyWithImpl(
    _$FileSelectionStateImpl _value,
    $Res Function(_$FileSelectionStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FileSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSelectionMode = null,
    Object? selectedFileIds = null,
    Object? availableFiles = null,
    Object? isUpdatingAvailableFiles = null,
    Object? lastAvailableFilesHash = freezed,
  }) {
    return _then(
      _$FileSelectionStateImpl(
        isSelectionMode: null == isSelectionMode
            ? _value.isSelectionMode
            : isSelectionMode // ignore: cast_nullable_to_non_nullable
                  as bool,
        selectedFileIds: null == selectedFileIds
            ? _value._selectedFileIds
            : selectedFileIds // ignore: cast_nullable_to_non_nullable
                  as Set<String>,
        availableFiles: null == availableFiles
            ? _value._availableFiles
            : availableFiles // ignore: cast_nullable_to_non_nullable
                  as List<DocumentModel>,
        isUpdatingAvailableFiles: null == isUpdatingAvailableFiles
            ? _value.isUpdatingAvailableFiles
            : isUpdatingAvailableFiles // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastAvailableFilesHash: freezed == lastAvailableFilesHash
            ? _value.lastAvailableFilesHash
            : lastAvailableFilesHash // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$FileSelectionStateImpl implements _FileSelectionState {
  const _$FileSelectionStateImpl({
    this.isSelectionMode = false,
    final Set<String> selectedFileIds = const {},
    @JsonKey(includeFromJson: false, includeToJson: false)
    final List<DocumentModel> availableFiles = const [],
    this.isUpdatingAvailableFiles = false,
    this.lastAvailableFilesHash,
  }) : _selectedFileIds = selectedFileIds,
       _availableFiles = availableFiles;

  @override
  @JsonKey()
  final bool isSelectionMode;
  final Set<String> _selectedFileIds;
  @override
  @JsonKey()
  Set<String> get selectedFileIds {
    if (_selectedFileIds is EqualUnmodifiableSetView) return _selectedFileIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedFileIds);
  }

  final List<DocumentModel> _availableFiles;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<DocumentModel> get availableFiles {
    if (_availableFiles is EqualUnmodifiableListView) return _availableFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableFiles);
  }

  @override
  @JsonKey()
  final bool isUpdatingAvailableFiles;
  @override
  final String? lastAvailableFilesHash;

  @override
  String toString() {
    return 'FileSelectionState(isSelectionMode: $isSelectionMode, selectedFileIds: $selectedFileIds, availableFiles: $availableFiles, isUpdatingAvailableFiles: $isUpdatingAvailableFiles, lastAvailableFilesHash: $lastAvailableFilesHash)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileSelectionStateImpl &&
            (identical(other.isSelectionMode, isSelectionMode) ||
                other.isSelectionMode == isSelectionMode) &&
            const DeepCollectionEquality().equals(
              other._selectedFileIds,
              _selectedFileIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._availableFiles,
              _availableFiles,
            ) &&
            (identical(
                  other.isUpdatingAvailableFiles,
                  isUpdatingAvailableFiles,
                ) ||
                other.isUpdatingAvailableFiles == isUpdatingAvailableFiles) &&
            (identical(other.lastAvailableFilesHash, lastAvailableFilesHash) ||
                other.lastAvailableFilesHash == lastAvailableFilesHash));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isSelectionMode,
    const DeepCollectionEquality().hash(_selectedFileIds),
    const DeepCollectionEquality().hash(_availableFiles),
    isUpdatingAvailableFiles,
    lastAvailableFilesHash,
  );

  /// Create a copy of FileSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileSelectionStateImplCopyWith<_$FileSelectionStateImpl> get copyWith =>
      __$$FileSelectionStateImplCopyWithImpl<_$FileSelectionStateImpl>(
        this,
        _$identity,
      );
}

abstract class _FileSelectionState implements FileSelectionState {
  const factory _FileSelectionState({
    final bool isSelectionMode,
    final Set<String> selectedFileIds,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final List<DocumentModel> availableFiles,
    final bool isUpdatingAvailableFiles,
    final String? lastAvailableFilesHash,
  }) = _$FileSelectionStateImpl;

  @override
  bool get isSelectionMode;
  @override
  Set<String> get selectedFileIds;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<DocumentModel> get availableFiles;
  @override
  bool get isUpdatingAvailableFiles;
  @override
  String? get lastAvailableFilesHash;

  /// Create a copy of FileSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileSelectionStateImplCopyWith<_$FileSelectionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
