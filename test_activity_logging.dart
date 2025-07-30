import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:managementdoc/services/activity_service.dart';

/// Simple test script to verify activity logging works with fixed timestamp
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🧪 Testing Activity Logging with Fixed Timestamp...');
  
  try {
    // Initialize ActivityService
    final activityService = ActivityService();
    
    // Test 1: Basic activity logging
    print('\n📝 Test 1: Basic activity logging');
    await activityService.logActivity(
      type: 'test',
      description: 'Testing activity logging with fixed timestamp',
      additionalData: {
        'testType': 'timestamp_fix_verification',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    print('✅ Test 1 completed - Basic activity logged');
    
    // Test 2: Activity with document ID
    print('\n📝 Test 2: Activity with document ID');
    await activityService.logActivity(
      type: 'upload',
      description: 'Test file upload activity',
      documentId: 'test-doc-123',
      additionalData: {
        'fileName': 'test-document.pdf',
        'fileSize': 1024,
        'testType': 'document_activity',
      },
    );
    print('✅ Test 2 completed - Document activity logged');
    
    // Test 3: Activity with category ID
    print('\n📝 Test 3: Activity with category ID');
    await activityService.logActivity(
      type: 'create',
      description: 'Test category creation activity',
      categoryId: 'test-category-456',
      additionalData: {
        'categoryName': 'Test Category',
        'testType': 'category_activity',
      },
    );
    print('✅ Test 3 completed - Category activity logged');
    
    // Wait a moment for Firestore to process
    await Future.delayed(Duration(seconds: 2));
    
    // Test 4: Verify activities were created
    print('\n🔍 Test 4: Verifying activities in Firestore');
    final recentActivities = await FirebaseFirestore.instance
        .collection('activities')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .get();
    
    print('📊 Found ${recentActivities.docs.length} recent activities');
    
    // Look for our test activities
    int testActivitiesFound = 0;
    for (var doc in recentActivities.docs) {
      final data = doc.data();
      if (data['description']?.toString().contains('Test') == true ||
          data['additionalData']?['testType'] != null) {
        testActivitiesFound++;
        print('✅ Found test activity: ${data['type']} - ${data['description']}');
      }
    }
    
    print('\n🎯 Test Results:');
    print('   - Test activities found: $testActivitiesFound');
    print('   - Expected: 3');
    
    if (testActivitiesFound >= 3) {
      print('🎉 SUCCESS: Activity logging is working correctly!');
    } else {
      print('⚠️  WARNING: Some test activities may not have been saved');
    }
    
  } catch (e) {
    print('❌ ERROR during testing: $e');
    
    // Check if it's a permission error
    if (e.toString().contains('PERMISSION_DENIED')) {
      print('\n🔍 PERMISSION_DENIED detected - this indicates:');
      print('   1. User may not be authenticated');
      print('   2. Firestore rules may still have issues');
      print('   3. Required fields may be missing');
      
      // Check current user
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('   ❌ No authenticated user found');
      } else {
        print('   ✅ User authenticated: ${currentUser.email}');
      }
    }
  }
  
  print('\n🏁 Test completed');
}

/// Helper function to test direct Firestore write
Future<void> testDirectFirestoreWrite() async {
  print('\n🔧 Testing direct Firestore write...');
  
  try {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print('❌ No authenticated user for direct test');
      return;
    }
    
    final testData = {
      'type': 'direct_test',
      'description': 'Direct Firestore write test',
      'userId': currentUser.uid,
      'timestamp': Timestamp.now(),
    };
    
    await FirebaseFirestore.instance
        .collection('activities')
        .add(testData);
    
    print('✅ Direct Firestore write successful');
    
  } catch (e) {
    print('❌ Direct Firestore write failed: $e');
  }
}
