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
      list [libs|utils]
                      list all available formulas for libraries or utilities;
                      whithout an argument list all formulas
      info name ...   show information about the specified formula(s)
      install name[:version][:source] ...
                      install the specified formula(s)
      remove name[:version|:all] ...
                      uninstall the specified formulas
      build name:[version]
                      rebuild formula from sources
      update          update crew repository information
      upgrade         install most recent versions
      cleanup [-n]    uninstall old versions
    
    For every command where formula name is reuqired, name can be specified
    in two forms. Short form: just formula name, f.e. zlib; full form that
    includes formula type, f.e. utils/zlib. Full form is required only
    to resolve ambiguity.

### list [libs|utils]

List all available formulas, their versions, build numbers and status (installed or
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

Show information about the specified formula(s), including dependencies
required, which versions are present in the repository, and which
versions (if any) are installed.

Example:

    $ info boost
    Boost Project Libraries
    depends: icu
    versions available: 1.57.0 (503M), 1.58.0 (515M)
    versions installed: 1.57.0
    space required: 
           

### install name[:version] ...

Install the specified formula(s) and all it's dependencies; if no version
was specified then the most recent version will be installed; otherwise
the specified version will be installed.

Example:
    
    $ crew install libpng
    error: libpng is not available

    $ crew install freetype
    freetype 2.2.5 will be installed
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

    $ crew remove icu
    error: boost depends on icu

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

### update

Update crew repository information; this command never installs any
formula, just updates information about available formulas.

Upon execution the command will show information about new formulas
added to the Crystax NDK repository, and about new versions of the
releases in the existing formulas if any.

Example:

    $ crew update
    new formulas:
            libjpeg: 8d
            ffmped:  2.5.3, 3.0.0
                   
    new versions:
            boost: 2.0.0
            icu:   54.2, 55.0


### upgrade

For all installed formulas do the following: if there is more recent version
then install it.

Example:

    $ upgrade
    will install icu-55.0, boost-2.0.0

    icu 55.0 will be installed
    downloading: .....
    unpacking: .....

    boost 2.0.0 will be installed
    downloading: .....
    unpacking: .....

    $ upgrade boost icu
    Error: boost 2.0.0 already installed
    Error: icu 55.0a already installed


### cleanup [-n]

Remove all but the most recent versions of the all installed formulas.

If -n option is specified then command just outputs information about
what it will do but otherwise will do nothing.

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
                                   /crew/curl/7.42.0_2/bin/curl --| 
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
