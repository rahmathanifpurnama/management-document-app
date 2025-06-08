echo off
echo Testing Cloud Functions Build...

cd functions

echo Installing dependencies...
call npm install

echo Building TypeScript...
call npm run build

echo Build completed!
pause
