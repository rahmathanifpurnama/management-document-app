// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UploadResultImpl _$$UploadResultImplFromJson(Map<String, dynamic> json) =>
    _$UploadResultImpl(
      success: json['success'] as bool,
      fileId: json['fileId'] as String,
      fileName: json['fileName'] as String,
      downloadUrl: json['downloadUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      error: json['error'] as String?,
      errorCode: json['errorCode'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      fileSize: (json['fileSize'] as num?)?.toInt() ?? 0,
      uploadedAt: json['uploadedAt'] == null
          ? null
          : DateTime.parse(json['uploadedAt'] as String),
      category: json['category'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$UploadResultImplToJson(_$UploadResultImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'fileId': instance.fileId,
      'fileName': instance.fileName,
      'downloadUrl': instance.downloadUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'error': instance.error,
      'errorCode': instance.errorCode,
      'metadata': instance.metadata,
      'fileSize': instance.fileSize,
      'uploadedAt': instance.uploadedAt?.toIso8601String(),
      'category': instance.category,
      'description': instance.description,
    };

_$BatchUploadResultImpl _$$BatchUploadResultImplFromJson(
  Map<String, dynamic> json,
) => _$BatchUploadResultImpl(
  results: (json['results'] as List<dynamic>)
      .map((e) => UploadResult.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalFiles: (json['totalFiles'] as num).toInt(),
  successCount: (json['successCount'] as num).toInt(),
  failureCount: (json['failureCount'] as num).toInt(),
  errors:
      (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$$BatchUploadResultImplToJson(
  _$BatchUploadResultImpl instance,
) => <String, dynamic>{
  'results': instance.results,
  'totalFiles': instance.totalFiles,
  'successCount': instance.successCount,
  'failureCount': instance.failureCount,
  'errors': instance.errors,
  'completedAt': instance.completedAt?.toIso8601String(),
};
