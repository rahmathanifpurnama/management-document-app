// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_file_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UploadFileModelImpl _$$UploadFileModelImplFromJson(
  Map<String, dynamic> json,
) => _$UploadFileModelImpl(
  id: json['id'] as String,
  fileName: json['fileName'] as String,
  fileSize: (json['fileSize'] as num).toInt(),
  fileType: json['fileType'] as String,
  mimeType: json['mimeType'] as String,
  status:
      $enumDecodeNullable(_$UploadStatusEnumMap, json['status']) ??
      UploadStatus.pending,
  progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
  bytesUploaded: (json['bytesUploaded'] as num?)?.toInt() ?? 0,
  uploadSpeed: (json['uploadSpeed'] as num?)?.toInt(),
  estimatedTimeRemaining: (json['estimatedTimeRemaining'] as num?)?.toInt(),
  errorMessage: json['errorMessage'] as String?,
  retryAttempts: (json['retryAttempts'] as num?)?.toInt() ?? 0,
  maxRetryAttempts: (json['maxRetryAttempts'] as num?)?.toInt() ?? 3,
  categoryId: json['categoryId'] as String?,
  customMetadata: (json['customMetadata'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  downloadUrl: json['downloadUrl'] as String?,
  documentId: json['documentId'] as String?,
  startTime: json['startTime'] == null
      ? null
      : DateTime.parse(json['startTime'] as String),
  completionTime: json['completionTime'] == null
      ? null
      : DateTime.parse(json['completionTime'] as String),
  fileHash: json['fileHash'] as String?,
  validationErrors: (json['validationErrors'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$$UploadFileModelImplToJson(
  _$UploadFileModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'fileName': instance.fileName,
  'fileSize': instance.fileSize,
  'fileType': instance.fileType,
  'mimeType': instance.mimeType,
  'status': _$UploadStatusEnumMap[instance.status]!,
  'progress': instance.progress,
  'bytesUploaded': instance.bytesUploaded,
  'uploadSpeed': instance.uploadSpeed,
  'estimatedTimeRemaining': instance.estimatedTimeRemaining,
  'errorMessage': instance.errorMessage,
  'retryAttempts': instance.retryAttempts,
  'maxRetryAttempts': instance.maxRetryAttempts,
  'categoryId': instance.categoryId,
  'customMetadata': instance.customMetadata,
  'downloadUrl': instance.downloadUrl,
  'documentId': instance.documentId,
  'startTime': instance.startTime?.toIso8601String(),
  'completionTime': instance.completionTime?.toIso8601String(),
  'fileHash': instance.fileHash,
  'validationErrors': instance.validationErrors,
};

const _$UploadStatusEnumMap = {
  UploadStatus.pending: 'pending',
  UploadStatus.validating: 'validating',
  UploadStatus.uploading: 'uploading',
  UploadStatus.paused: 'paused',
  UploadStatus.completed: 'completed',
  UploadStatus.failed: 'failed',
  UploadStatus.cancelled: 'cancelled',
};
