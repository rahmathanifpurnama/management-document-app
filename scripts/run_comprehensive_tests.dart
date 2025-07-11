import 'dart:io';
import 'dart:convert';

void main(List<String> args) async {
  print('🧪 Starting Comprehensive Test Suite...');
  
  final testRunner = ComprehensiveTestRunner();
  
  // Parse command line arguments
  final options = TestOptions.fromArgs(args);
  
  // Run test suite
  await testRunner.runAllTests(options);
  
  print('✅ Comprehensive testing completed!');
}

class ComprehensiveTestRunner {
  final Map<String, TestResult> results = {};
  
  Future<void> runAllTests(TestOptions options) async {
    // Create test results directory
    await _createTestResultsDirectory();
    
    // Run different test categories
    if (options.runUnit) {
      await _runUnitTests();
    }
    
    if (options.runIntegration) {
      await _runIntegrationTests();
    }
    
    if (options.runE2E) {
      await _runE2ETests();
    }
    
    if (options.runPerformance) {
      await _runPerformanceTests();
    }
    
    // Generate comprehensive report
    await _generateComprehensiveReport();
    
    // Check if all tests passed
    _checkOverallStatus();
  }
  
  Future<void> _createTestResultsDirectory() async {
    final dir = Directory('test_results/comprehensive');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }
  
  Future<void> _runUnitTests() async {
    print('\n🔬 Running Unit Tests...');
    
    final unitTestDirs = [
      'test/unit/riverpod',
      'test/unit/bloc',
      'test/unit/models',
      'test/unit/services',
    ];
    
    for (final dir in unitTestDirs) {
      if (await Directory(dir).exists()) {
        await _runTestsInDirectory(dir, 'unit');
      }
    }
  }
  
  Future<void> _runIntegrationTests() async {
    print('\n🔗 Running Integration Tests...');
    
    final integrationTestDirs = [
      'test/integration',
    ];
    
    for (final dir in integrationTestDirs) {
      if (await Directory(dir).exists()) {
        await _runTestsInDirectory(dir, 'integration');
      }
    }
  }
  
  Future<void> _runE2ETests() async {
    print('\n🎯 Running End-to-End Tests...');
    
    final e2eTestDirs = [
      'test/e2e',
    ];
    
    for (final dir in e2eTestDirs) {
      if (await Directory(dir).exists()) {
        await _runTestsInDirectory(dir, 'e2e');
      }
    }
  }
  
  Future<void> _runPerformanceTests() async {
    print('\n⚡ Running Performance Tests...');
    
    // Run performance benchmarking
    try {
      final result = await Process.run(
        'dart',
        ['scripts/benchmark_performance.dart'],
        workingDirectory: '.',
      );
      
      results['performance_benchmark'] = TestResult(
        category: 'performance',
        name: 'performance_benchmark',
        passed: result.exitCode == 0,
        duration: Duration.zero,
        output: result.stdout.toString(),
        error: result.stderr.toString(),
      );
      
      print('✅ Performance benchmarking completed');
    } catch (e) {
      print('❌ Performance benchmarking failed: $e');
      results['performance_benchmark'] = TestResult(
        category: 'performance',
        name: 'performance_benchmark',
        passed: false,
        duration: Duration.zero,
        output: '',
        error: e.toString(),
      );
    }
    
    // Run performance-specific integration tests
    if (await Directory('test/integration/performance').exists()) {
      await _runTestsInDirectory('test/integration/performance', 'performance');
    }
  }
  
  Future<void> _runTestsInDirectory(String directory, String category) async {
    print('  📁 Testing $directory...');
    
    final stopwatch = Stopwatch()..start();
    
    try {
      final result = await Process.run(
        'flutter',
        ['test', directory, '--reporter=json'],
        workingDirectory: '.',
      );
      
      stopwatch.stop();
      
      final testResult = TestResult(
        category: category,
        name: directory,
        passed: result.exitCode == 0,
        duration: stopwatch.elapsed,
        output: result.stdout.toString(),
        error: result.stderr.toString(),
      );
      
      results[directory] = testResult;
      
      final status = testResult.passed ? '✅' : '❌';
      print('  $status $directory (${stopwatch.elapsedMilliseconds}ms)');
      
      // Save individual test results
      await _saveTestResult(directory, testResult);
      
    } catch (e) {
      stopwatch.stop();
      
      results[directory] = TestResult(
        category: category,
        name: directory,
        passed: false,
        duration: stopwatch.elapsed,
        output: '',
        error: e.toString(),
      );
      
      print('  ❌ $directory failed: $e');
    }
  }
  
