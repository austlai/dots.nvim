return {
  on_attach = function(client, bufnr)
    client.server_capabilities.workspaceSymbolProvider = false
    client.server_capabilities.completionProvider = false
    client.server_capabilities.signatureHelpProvider = false
  end,
  settings = {
    intelephense = {
      environment = {
        phpVersion = "8.1"
      },
      completion = {
        callSnippet = "Replace"
      },
      stubs = {
        -- Extra project specific stubs
        "redis", "apcu", "imagick", "mcrypt", "memcache",
        -- Default stubs
        "apache", "bcmath", "bz2", "calendar", "com_dotnet", "Core", "ctype", "curl", "date", "dba", "dom", "enchant", "exif", "FFI", "fileinfo",
        "filter", "fpm", "ftp", "gd", "gettext", "gmp", "hash", "iconv", "imap", "intl", "json", "ldap", "libxml", "mbstring", "meta", "mysqli",
        "oci8", "odbc", "openssl", "pcntl", "pcre", "PDO", "pdo_ibm", "pdo_mysql", "pdo_pgsql", "pdo_sqlite", "pgsql", "Phar", "posix", "pspell",
        "readline", "Reflection", "session", "shmop", "SimpleXML", "snmp", "soap", "sockets", "sodium", "SPL", "sqlite3", "standard", "superglobals",
        "sysvmsg", "sysvsem", "sysvshm", "tidy", "tokenizer", "xml", "xmlreader", "xmlrpc", "xmlwriter", "xsl", "Zend OPcache", "zip", "zlib"
      }
    }
  },
}
