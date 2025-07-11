// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'selected_file_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SelectedFileModel _$SelectedFileModelFromJson(Map<String, dynamic> json) {
  return _SelectedFileModel.fromJson(json);
}

/// @nodoc
mixin _$SelectedFileModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  DateTime get selectedAt => throw _privateConstructorUsedError;
  bool get isUploading => throw _privateConstructorUsedError;
  double get uploadProgress => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  XFile? get file => throw _privateConstructorUsedError;

  /// Serializes this SelectedFileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SelectedFileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SelectedFileModelCopyWith<SelectedFileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectedFileModelCopyWith<$Res> {
  factory $SelectedFileModelCopyWith(
    SelectedFileModel value,
    $Res Function(SelectedFileModel) then,
  ) = _$SelectedFileModelCopyWithImpl<$Res, SelectedFileModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String path,
    int size,
    String type,
    DateTime selectedAt,
    bool isUploading,
    double uploadProgress,
    String? category,
    String? description,
    Map<String, dynamic>? metadata,
    @JsonKey(includeFromJson: false, includeToJson: false) XFile? file,
  });
}

/// @nodoc
class _$SelectedFileModelCopyWithImpl<$Res, $Val extends SelectedFileModel>
    implements $SelectedFileModelCopyWith<$Res> {
  _$SelectedFileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SelectedFileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? path = null,
    Object? size = null,
    Object? type = null,
    Object? selectedAt = null,
    Object? isUploading = null,
    Object? uploadProgress = null,
    Object? category = freezed,
    Object? description = freezed,
    Object? metadata = freezed,
    Object? file = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            path: null == path
                ? _value.path
                : path // ignore: cast_nullable_to_non_nullable
                      as String,
            size: null == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                      as int,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            selectedAt: null == selectedAt
                ? _value.selectedAt
                : selectedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isUploading: null == isUploading
                ? _value.isUploading
                : isUploading // ignore: cast_nullable_to_non_nullable
                      as bool,
            uploadProgress: null == uploadProgress
                ? _value.uploadProgress
                : uploadProgress // ignore: cast_nullable_to_non_nullable
                      as double,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            file: freezed == file
                ? _value.file
                : file // ignore: cast_nullable_to_non_nullable
                      as XFile?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SelectedFileModelImplCopyWith<$Res>
    implements $SelectedFileModelCopyWith<$Res> {
  factory _$$SelectedFileModelImplCopyWith(
    _$SelectedFileModelImpl value,
    $Res Function(_$SelectedFileModelImpl) then,
  ) = __$$SelectedFileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String path,
    int size,
    String type,
    DateTime selectedAt,
    bool isUploading,
    double uploadProgress,
    String? category,
    String? description,
    Map<String, dynamic>? metadata,
    @JsonKey(includeFromJson: false, includeToJson: false) XFile? file,
  });
}

/// @nodoc
class __$$SelectedFileModelImplCopyWithImpl<$Res>
    extends _$SelectedFileModelCopyWithImpl<$Res, _$SelectedFileModelImpl>
    implements _$$SelectedFileModelImplCopyWith<$Res> {
  __$$SelectedFileModelImplCopyWithImpl(
    _$SelectedFileModelImpl _value,
    $Res Function(_$SelectedFileModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SelectedFileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? path = null,
    Object? size = null,
    Object? type = null,
    Object? selectedAt = null,
    Object? isUploading = null,
    Object? uploadProgress = null,
    Object? category = freezed,
    Object? description = freezed,
    Object? metadata = freezed,
    Object? file = freezed,
  }) {
    return _then(
      _$SelectedFileModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        path: null == path
            ? _value.path
            : path // ignore: cast_nullable_to_non_nullable
                  as String,
        size: null == size
            ? _value.size
            : size // ignore: cast_nullable_to_non_nullable
                  as int,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedAt: null == selectedAt
            ? _value.selectedAt
            : selectedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isUploading: null == isUploading
            ? _value.isUploading
            : isUploading // ignore: cast_nullable_to_non_nullable
                  as bool,
        uploadProgress: null == uploadProgress
            ? _value.uploadProgress
            : uploadProgress // ignore: cast_nullable_to_non_nullable
                  as double,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        file: freezed == file
            ? _value.file
            : file // ignore: cast_nullable_to_non_nullable
                  as XFile?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SelectedFileModelImpl implements _SelectedFileModel {
  const _$SelectedFileModelImpl({
    required this.id,
    required this.name,
    required this.path,
    required this.size,
    required this.type,
    required this.selectedAt,
    this.isUploading = false,
    this.uploadProgress = 0.0,
    this.category,
    this.description,
    final Map<String, dynamic>? metadata,
    @JsonKey(includeFromJson: false, includeToJson: false) this.file,
  }) : _metadata = metadata;

  factory _$SelectedFileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SelectedFileModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String path;
  @override
  final int size;
  @override
  final String type;
  @override
  final DateTime selectedAt;
  @override
  @JsonKey()
  final bool isUploading;
  @override
  @JsonKey()
  final double uploadProgress;
  @override
  final String? category;
  @override
  final String? description;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final XFile? file;

  @override
  String toString() {
    return 'SelectedFileModel(id: $id, name: $name, path: $path, size: $size, type: $type, selectedAt: $selectedAt, isUploading: $isUploading, uploadProgress: $uploadProgress, category: $category, description: $description, metadata: $metadata, file: $file)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectedFileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.selectedAt, selectedAt) ||
                other.selectedAt == selectedAt) &&
            (identical(other.isUploading, isUploading) ||
                other.isUploading == isUploading) &&
            (identical(other.uploadProgress, uploadProgress) ||
                other.uploadProgress == uploadProgress) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.file, file) || other.file == file));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    path,
    size,
    type,
    selectedAt,
    isUploading,
    uploadProgress,
    category,
    description,
    const DeepCollectionEquality().hash(_metadata),
    file,
  );

  /// Create a copy of SelectedFileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectedFileModelImplCopyWith<_$SelectedFileModelImpl> get copyWith =>
      __$$SelectedFileModelImplCopyWithImpl<_$SelectedFileModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SelectedFileModelImplToJson(this);
  }
}

abstract class _SelectedFileModel implements SelectedFileModel {
  const factory _SelectedFileModel({
    required final String id,
    required final String name,
    required final String path,
    required final int size,
    required final String type,
    required final DateTime selectedAt,
    final bool isUploading,
    final double uploadProgress,
    final String? category,
    final String? description,
    final Map<String, dynamic>? metadata,
    @JsonKey(includeFromJson: false, includeToJson: false) final XFile? file,
  }) = _$SelectedFileModelImpl;

  factory _SelectedFileModel.fromJson(Map<String, dynamic> json) =
      _$SelectedFileModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get path;
  @override
  int get size;
  @override
  String get type;
  @override
  DateTime get selectedAt;
  @override
  bool get isUploading;
  @override
  double get uploadProgress;
  @override
  String? get category;
  @override
  String? get description;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  XFile? get file;

  /// Create a copy of SelectedFileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SelectedFileModelImplCopyWith<_$SelectedFileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
