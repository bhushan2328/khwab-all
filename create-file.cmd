@e creofffile.cmd file_pathecho     exit /b 1echo )echo if .cmd file_pathecho     exit /b 1echo )echo if not exist "%%~dp1" mkdir "%%~dp1"echo copy con "%%~1"
