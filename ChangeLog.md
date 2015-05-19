### 2.0.0 /

Change the way MARC::AlephSequential::Reader deals with errors when
producing a record for `#each`. Instead of throwing an error (and aborting
the loop whether you wanted to or not, since there's no way to catch
the error in a provided block), it will now return a
MARC::AlephSequential::ErrorRecord `er` with a method `er.error` holding
the error.

This should affect almost no one.

### 1.0.0

First 1.0 release. No major changes.

### 0.1.1  / 2013-10-23

* Fixed bad call to respond_to in intializer

### 0.1.0 / 2013-08-12

* Initial release:

