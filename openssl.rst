OpenSSL
=======

Some of this from http://www.coresecuritypatterns.com/blogs/?p=763
and http://www.bogpeople.com/networking/openssl.shtml.

End-user Functions
------------------

.. index:: openssl; create key

Create key
~~~~~~~~~~

Create a 2048-bit key pair::

    openssl genrsa 2048 > myRSA-key.pem
    openssl genrsa -out blah.key.pem
    openssl genrsa -out blah.key.pem 2048

Create a password-protected 2048-bit key pair::

    openssl genrsa 2048 -aes256 -out myRSA-key.pem

OpenSSL will prompt for the password to use.  Algorithms: AES (aes128, aes192 aes256), DES/3DES (des, des3).

Remove passphrase from a key::

  openssl rsa -in server.key -out server-without-passphrase.key

Extract public key::

    openssl rsa -in blah.key.pem -out public.key -pubout

Getting Certificates
~~~~~~~~~~~~~~~~~~~~

.. index:: openssl; certificate operations

Create Certificate Request and Unsigned Key::

    openssl req -nodes -new -keyout blah.key.pem -out blah.csr.pem

More thorough example::

    openssl req -new rsa:1024 -node -out myCSR.pem \
        -keyout myPrivCertkey.pem \
        -subj "/C=US/ST=MA/L=Burlington/CN=myHost.domain.com/emailAddress=user@example.com"

Create a self-signed certificate::

    openssl req -nodes -x509 -newkey rsa:1024 -days 365 \
        -out mySelfSignedCert.pem  -set_serial 01 \
        -keyout myPrivServerKey.pem \
        -subj "/C=US/ST=MA/L=Burlington/CN=myHost.domain.com/emailAddress=user@example.com"

``-x509`` identifies it as a self-signed certificate and ``-set_serial`` sets the serial number for the server certificate.

Create a single file that contains both private key and the self-signed certificate::

    openssl req -x509 -nodes -days 365 -newkey rsa:1024 \
        -keyout myServerCert.pem -out myServerCert.pem \
        -subj "/C=US/ST=MA/L=Burlington/CN=myHost.domain.com/emailAddress=user@example.com"

Fingerprint for Unsigned Certificate::

    openssl x509 -subject -dates -fingerprint -in blah.key.pem

Display Certificate Information::

    openssl x509 -in blah.crt.pem -noout -text

Creating a PEM File for Servers::

    cat blah.key.pem blah.crt.pem blah.dhp.pem > blah.pem

Download some server's certificate::

    openssl s_client -connect www.example.com:443

(then hit ^C out of the interactive shell)

Viewing Certificate Contents
~~~~~~~~~~~~~~~~~~~~~~~~~~~~


X.509 certificates are usually stored in one of two formats. Most applications
understand one or the other, some understand both:

* DER which is raw binary data.

* PEM which is a text-encoded format based on the Privacy-Enhanced Mail standard (see RFC1421). PEM-format certificates look something like this::

      -----BEGIN CERTIFICATE-----
      MIIBrjCCAWwCAQswCQYFKw4DAhsFADBTMQswCQYDVQQGEwJBVTETMBEGA1UECBMK
      U29tZS1TdGF0ZTEhMB8GA1UEChMYSW50ZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMQww
      :
      :
      MQAwLgIVAJ4wtQsANPxHo7Q4IQZYsL12SKdbAhUAjJ9n38zxT+iai2164xS+LIfa
      C1Q=
      -----END CERTIFICATE-----

      OpenSSL uses the PEM format by default, but you can tell it to process DER format certificates...you just need to know which you are dealing with.

The command to view an X.509 certificate is::

    openssl x509 -in filename.cer -inform der -text

You can specifiy -inform pem if you want to look at a PEM-format certificate

Convert Between Formats
~~~~~~~~~~~~~~~~~~~~~~~

If you have a PEM-format certificate which you want to convert into DER-format, you can use the command::

    openssl x509 -in filename.pem -inform pem -out filename.cer -outform der

PKCS12 files
~~~~~~~~~~~~

PKCS12 files are a standard way of storing multiple keys and certificates
in a single file.  Think of it like a zip file for keys & certificates,
which includes options to password protect etc.

Don't worry about this unless you need it because some application requires
a PKCS12 file or you're given one that you need to get stuff out of.

Viewing PKCS12 Keystore Contents::

    openssl pkcs12 -in filename.p12 -info

If you have two separate files containing your certificate and private key, both in PEM format, you can combine these into a single PKCS12 file using the command::

    openssl pkcs12 -in cert.pem -inkey key.pem -export -out filename.p12

Encrypting and signing things
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signing E-mails::

    openssl smine -sign -in msg.txt -text -out msg.encrypted -signer blah.crt.pem -inkey blah.key.pem

Sign some text::

    openssl dgst -sign private.key -out signature.asc

Verify signature::

    if openssl dgst -verify public.key -signature signature.asc ; then echo GOOD; else echo BAD; fi

Encrypt and decrypt a single file::

    openssl aes-128-cbc -salt -in file -out file.aes
    openssl aes-128-cbc -d -salt -in file.aes -out file

Simple file encryption::

    openssl enc -bf -A -in file_to_encrypt.txt

(password will be prompted)

Simple file decryption::

    openssl enc -bf -d -A -in file_to_encrypt.txt

tar and encrypt a whole directory::

  tar -cf - directory | openssl aes-128-cbc -salt -out directory.tar.aes
  openssl aes-128-cbc -d -salt -in directory.tar.aes | tar -x

tar zip and encrypt a whole directory::

  tar -zcf - directory | openssl aes-128-cbc -salt -out directory.tgz.aes
  openssl aes-128-cbc -d -salt -in directory.tgz.aes | tar -xz

Certificate Authority Functions
-------------------------------

When setting up a new CA on a system, make sure index.txt and serial exist (empty and set to 01, respectively), and create directories private and newcert.

Edit openssl.cnf - change default_days, certificate and private_key, possibly key size (1024, 1280, 1536, 2048) to whatever is desired.

Create CA Certificate::

    openssl req -new -x509 -keyout private/something-CA.key.pem \
    -out ./something-CA.crt.pem -days 3650

Export CA Certificate in DER Format::

    openssl x509 -in something-CA.crt.pem -outform der \
    -out something-CA.crt

Revoke Certificate::

    openssl ca -revoke blah.crt.pem

Generate Certificate Revokation List::

    openssl ca -gencrl -out crl/example.com-CA.crl

Sign Certificate Request::

    openssl ca -out blah.crt.pem -in blah.req.pem

Create Diffie-Hoffman Parameters for Current CA::

    openssl dhparam -out example.com-CA.dhp.pem 1536

Creating Self-Signed Certificate from Generated Key::

    openssl req -new -x509 -key blah.key.pem -out blah.crt.pem

Use only when you've no CA and will only be generating one key/certificate (useless for anything that requires signed certificates on both ends)

