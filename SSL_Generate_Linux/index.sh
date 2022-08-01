source ./lib/autority.sh
clear

echo === CERTIFICATE GENERATOR FOR KAFKA ===
read -p "Press any key to continue..."
echo

au_key=root.key
au_crt=root.crt

if [ -f "$au_key" ] && [ -f "$au_crt" ]; then
 echo Autorità disponibile
else
 echo Autorità non disponibile
 while true; do
    read -p "Generate new CA? (y/n): " yn
    case $yn in
        [Yy]* ) creaCertAU; break;;
        [Nn]* ) echo "Bye! :)"; exit;;
    esac
 done
fi

echo
echo Generate Truststore
keytool -keystore kafka.truststore.jks -alias CARoot -import -file root.crt -dname "CN=kafka-test, OU=Fabrizio, O=Fabrizio, L=Bologna, S=Italy, C=IT" -noprompt

echo
echo Generate Keystore 
keytool -keystore kafka01.keystore.jks -alias localhost -validity 365 -genkey -keyalg RSA -ext SAN=DNS:kafka-test -dname "CN=kafka-test, OU=Fabrizio, O=Fabrizio, L=Bologna, S=Italy, C=IT" -noprompt

echo
echo Export certificate
keytool -keystore kafka01.keystore.jks -alias localhost -certreq -file kafka01.unsigned.crt

echo
echo Sign certificate
openssl x509 -req -CA root.crt -CAkey root.key -in kafka01.unsigned.crt -out kafka01.signed.crt -days 365 -CAcreateserial

echo
echo CA Import
keytool -keystore kafka01.keystore.jks -alias CARoot -import -file root.crt -noprompt

echo
echo Certificate import
keytool -keystore kafka01.keystore.jks -alias localhost -import -file kafka01.signed.crt -noprompt

echo
echo END
echo Use \"kafka.truststore.jks\" e \"kafka01.keystore.jks\" with password setted for connect to Broker
echo

read -p "Press any key to close..."
exit;