  Future<void> _saveTestResult(String testName, TestResult result) async {
    final fileName = testName.replaceAll('/', '_').replaceAll('\\', '_');
    final file = File('test_results/comprehensive/${fileName}_result.json');
    
    final resultData = {
      'category': result.category,
      'name': result.name,
      'passed': result.passed,
      'duration_ms': result.duration.inMilliseconds,
      'timestamp': DateTime.now().toIso8601String(),
      'output': result.output,
      'error': result.error,
    };
    
    await file.writeAsString(jsonEncode(resultData));
  }
  
  Future<void> _generateComprehensiveReport() async {
    print('\n📊 Generating Comprehensive Test Report...');
    
    final report = {
      'timestamp': DateTime.now().toIso8601String(),
      'architecture': 'Riverpod + BLoC Hybrid',
      'total_tests': results.length,
      'passed_tests': results.values.where((r) => r.passed).length,
      'failed_tests': results.values.where((r) => !r.passed).length,
      'total_duration_ms': results.values
          .map((r) => r.duration.inMilliseconds)
          .fold(0, (a, b) => a + b),
      'categories': _generateCategoryReport(),
      'detailed_results': results.map((key, value) => MapEntry(key, {
        'category': value.category,
        'passed': value.passed,
        'duration_ms': value.duration.inMilliseconds,
        'error': value.error,
      })),
    };
    
    // Save comprehensive report
    final file = File('test_results/comprehensive/comprehensive_report.json');
    await file.writeAsString(jsonEncode(report));
    
    // Print summary
    _printTestSummary(report);
    
    print('\n📄 Comprehensive report saved to: test_results/comprehensive/comprehensive_report.json');
  }
  
  Map<String, dynamic> _generateCategoryReport() {
    final categories = <String, Map<String, int>>{};
    
    for (final result in results.values) {
      if (!categories.containsKey(result.category)) {
        categories[result.category] = {'total': 0, 'passed': 0, 'failed': 0};
      }
      
      categories[result.category]!['total'] = categories[result.category]!['total']! + 1;
      
      if (result.passed) {
        categories[result.category]!['passed'] = categories[result.category]!['passed']! + 1;
      } else {
        categories[result.category]!['failed'] = categories[result.category]!['failed']! + 1;
      }
    }
    
    return categories;
  }
  
  void _printTestSummary(Map<String, dynamic> report) {
    print('\n📈 COMPREHENSIVE TEST SUMMARY:');
    print('=' * 60);
    print('Total Tests: ${report['total_tests']}');
    print('Passed: ${report['passed_tests']}');
    print('Failed: ${report['failed_tests']}');
    print('Success Rate: ${((report['passed_tests'] / report['total_tests']) * 100).toStringAsFixed(1)}%');
    print('Total Duration: ${report['total_duration_ms']}ms');
    
    print('\n📊 BY CATEGORY:');
    final categories = report['categories'] as Map<String, dynamic>;
    for (final entry in categories.entries) {
      final category = entry.key;
      final data = entry.value as Map<String, dynamic>;
      final successRate = ((data['passed'] / data['total']) * 100).toStringAsFixed(1);
      
      print('  $category: ${data['passed']}/${data['total']} ($successRate%)');
    }
    
    if (report['failed_tests'] > 0) {
      print('\n❌ FAILED TESTS:');
      for (final entry in results.entries) {
        if (!entry.value.passed) {
          print('  - ${entry.key}: ${entry.value.error}');
        }
      }
    }
  }
  
  void _checkOverallStatus() {
    final totalTests = results.length;
    final passedTests = results.values.where((r) => r.passed).length;
    
    if (passedTests == totalTests) {
      print('\n🎉 ALL TESTS PASSED! Architecture migration is successful.');
      exit(0);
    } else {
      print('\n⚠️ Some tests failed. Please review the results and fix issues.');
      exit(1);
    }
  }
}

class TestOptions {
  final bool runUnit;
  final bool runIntegration;
  final bool runE2E;
  final bool runPerformance;
  
  TestOptions({
    this.runUnit = true,
    this.runIntegration = true,
    this.runE2E = true,
    this.runPerformance = true,
  });
  
  factory TestOptions.fromArgs(List<String> args) {
    return TestOptions(
      runUnit: !args.contains('--skip-unit'),
      runIntegration: !args.contains('--skip-integration'),
      runE2E: !args.contains('--skip-e2e'),
      runPerformance: !args.contains('--skip-performance'),
    );
  }
}

class TestResult {
  final String category;
  final String name;
  final bool passed;
  final Duration duration;
  final String output;
  final String error;
  
  TestResult({
    required this.category,
    required this.name,
    required this.passed,
    required this.duration,
    required this.output,
    required this.error,
  });
}
