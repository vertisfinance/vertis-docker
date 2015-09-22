REM Suggested SDK/Compiler: http://www.microsoft.com/en-us/download/confirmation.aspx?id=8279
REM Run this within: Windows SDK 7.1 Command Prompt
@ECHO OFF
call setenv /x64 /release
set BLPAPI_ROOT=c:\src\blpapi_cpp_3.7.9.1
python setup.py build --compiler msvc
python setup.py install
