Crystax NDK's Crew
================================


1. How to start
--------------------------------

Crew is intended to maintain native libraries that are not integral part
of the Crystax NDK, like Boost, LIBPNG, Freetype, etc, but instead can
be easily installed or removed if necessary.

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
    version         output version information
    help            show this help message
    list            list all available libraries
    info name ...   show information about the specified
                    formulas
    install name[:version]
                    install the specified formula
    remove name[:version|:all] ...
                    uninstall the specified formula
    update          update crew repository information
    upgrade         install most recent versions
    cleanup [-n]    uninstall old versions

### list

List all available formulas, their versions and status (installed or
not); future crew versions can also show if library freely available or
must be payed for.

Example:

    $ crew list
    icu       54.1     installed
    boost     1.57.0   installed
    boost     1.58.0
    freetype  2.5.5    installed


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

* if there are installed formulas that depend on the specified library
  (and it's version) then command will do nothing and return with error
  message;

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


### upgrade [name...]

For every specified formula name or for all installed formulas (if no
names were specified) do the following: if there is more recent version
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


### cleanup [-n] [name...]

For all installed or specific formulas, remove any older versions from
the hold.

Remove all but the most recent versions of the all installed formulas.

If -n option is specified then command just outputs information about
what it will do but otherwise will do nothing.

Example:

    $ crew cleanup
    removing: icu 54.1
    removing: boost 1.56.0
    removing: boost 1.57.0
