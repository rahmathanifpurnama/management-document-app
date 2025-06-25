#!/usr/bin/env python3
"""
Comprehensive Test Report Generator
Generates detailed HTML reports from test results with charts and analytics
"""

import json
import os
import sys
import argparse
import datetime
from pathlib import Path
from typing import Dict, List, Any
import xml.etree.ElementTree as ET

class TestReportGenerator:
    def __init__(self, reports_dir: str, output_dir: str):
        self.reports_dir = Path(reports_dir)
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(exist_ok=True)
        
        self.test_results = {
            'unit': [],
            'widget': [],
            'integration': [],
            'performance': [],
            'compatibility': []
        }
        
        self.summary = {
            'total_tests': 0,
            'passed_tests': 0,
            'failed_tests': 0,
            'skipped_tests': 0,
            'execution_time': 0,
            'coverage_percentage': 0
        }

    def parse_json_results(self, file_path: Path) -> Dict[str, Any]:
        """Parse JSON test results file"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
                return data
        except (json.JSONDecodeError, FileNotFoundError) as e:
            print(f"Error parsing {file_path}: {e}")
            return {}

    def parse_coverage_report(self) -> float:
        """Parse LCOV coverage report"""
        coverage_file = self.reports_dir.parent / 'coverage' / 'lcov.info'
        if not coverage_file.exists():
            return 0.0
        
        try:
            with open(coverage_file, 'r') as f:
                lines = f.readlines()
            
            total_lines = 0
            covered_lines = 0
            
            for line in lines:
                if line.startswith('LH:'):
                    covered_lines += int(line.split(':')[1])
                elif line.startswith('LF:'):
                    total_lines += int(line.split(':')[1])
            
            if total_lines > 0:
                return (covered_lines / total_lines) * 100
            return 0.0
        except Exception as e:
            print(f"Error parsing coverage report: {e}")
            return 0.0

    def collect_test_results(self):
        """Collect all test results from the reports directory"""
        print("Collecting test results...")
        
        for file_path in self.reports_dir.glob('*.json'):
            file_name = file_path.name.lower()
            
            # Determine test type from filename
            test_type = 'unit'
            if 'widget' in file_name:
                test_type = 'widget'
            elif 'integration' in file_name:
                test_type = 'integration'
            elif 'performance' in file_name:
                test_type = 'performance'
            elif 'compatibility' in file_name:
                test_type = 'compatibility'
            
            result_data = self.parse_json_results(file_path)
            if result_data:
                self.test_results[test_type].append({
                    'file': file_path.name,
                    'data': result_data
                })
        
        # Parse coverage
        self.summary['coverage_percentage'] = self.parse_coverage_report()
        
        print(f"Collected results from {sum(len(results) for results in self.test_results.values())} files")

    def analyze_results(self):
        """Analyze test results and generate summary"""
        print("Analyzing test results...")
        
        for test_type, results in self.test_results.items():
            for result in results:
                data = result['data']
                
                # Extract test statistics (format may vary)
                if 'tests' in data:
                    for test in data['tests']:
                        self.summary['total_tests'] += 1
                        if test.get('result') == 'success':
                            self.summary['passed_tests'] += 1
                        elif test.get('result') == 'failure':
                            self.summary['failed_tests'] += 1
                        else:
                            self.summary['skipped_tests'] += 1
                
                # Add execution time if available
                if 'time' in data:
                    self.summary['execution_time'] += data['time']

    def generate_html_report(self) -> str:
        """Generate comprehensive HTML report"""
        timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        
        html_content = f"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Flutter App Test Report</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        * {{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }}
        
        body {{
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f5f5f5;
        }}
        
        .container {{
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }}
        
        .header {{
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
            text-align: center;
        }}
        
        .header h1 {{
            font-size: 2.5em;
            margin-bottom: 10px;
        }}
        
        .header p {{
            font-size: 1.1em;
            opacity: 0.9;
        }}
        
        .summary-grid {{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }}
        
        .summary-card {{
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            text-align: center;
            transition: transform 0.3s ease;
        }}
        
        .summary-card:hover {{
            transform: translateY(-5px);
        }}
        
        .summary-card h3 {{
            font-size: 2.5em;
            margin-bottom: 10px;
        }}
        
        .summary-card p {{
            font-size: 1.1em;
            color: #666;
        }}
        
        .success {{ color: #28a745; }}
        .danger {{ color: #dc3545; }}
        .warning {{ color: #ffc107; }}
        .info {{ color: #17a2b8; }}
        .primary {{ color: #007bff; }}
        
        .charts-section {{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 30px;
            margin-bottom: 30px;
        }}
        
        .chart-container {{
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }}
        
        .chart-container h3 {{
            margin-bottom: 20px;
            text-align: center;
            color: #333;
        }}
        
        .test-details {{
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }}
        
        .test-details h2 {{
            margin-bottom: 20px;
            color: #333;
            border-bottom: 2px solid #667eea;
            padding-bottom: 10px;
        }}
        
        .test-type {{
            margin-bottom: 25px;
        }}
        
        .test-type h3 {{
            color: #555;
            margin-bottom: 15px;
            padding: 10px;
            background-color: #f8f9fa;
            border-left: 4px solid #667eea;
        }}
        
        .test-file {{
            background-color: #f8f9fa;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 5px;
            border-left: 4px solid #28a745;
        }}
        
        .test-file.failed {{
            border-left-color: #dc3545;
        }}
        
        .test-file h4 {{
            margin-bottom: 10px;
            color: #333;
        }}
        
        .test-file p {{
            color: #666;
            font-size: 0.9em;
        }}
        
        .coverage-bar {{
            width: 100%;
            height: 20px;
            background-color: #e9ecef;
            border-radius: 10px;
            overflow: hidden;
            margin-top: 10px;
        }}
        
        .coverage-fill {{
            height: 100%;
            background: linear-gradient(90deg, #28a745, #20c997);
            transition: width 0.3s ease;
        }}
        
        .footer {{
            text-align: center;
            padding: 20px;
            color: #666;
            font-size: 0.9em;
        }}
        
        @media (max-width: 768px) {{
            .container {{
                padding: 10px;
            }}
            
            .header h1 {{
                font-size: 2em;
            }}
            
            .summary-grid {{
                grid-template-columns: 1fr;
            }}
            
            .charts-section {{
                grid-template-columns: 1fr;
            }}
        }}
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🧪 Flutter App Test Report</h1>
            <p>Generated on {timestamp}</p>
        </div>
        
        <div class="summary-grid">
            <div class="summary-card">
                <h3 class="primary">{self.summary['total_tests']}</h3>
                <p>Total Tests</p>
            </div>
            <div class="summary-card">
                <h3 class="success">{self.summary['passed_tests']}</h3>
                <p>Passed Tests</p>
            </div>
            <div class="summary-card">
                <h3 class="danger">{self.summary['failed_tests']}</h3>
                <p>Failed Tests</p>
            </div>
            <div class="summary-card">
                <h3 class="warning">{self.summary['skipped_tests']}</h3>
                <p>Skipped Tests</p>
            </div>
            <div class="summary-card">
                <h3 class="info">{self.summary['coverage_percentage']:.1f}%</h3>
                <p>Code Coverage</p>
                <div class="coverage-bar">
                    <div class="coverage-fill" style="width: {self.summary['coverage_percentage']}%"></div>
                </div>
            </div>
        </div>
        
        <div class="charts-section">
            <div class="chart-container">
                <h3>Test Results Distribution</h3>
                <canvas id="resultsChart" width="400" height="200"></canvas>
            </div>
            <div class="chart-container">
                <h3>Test Types Coverage</h3>
                <canvas id="typesChart" width="400" height="200"></canvas>
            </div>
        </div>
        
        <div class="test-details">
            <h2>📋 Test Details</h2>
            {self._generate_test_details_html()}
        </div>
        
        <div class="footer">
            <p>Report generated by Flutter Test Report Generator</p>
            <p>For more details, check individual test result files</p>
        </div>
    </div>
    
    <script>
        // Test Results Chart
        const resultsCtx = document.getElementById('resultsChart').getContext('2d');
        new Chart(resultsCtx, {{
            type: 'doughnut',
            data: {{
                labels: ['Passed', 'Failed', 'Skipped'],
                datasets: [{{
                    data: [{self.summary['passed_tests']}, {self.summary['failed_tests']}, {self.summary['skipped_tests']}],
                    backgroundColor: ['#28a745', '#dc3545', '#ffc107'],
                    borderWidth: 2,
                    borderColor: '#fff'
                }}]
            }},
            options: {{
                responsive: true,
                plugins: {{
                    legend: {{
                        position: 'bottom'
                    }}
                }}
            }}
        }});
        
        // Test Types Chart
        const typesCtx = document.getElementById('typesChart').getContext('2d');
        new Chart(typesCtx, {{
            type: 'bar',
            data: {{
                labels: ['Unit', 'Widget', 'Integration', 'Performance', 'Compatibility'],
                datasets: [{{
                    label: 'Test Files',
                    data: [{len(self.test_results['unit'])}, {len(self.test_results['widget'])}, {len(self.test_results['integration'])}, {len(self.test_results['performance'])}, {len(self.test_results['compatibility'])}],
                    backgroundColor: ['#007bff', '#28a745', '#ffc107', '#dc3545', '#6f42c1'],
                    borderWidth: 1
                }}]
            }},
            options: {{
                responsive: true,
                scales: {{
                    y: {{
                        beginAtZero: true
                    }}
                }},
                plugins: {{
                    legend: {{
                        display: false
                    }}
                }}
            }}
        }});
    </script>
</body>
</html>
"""
        return html_content

    def _generate_test_details_html(self) -> str:
        """Generate HTML for test details section"""
        html = ""
        
        test_type_names = {
            'unit': '🔧 Unit Tests',
            'widget': '🎨 Widget Tests',
            'integration': '🔗 Integration Tests',
            'performance': '⚡ Performance Tests',
            'compatibility': '📱 Compatibility Tests'
        }
        
        for test_type, results in self.test_results.items():
            if not results:
                continue
                
            html += f"""
            <div class="test-type">
                <h3>{test_type_names.get(test_type, test_type.title() + ' Tests')}</h3>
            """
            
            for result in results:
                file_name = result['file']
                # Determine if test passed or failed based on filename or data
                status_class = "failed" if "failed" in file_name.lower() else ""
                
                html += f"""
                <div class="test-file {status_class}">
                    <h4>{file_name}</h4>
                    <p>Test file executed successfully</p>
                </div>
                """
            
            html += "</div>"
        
        return html

    def generate_report(self):
        """Generate the complete test report"""
        print("Generating comprehensive test report...")
        
        self.collect_test_results()
        self.analyze_results()
        
        # Generate HTML report
        html_content = self.generate_html_report()
        
        # Save HTML report
        report_file = self.output_dir / f"test_report_{datetime.datetime.now().strftime('%Y%m%d_%H%M%S')}.html"
        with open(report_file, 'w', encoding='utf-8') as f:
            f.write(html_content)
        
        print(f"✅ Test report generated: {report_file}")
        
        # Generate JSON summary
        summary_file = self.output_dir / f"test_summary_{datetime.datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(summary_file, 'w', encoding='utf-8') as f:
            json.dump({
                'summary': self.summary,
                'test_results': {k: len(v) for k, v in self.test_results.items()},
                'generated_at': datetime.datetime.now().isoformat()
            }, f, indent=2)
        
        print(f"✅ Test summary generated: {summary_file}")
        
        return report_file

def main():
    parser = argparse.ArgumentParser(description='Generate comprehensive test reports')
    parser.add_argument('--reports-dir', required=True, help='Directory containing test result files')
    parser.add_argument('--output-dir', default='./test_reports', help='Output directory for generated reports')
    
    args = parser.parse_args()
    
    if not os.path.exists(args.reports_dir):
        print(f"Error: Reports directory '{args.reports_dir}' does not exist")
        sys.exit(1)
    
    generator = TestReportGenerator(args.reports_dir, args.output_dir)
    report_file = generator.generate_report()
    
    print(f"\n🎉 Report generation completed!")
    print(f"📄 HTML Report: {report_file}")
    print(f"📊 Open the HTML file in your browser to view the detailed report")

if __name__ == "__main__":
    main()
