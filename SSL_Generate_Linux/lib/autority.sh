function creaCertAU(){
 echo === Generate new Certificate Authority ===
 echo
 echo Generate private key...
 openssl genrsa -out root.key &> /dev/null
 echo
 echo Generate CA certificate...
 openssl req -new -x509 -key root.key -out root.crt -subj "/C=IT/ST=Italy/L=Bologna/O=Fabrizio/OU=Fabrizio/CN=kafka-test/emailAddress=postmaster@localhost"
}
