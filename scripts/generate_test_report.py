#!/usr/bin/env python3
"""
Firebase Test Lab Results Report Generator

This script generates an HTML report from Firebase Test Lab test results.
It analyzes test outcomes, performance metrics, and generates visualizations.
"""

import argparse
import json
import os
import sys
import xml.etree.ElementTree as ET
from datetime import datetime
from pathlib import Path
import re

def parse_arguments():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(description='Generate Firebase Test Lab test report')
    parser.add_argument('--results-dir', required=True, help='Directory containing test results')
    parser.add_argument('--output-file', default='test-report.html', help='Output HTML file')
    parser.add_argument('--project-id', required=True, help='Firebase project ID')
    return parser.parse_args()

def find_test_result_files(results_dir):
    """Find all test result files in the results directory."""
    results_dir = Path(results_dir)
    test_files = {
        'xml_results': list(results_dir.glob('**/test_result_*.xml')),
        'logcat_files': list(results_dir.glob('**/logcat')),
        'screenshots': list(results_dir.glob('**/*.png')),
        'videos': list(results_dir.glob('**/*.mp4')),
        'performance': list(results_dir.glob('**/performance_*.json')),
    }
    return test_files

def parse_xml_results(xml_files):
    """Parse XML test result files."""
    test_results = []
    
    for xml_file in xml_files:
        try:
            tree = ET.parse(xml_file)
            root = tree.getroot()
            
            # Extract test suite information
            testsuite = root.find('testsuite')
            if testsuite is not None:
                result = {
                    'file': xml_file.name,
                    'name': testsuite.get('name', 'Unknown'),
                    'tests': int(testsuite.get('tests', 0)),
                    'failures': int(testsuite.get('failures', 0)),
                    'errors': int(testsuite.get('errors', 0)),
                    'time': float(testsuite.get('time', 0)),
                    'timestamp': testsuite.get('timestamp', ''),
                    'test_cases': []
                }
                
                # Extract individual test cases
                for testcase in testsuite.findall('testcase'):
                    case = {
                        'name': testcase.get('name', ''),
                        'classname': testcase.get('classname', ''),
                        'time': float(testcase.get('time', 0)),
                        'status': 'passed'
                    }
                    
                    # Check for failures or errors
                    if testcase.find('failure') is not None:
                        case['status'] = 'failed'
                        case['failure'] = testcase.find('failure').text
                    elif testcase.find('error') is not None:
                        case['status'] = 'error'
                        case['error'] = testcase.find('error').text
                    
                    result['test_cases'].append(case)
                
                test_results.append(result)
                
        except ET.ParseError as e:
            print(f"Error parsing {xml_file}: {e}")
            
    return test_results

