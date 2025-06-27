# PowerShell script to test Firebase Functions
Write-Host "🔍 Testing Firebase Functions in Production..." -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan

$PROJECT_ID = "document-management-c5a96"
$REGION = "us-central1"
$BASE_URL = "https://$REGION-$PROJECT_ID.cloudfunctions.net"

# Function to make HTTP request
function Invoke-FunctionTest {
    param(
        [string]$FunctionName,
        [string]$Data = '{"data":{}}'
    )
    
    Write-Host ""
    Write-Host "📊 Testing $FunctionName..." -ForegroundColor Yellow
    Write-Host "======================================" -ForegroundColor Yellow
    
    try {
        $response = Invoke-RestMethod -Uri "$BASE_URL/$FunctionName" -Method Post -ContentType "application/json" -Body $Data
        Write-Host "✅ Success:" -ForegroundColor Green
        $response | ConvertTo-Json -Depth 10
    }
    catch {
        Write-Host "❌ Error:" -ForegroundColor Red
        Write-Host $_.Exception.Message
        if ($_.Exception.Response) {
            $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            $responseBody = $reader.ReadToEnd()
            Write-Host "Response Body: $responseBody"
        }
    }
}

# Test functions
Invoke-FunctionTest -FunctionName "getAggregatedStatistics"
Invoke-FunctionTest -FunctionName "getPaginatedFileStats" -Data '{"data":{"page":1,"limit":10}}'
Invoke-FunctionTest -FunctionName "checkDataIntegrity"
Invoke-FunctionTest -FunctionName "performComprehensiveSync"

Write-Host ""
Write-Host "✅ All function tests completed!" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
