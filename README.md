iOS6-passbook-helper
====================

Helper scripts for passbook

# pkpass.sh

Script creates pass package from the directory with pass content. 
Requires:
 - Directory with pass content (JSON Description of package, images, localization etc.)
 - p12 certificate to sign with. Must contain private key.
 - password for p12 certificate file.

FORMAT:

  ./pkpass.sh certificates.p12 pass/to/content/ password [outputName]
