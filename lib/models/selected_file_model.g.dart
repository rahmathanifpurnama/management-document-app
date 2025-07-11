// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_file_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SelectedFileModelImpl _$$SelectedFileModelImplFromJson(
  Map<String, dynamic> json,
) => _$SelectedFileModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  path: json['path'] as String,
  size: (json['size'] as num).toInt(),
  type: json['type'] as String,
  selectedAt: DateTime.parse(json['selectedAt'] as String),
  isUploading: json['isUploading'] as bool? ?? false,
  uploadProgress: (json['uploadProgress'] as num?)?.toDouble() ?? 0.0,
  category: json['category'] as String?,
  description: json['description'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$SelectedFileModelImplToJson(
  _$SelectedFileModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'path': instance.path,
  'size': instance.size,
  'type': instance.type,
  'selectedAt': instance.selectedAt.toIso8601String(),
  'isUploading': instance.isUploading,
  'uploadProgress': instance.uploadProgress,
  'category': instance.category,
  'description': instance.description,
  'metadata': instance.metadata,
};
