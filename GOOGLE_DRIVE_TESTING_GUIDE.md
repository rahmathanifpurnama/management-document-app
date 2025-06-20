# Google Drive Integration Testing Guide

## Overview
This guide provides comprehensive testing procedures for the Google Drive integration feature in the Management Document App.

## Prerequisites

### 1. Google Cloud Console Setup
Ensure you have completed the Google Cloud Console setup:
- ✅ Google Drive API enabled
- ✅ OAuth 2.0 credentials configured
- ✅ Android client ID added to google-services.json
- ✅ SHA-1 fingerprint registered

### 2. Device Requirements
- Android device or emulator with Google Play Services
- Internet connection
- Google account for testing

## Testing Scenarios

### Scenario 1: First-Time Authentication
**Objective**: Test Google Sign-In flow for new users

**Steps**:
1. Open the app and navigate to any file list
2. Select a file and tap the share button
3. Choose "Google Drive Link" option
4. Confirm the upload dialog
5. **Expected**: Google Sign-In screen appears
6. Sign in with your Google account
7. Grant permissions for Google Drive access
8. **Expected**: File upload begins automatically

**Success Criteria**:
- ✅ Google Sign-In UI appears
- ✅ Permission dialog shows Google Drive access
- ✅ Authentication completes successfully
- ✅ File upload starts after authentication

### Scenario 2: File Upload Progress
**Objective**: Test upload progress tracking and UI feedback

**Steps**:
1. Select a medium-sized file (1-5MB)
2. Initiate share via Google Drive
3. Observe progress indicators
4. **Expected**: Progress snackbar shows upload status
5. Wait for completion
6. **Expected**: Success message appears

**Success Criteria**:
- ✅ Progress snackbar appears with upload message
- ✅ Loading indicator shows during upload
- ✅ Success message shows after completion
- ✅ Share dialog opens with Google Drive link

### Scenario 3: Large File Upload
**Objective**: Test handling of large files (>5MB)

**Steps**:
1. Select a large file (>5MB)
2. Initiate share via Google Drive
3. Monitor upload progress
4. **Expected**: Chunked upload with progress updates
5. Verify file appears in Google Drive

**Success Criteria**:
- ✅ Upload completes without timeout
- ✅ Progress updates show during upload
- ✅ File is accessible in Google Drive
- ✅ Shareable link works correctly

### Scenario 4: Bulk File Upload
**Objective**: Test multiple file upload functionality

**Steps**:
1. Select multiple files (3-5 files)
2. Use bulk share operation
3. Confirm bulk upload dialog
4. **Expected**: Sequential upload with progress tracking
5. Verify all files uploaded to Google Drive

**Success Criteria**:
- ✅ Bulk upload progress shows current file
- ✅ All selected files are uploaded
- ✅ Share text includes all file links
- ✅ No files are skipped or failed

### Scenario 5: Error Handling
**Objective**: Test error scenarios and recovery

**Test Cases**:

#### 5a. Network Interruption
1. Start file upload
2. Disable internet connection mid-upload
3. **Expected**: Error message appears
4. Re-enable internet and retry
5. **Expected**: Upload resumes or restarts

#### 5b. Authentication Failure
1. Revoke Google Drive permissions in Google account settings
2. Try to share a file
3. **Expected**: Re-authentication prompt appears
4. Complete authentication
5. **Expected**: Upload proceeds normally

#### 5c. Large File Timeout
1. Upload a very large file (>50MB)
2. **Expected**: Appropriate timeout handling
3. **Expected**: Clear error message if timeout occurs

### Scenario 6: UI/UX Validation
**Objective**: Verify user interface improvements

**Checks**:
- ✅ Share button tooltip shows "Upload to Google Drive & Share"
- ✅ Share menu shows Google Drive option with description
- ✅ Confirmation dialog explains upload process
- ✅ Progress messages are clear and informative
- ✅ Success messages mention Google Drive
- ✅ Error messages are user-friendly

### Scenario 7: File Name Handling
**Objective**: Test clean filename preservation

**Steps**:
1. Upload a file with timestamp prefix (e.g., "1234567890_document.pdf")
2. Check uploaded file in Google Drive
3. **Expected**: File name is clean without timestamp
4. Verify shareable link works
5. **Expected**: Downloaded file has clean name

**Success Criteria**:
- ✅ Uploaded file has clean name in Google Drive
- ✅ Original file functionality preserved
- ✅ Download from shared link works correctly

## Performance Testing

### Upload Speed Benchmarks
Test with different file sizes and document results:

| File Size | Expected Upload Time | Actual Time | Status |
|-----------|---------------------|-------------|---------|
| < 1MB     | < 10 seconds        |             |         |
| 1-5MB     | < 30 seconds        |             |         |
| 5-10MB    | < 60 seconds        |             |         |
| > 10MB    | < 120 seconds       |             |         |

### Memory Usage
Monitor app memory usage during:
- Single file upload
- Bulk file upload
- Large file upload

## Troubleshooting Common Issues

### Issue 1: "Failed to sign in to Google Drive"
**Possible Causes**:
- Incorrect OAuth client ID
- Missing SHA-1 fingerprint
- Google Play Services not available

**Solutions**:
- Verify google-services.json configuration
- Check SHA-1 fingerprint in Google Cloud Console
- Test on device with Google Play Services

### Issue 2: "Failed to upload file to Google Drive"
**Possible Causes**:
- Network connectivity issues
- File too large
- Insufficient Google Drive storage

**Solutions**:
- Check internet connection
- Verify file size limits
- Check Google Drive storage quota

### Issue 3: Upload Progress Stuck
**Possible Causes**:
- Network timeout
- Large file processing
- Memory constraints

**Solutions**:
- Implement retry mechanism
- Optimize file processing
- Monitor memory usage

## Validation Checklist

Before marking the feature as complete, ensure:

- [ ] All test scenarios pass
- [ ] Error handling works correctly
- [ ] UI/UX improvements are implemented
- [ ] Performance meets benchmarks
- [ ] Documentation is complete
- [ ] Code follows established patterns
- [ ] No existing functionality is broken

## Next Steps

After successful testing:
1. Deploy to staging environment
2. Conduct user acceptance testing
3. Monitor performance metrics
4. Gather user feedback
5. Plan production deployment

## Support and Maintenance

### Monitoring
- Track upload success rates
- Monitor authentication failures
- Log performance metrics
- User feedback collection

### Updates
- Keep Google APIs updated
- Monitor Google Drive API changes
- Update OAuth scopes if needed
- Maintain error handling improvements