def parse_logcat_files(logcat_files):
    """Parse logcat files for errors and performance data."""
    log_analysis = {
        'errors': [],
        'warnings': [],
        'performance_metrics': [],
        'crashes': []
    }
    
    for logcat_file in logcat_files:
        try:
            with open(logcat_file, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
                
                # Extract errors
                error_pattern = r'E/([^:]+):\s*(.+)'
                errors = re.findall(error_pattern, content)
                log_analysis['errors'].extend(errors)
                
                # Extract warnings
                warning_pattern = r'W/([^:]+):\s*(.+)'
                warnings = re.findall(warning_pattern, content)
                log_analysis['warnings'].extend(warnings)
                
                # Extract performance metrics
                perf_pattern = r'PERFORMANCE:\s*(.+)'
                perf_metrics = re.findall(perf_pattern, content)
                log_analysis['performance_metrics'].extend(perf_metrics)
                
                # Check for crashes
                if 'FATAL EXCEPTION' in content or 'AndroidRuntime' in content:
                    log_analysis['crashes'].append(logcat_file.name)
                    
        except Exception as e:
            print(f"Error reading {logcat_file}: {e}")
            
    return log_analysis

def calculate_summary_stats(test_results):
    """Calculate summary statistics from test results."""
    total_tests = sum(result['tests'] for result in test_results)
    total_failures = sum(result['failures'] for result in test_results)
    total_errors = sum(result['errors'] for result in test_results)
    total_time = sum(result['time'] for result in test_results)
    
    success_rate = ((total_tests - total_failures - total_errors) / total_tests * 100) if total_tests > 0 else 0
    
    return {
        'total_tests': total_tests,
        'total_failures': total_failures,
        'total_errors': total_errors,
        'total_time': total_time,
        'success_rate': success_rate,
        'test_suites': len(test_results)
    }

def generate_html_report(test_results, log_analysis, summary_stats, project_id, output_file):
    """Generate HTML report."""
    
    html_template = f"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Firebase Test Lab Report - {project_id}</title>
    <style>
        body {{
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }}
        .container {{
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }}
        .header {{
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #e0e0e0;
        }}
        .summary {{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }}
        .summary-card {{
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
        }}
        .summary-card.success {{
            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
        }}
        .summary-card.failure {{
            background: linear-gradient(135deg, #f44336 0%, #da190b 100%);
        }}
        .summary-card h3 {{
            margin: 0 0 10px 0;
            font-size: 2em;
        }}
        .summary-card p {{
            margin: 0;
            opacity: 0.9;
        }}
        .section {{
            margin-bottom: 30px;
        }}
        .section h2 {{
            color: #333;
            border-bottom: 2px solid #667eea;
            padding-bottom: 10px;
        }}
        table {{
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }}
        th, td {{
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }}
        th {{
            background-color: #f8f9fa;
            font-weight: 600;
        }}
        .status-passed {{
            color: #4CAF50;
            font-weight: bold;
        }}
        .status-failed {{
            color: #f44336;
            font-weight: bold;
        }}
        .status-error {{
            color: #ff9800;
            font-weight: bold;
        }}
        .progress-bar {{
            width: 100%;
            height: 20px;
            background-color: #e0e0e0;
            border-radius: 10px;
            overflow: hidden;
            margin: 10px 0;
        }}
        .progress-fill {{
            height: 100%;
            background: linear-gradient(90deg, #4CAF50 0%, #45a049 100%);
            transition: width 0.3s ease;
        }}
        .error-list {{
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 4px;
            padding: 15px;
            margin: 10px 0;
            max-height: 300px;
            overflow-y: auto;
        }}
        .timestamp {{
            color: #666;
            font-size: 0.9em;
        }}
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Firebase Test Lab Report</h1>
            <p class="timestamp">Generated on {datetime.now().strftime('%Y-%m-%d %H:%M:%S UTC')}</p>
            <p>Project: <strong>{project_id}</strong></p>
        </div>
        
        <div class="summary">
            <div class="summary-card">
                <h3>{summary_stats['total_tests']}</h3>
                <p>Total Tests</p>
            </div>
            <div class="summary-card success">
                <h3>{summary_stats['success_rate']:.1f}%</h3>
                <p>Success Rate</p>
            </div>
            <div class="summary-card failure">
                <h3>{summary_stats['total_failures'] + summary_stats['total_errors']}</h3>
                <p>Failures + Errors</p>
            </div>
            <div class="summary-card">
                <h3>{summary_stats['total_time']:.1f}s</h3>
                <p>Total Time</p>
            </div>
        </div>
        
        <div class="progress-bar">
            <div class="progress-fill" style="width: {summary_stats['success_rate']}%"></div>
        </div>
        
        <div class="section">
            <h2>Test Suite Results</h2>
            <table>
                <thead>
                    <tr>
                        <th>Test Suite</th>
                        <th>Tests</th>
                        <th>Passed</th>
                        <th>Failed</th>
                        <th>Errors</th>
                        <th>Duration</th>
                        <th>Success Rate</th>
                    </tr>
                </thead>
                <tbody>
    """
    
    # Add test suite rows
    for result in test_results:
        passed = result['tests'] - result['failures'] - result['errors']
        suite_success_rate = (passed / result['tests'] * 100) if result['tests'] > 0 else 0
        
        html_template += f"""
                    <tr>
                        <td>{result['name']}</td>
                        <td>{result['tests']}</td>
                        <td class="status-passed">{passed}</td>
                        <td class="status-failed">{result['failures']}</td>
                        <td class="status-error">{result['errors']}</td>
                        <td>{result['time']:.2f}s</td>
                        <td>{suite_success_rate:.1f}%</td>
                    </tr>
        """
    
    html_template += """
                </tbody>
            </table>
        </div>
        
        <div class="section">
            <h2>Detailed Test Cases</h2>
            <table>
                <thead>
                    <tr>
                        <th>Test Case</th>
                        <th>Class</th>
                        <th>Status</th>
                        <th>Duration</th>
                        <th>Details</th>
                    </tr>
                </thead>
                <tbody>
    """
    
    # Add test case rows
    for result in test_results:
        for case in result['test_cases']:
            status_class = f"status-{case['status']}"
            details = case.get('failure', case.get('error', ''))
            
            html_template += f"""
                    <tr>
                        <td>{case['name']}</td>
                        <td>{case['classname']}</td>
                        <td class="{status_class}">{case['status'].upper()}</td>
                        <td>{case['time']:.2f}s</td>
                        <td>{details[:100]}{'...' if len(details) > 100 else ''}</td>
                    </tr>
            """
    
    # Add log analysis section
    html_template += f"""
                </tbody>
            </table>
        </div>
        
        <div class="section">
            <h2>Log Analysis</h2>
            <h3>Errors ({len(log_analysis['errors'])})</h3>
            <div class="error-list">
    """
    
    for tag, message in log_analysis['errors'][:20]:  # Show first 20 errors
        html_template += f"<p><strong>{tag}:</strong> {message[:200]}{'...' if len(message) > 200 else ''}</p>"
    
    html_template += f"""
            </div>
            
            <h3>Warnings ({len(log_analysis['warnings'])})</h3>
            <div class="error-list">
    """
    
    for tag, message in log_analysis['warnings'][:10]:  # Show first 10 warnings
        html_template += f"<p><strong>{tag}:</strong> {message[:200]}{'...' if len(message) > 200 else ''}</p>"
    
    html_template += f"""
            </div>
            
            <h3>Performance Metrics</h3>
            <div class="error-list">
    """
    
    for metric in log_analysis['performance_metrics'][:10]:
        html_template += f"<p>{metric}</p>"
    
    html_template += f"""
            </div>
            
            {f'<h3>Crashes Detected</h3><div class="error-list">{"<br>".join(log_analysis["crashes"])}</div>' if log_analysis['crashes'] else ''}
        </div>
        
        <div class="section">
            <h2>Recommendations</h2>
            <ul>
    """
    
    # Add recommendations based on results
    if summary_stats['success_rate'] < 90:
        html_template += "<li>Success rate is below 90%. Review failed tests and fix issues.</li>"
    
    if log_analysis['crashes']:
        html_template += "<li>Crashes detected. Investigate crash logs and fix critical issues.</li>"
    
    if len(log_analysis['errors']) > 50:
        html_template += "<li>High number of errors detected. Review error logs for patterns.</li>"
    
    if summary_stats['total_time'] > 1800:  # 30 minutes
        html_template += "<li>Test execution time is high. Consider optimizing tests or using parallel execution.</li>"
    
    html_template += """
            </ul>
        </div>
        
        <div class="section">
            <h2>Next Steps</h2>
            <ol>
                <li>Review failed test cases and fix underlying issues</li>
                <li>Analyze performance metrics and optimize slow operations</li>
                <li>Update test configurations based on results</li>
                <li>Schedule regular test runs for continuous monitoring</li>
            </ol>
        </div>
    </div>
</body>
</html>
    """
    
    # Write HTML report
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(html_template)
    
    print(f"Test report generated: {output_file}")

def main():
    """Main function."""
    args = parse_arguments()
    
    if not os.path.exists(args.results_dir):
        print(f"Error: Results directory '{args.results_dir}' does not exist")
        sys.exit(1)
    
    print(f"Analyzing test results in: {args.results_dir}")
    
    # Find test result files
    test_files = find_test_result_files(args.results_dir)
    
    print(f"Found {len(test_files['xml_results'])} XML result files")
    print(f"Found {len(test_files['logcat_files'])} logcat files")
    print(f"Found {len(test_files['screenshots'])} screenshots")
    print(f"Found {len(test_files['videos'])} videos")
    
    # Parse test results
    test_results = parse_xml_results(test_files['xml_results'])
    log_analysis = parse_logcat_files(test_files['logcat_files'])
    summary_stats = calculate_summary_stats(test_results)
    
    # Generate report
    generate_html_report(test_results, log_analysis, summary_stats, args.project_id, args.output_file)
    
    print(f"Summary: {summary_stats['total_tests']} tests, {summary_stats['success_rate']:.1f}% success rate")

if __name__ == '__main__':
    main()
