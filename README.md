Crystax NDK's Crew
================================


1. How to start
--------------------------------

Crew is intended to maintain NDK's toolchains, utilities required to run
crew itself, and also native libraries that are not integral part of the
Crystax NDK, like Boost, LIBPNG, Freetype, etc, but instead can be
easily installed or removed if necessary.

CREW is a part of the Crystax NDK installation.
To begin with crew just install Crystax NDK.


2. Commands
--------------------------------

NB For examples below to work correctly 'crew' command must in your PATH.

All commands will return 0 code on successful completion, and non-zero
positive code in case of error.


### version

Show crew's internal version.

Example:

    $ crew version
    1.0

### help

Output short information about available commands.

Example:

    $ crew help
    Usage: crew [OPTIONS] COMMAND [parameters]

    where
    
    OPTIONS are:
      --backtrace, -b output backtrace with exception message;
                      debug option
    
    COMMAND is one of the following:
      version         output version information
      help            show this help message
      env             show crew's command working environment
      list [libs|utils]
                      list all available formulas for libraries or utilities;
                      whithout an argument list all formulas
      info name ...   show information about the specified formula(s)
      install name[:version][:crystax_version] ...
                      install the specified formula(s)
      remove name[:version|:all] ...
                      uninstall the specified formulas
      update          update crew repository information
      upgrade         install most recent versions
      cleanup [-n]    uninstall old versions and clean cache
    
### list [libs|utils]

List all available formulas, their upstream versions, crysta versions and status (installed or
not). If 'libs' or 'utils' argument was specified the command will output information
only about libraries or crew utilitites respectively.

Example:

    $ crew list
    Utilities:
     * p7zib     9.20.1  1
     * curl      7.42.0  1
     * ruby      2.2.2   1
       ruby      2.2.2   2
    Libraries:
       icu       54.1    1
       icu       54.1    2
     * icu       54.1    3
     * boost     1.57.0  1
     * boost     1.58.0  1
       boost     1.58.0  2
     * freetype  2.5.5   1


### info name ...

Show information about the specified formula(s), including type,
dependencies, which versions are present in the repository, and which
versions (if any) are installed.

If there is an utility and a library with the same name than the command
will output info about both.

Example:

    $ crew info curl boost
    curl: http://curl.haxx.se/
    type: utility
    releases:
      7.42.0 1  installed
    
    boost: http://www.boost.org
    type: library
    releases:
      1.57.0 1  installed
      1.58.0 1  installed
    dependencies:
      icu (*)
           

### install name[[:version]:crystax_version] ...

Install the specified formula(s) and all it's dependencies; if no
version was specified then the most recent version will be installed;
otherwise the specified version will be installed; the same applies to
crystax version.

Install command works only with library formulas. You can not install utility.
But you can upgrade utility (see below upgrade command description).

You can install any number of avaliable versions of any library. For example,
you can install boost 1.57.0, 1.58.0 and 1.59.0 at the same time. But you can
have only one crystax_version of any library installed. That is if you have
boost 1.58.0:1 installed and then install boost 1.58.0:2 the later will replace
the former.

Example:
    
    $ crew install ruby
    error: ruby is not available

    $ crew install boost
    boost 1.59.0:1 will be installed
    downloading: .....
    unpacking: .....


### remove name[:version|:all] ...

For every specified formula (and possibly version) the 'remove' command
works as follows:

* if the specified formula is not installed then command will do nothing
  and return with error message;

* if there are installed formulas that depend on the specified release
  and no more releases of the formula are installed then command will do
  nothing and return with error message;

* if only formula name was specified and more than one version is
  installed then command will do nothing and return with error message;

* if only formula name was specified and only one version is installed
  then formula will be removed;

* if formula was specified like this 'name:all' then all installed
  versions will be removed;

* otherwise only the specified version will be removed.

Example:

    $ crew remove icu4c
    error: boost+icu4c depends on icu4c

    $ crew remove boost
    error: more than one version installed

    $ crew remove boost:1.56.0
    uninstalling boost-1.56.0 ...

    $ crew remove boost:all
    uninstalling boost-1.57.0 ...
    uninstalling boost-1.58.0 ...
    uninstalling boost-1.59.0 ...

    $ crew remove icu
    uninstalling icu-54.1 ...
    error: boost+icu4c depends on icu4c


### update

Update crew repository information; this command never installs any
formula, just updates information about available formulas.

Upon execution the command will show information about new versions of
the crew utilitites if any, about new formulas added to the Crystax NDK
repository, and about new versions of the releases in the existing
formulas if any.

Example:

    $ crew update
    Updated Crew from a813ec99 to 6d2d71e9.
    ==> Updated Utilities
    curl, p7zip, ruby
    ==> New Formulae
    jpeg
    ==> Updated Formulae
    boost
    ==> Deleted Formulae
    libold


### upgrade

For all installed formulas do the following: if there is more recent version
then install it.

Example:

    $ upgrade
    Will install: boost:1.59.0:1, icu4c:55.1:1
    downloading http://localhost:9999/packages/boost/boost-1.59.0_1.7z
    checking integrity of the archive file boost-1.59.0_1.7z
    unpacking archive
    downloading http://localhost:9999/packages/icu4c/icu4c-55.1_1.7z
    checking integrity of the archive file icu4c-55.1_1.7z
    unpacking archive


### cleanup [-n]

This command does two things.

First, for every installed library it removes all but the most recent
version.  For example, if boost 1.57.0, 1.58.0, 1.59.0 are installed the
command removes versions 1.57.0 and 1.58.0.  Since at any given time one
and only one version of any crew utility can be installed the command
does nothing with installed crew utilities.

Second, it removes archives from the cache and leaves only ones for the
currently installed libraries nad crew utilities.

If -n option is specified then command just outputs information about
what it will do but otherwise does nothing.

Example:

    $ crew cleanup -n
    Would remove: icu 54.1
    Would remove: boost 1.56.0
    Would remove: boost 1.57.0

    $ crew cleanup
    Removing: icu 54.1
    Removing: boost 1.56.0
    Removing: boost 1.57.0


3. Directory structure
--------------------------------

```
platform/ndk/prebuilt/darwin-x86_64/bin/curl <--------------------|
                                   /crew/curl/7.42.0_1/bin/curl --| 
                                                       lib/
                                                       share/
             tools/crew/.git
                        cache/
                        etc/
                        formula/
                        library/
             sources/android/
                     libname/version-buildnum/.gitignore
                                              Android.mk
                                              include
                                              libs
                                              license.html
                                              src/

```
