@echo off
echo ========================================
echo SIMDOC Database Seeder - Installation
echo ========================================
echo.

echo Installing dependencies...
npm install

echo.
echo ========================================
echo Installation completed!
echo ========================================
echo.
echo Next steps:
echo 1. Download Firebase service account key
echo 2. Rename it to 'credentials.json'
echo 3. Place it in this folder
echo 4. Run 'npm run seed:all' to seed all data
echo.
pause
