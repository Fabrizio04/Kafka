@echo off
cls

echo === CERTIFICATE GENERATOR FOR KAFKA ===
pause
echo.

set au_key="%~dp0\root.key"
set au_crt="%~dp0\root.crt"

set myopenssl="C:\Program Files\OpenSSL-Win64\bin\openssl.exe"
set mykeytool="%JAVA_HOME%\bin\keytool.exe"

:setmyopenssl
if not exist %myopenssl% (
 echo.
 echo OpenSSL not found on default path.
 set /p myopenssl= Please insert full executable file path: || set myopenssl=NothingChosen
)

if '%myopenssl%'=='NothingChosen' goto setmyopenssl
if not exist %myopenssl% goto setmyopenssl

:setmykeytool
if not exist %mykeytool% (
 echo.
 echo Java Keytool not found on default path.
 set /p mykeytool= Please insert full executable file path: || set mykeytool=NothingChosen
)

if '%mykeytool%'=='NothingChosen' goto setmykeytool
if not exist %mykeytool% goto setmykeytool

if exist %au_key% (
 if exist %au_crt% (
  echo.
  echo CA available
  goto autorityok
 ) else (
  echo.
  echo CA not available
  goto autority
 )
) else (
 echo.
 echo CA not available
 goto autority
)

:autority
set /p scelta= Generate new CA ? (y/n): || set scelta=NothingChosen

if '%scelta%'=='y' (
 echo.
 echo === Generate new Certificate Authority ===
 echo.
 echo Generate private key...
 %myopenssl% genrsa -out "%~dp0\root.key"
 echo.
 echo Generate CA certificate...
 %myopenssl% req -new -x509 -key "%~dp0\root.key" -out "%~dp0\root.crt" -subj "/C=IT/ST=Italia/L=Bologna/O=Fabrizio/OU=Fabrizio/CN=kafka-test/emailAddress=postmaster@localhost"
 goto autorityok
)

if '%scelta%'=='n' (
 echo.
 echo Bye!
 echo Press any key to close...
 pause>nul
 exit
)

goto autority

:autorityok
echo.
echo Generate Truststore
%mykeytool% -keystore "%~dp0\kafka.truststore.jks" -alias CARoot -import -file "%~dp0\root.crt" -dname "CN=kafka-test, OU=Fabrizio, O=Fabrizio, L=Bologna, S=Italy, C=IT" -noprompt

echo.
echo Generate Keystore 
%mykeytool% -keystore "%~dp0\kafka01.keystore.jks" -alias localhost -validity 365 -genkey -keyalg RSA -ext SAN=DNS:kafka-test -dname "CN=kafka-test, OU=Fabrizio, O=Fabrizio, L=Bologna, S=Italy, C=IT" -noprompt

echo.
echo Export certificate
%mykeytool% -keystore "%~dp0\kafka01.keystore.jks" -alias localhost -certreq -file "%~dp0\kafka01.unsigned.crt"

echo.
echo Sign certificate
%myopenssl% x509 -req -CA "%~dp0\root.crt" -CAkey "%~dp0\root.key" -in "%~dp0\kafka01.unsigned.crt" -out "%~dp0\kafka01.signed.crt" -days 365 -CAcreateserial

echo.
echo CA Import
%mykeytool% -keystore "%~dp0\kafka01.keystore.jks" -alias CARoot -import -file "%~dp0\root.crt" -noprompt

echo.
echo Certificate import
%mykeytool% -keystore "%~dp0\kafka01.keystore.jks" -alias localhost -import -file "%~dp0\kafka01.signed.crt" -noprompt

echo.
echo END
echo Use "kafka.truststore.jks" e "kafka01.keystore.jks" with password setted for connect to Broker
echo.

echo Press any key to close...
pause>nul
exit