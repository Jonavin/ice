# Building Ice for C++ for Windows Applications

This page describes the Ice source distribution, including information about compiler requirements, third-party dependencies, and instructions for building and testing the distribution. If you prefer, you can download a [Windows installer](https://doc.zeroc.com/display/Ice36/Using+the+Windows+Binary+Distribution) that contains pre-compiled debug and release libraries, executables, and everything else necessary to build Ice applications on Windows.

## Build Requirements for Windows

### Operating Systems and Compilers

Ice was extensively tested using the operating systems and compiler versions listed for our [supported platforms](https://zeroc.com/platforms_3_6_0.html).

### Third-Party Libraries

Ice has dependencies on a number of third-party libraries:

 - [expat](http://expat.sourceforge.net/) 2.0
 - [bzip](http://bzip.org) 1.0
 - [Berkeley DB](http://www.oracle.com/us/products/database/berkeley-db/overview/index.htm) 5.3
 - [mcpp](https://github.com/zeroc-ice/mcpp) 2.7.2 (with patches)

You do not need to build these packages yourself, as ZeroC supplies a separate [Windows installer](https://zeroc.com/download.html) that contains release and debug libraries for all of the third-party dependencies.

### Monotonic Clock

Ice uses the ```QueryPerformanceCounter``` Windows API function to measure time with a monotonic clock. If you are experiencing timing or performance issues, there are two knowledgebase articles that may be relevant for your system:

 - [KB 896256](http://support.microsoft.com/?id=896256)
 - [KB 895980](http://support.microsoft.com/?id=895980)

## Compiling and Testing Ice for C++ on Windows

### Building Ice

Open a command prompt that is configured for your target architecture. For example, when using Visual Studio 2013, you have several alternatives:

- Developer Command Prompt
- VS2013 x86 Native Tools Command Prompt
- VS2013 x64 Native Tools Command Prompt
- VS2013 x64 Cross Tools Command Prompt

Using the first two configurations produces 32-bit binaries, while the third and fourth configurations produce 64-bit binaries.

> *You must be using a Windows x64 platform when compiling a 64-bit version of Ice.*

In the command window, change to the ```cpp``` subdirectory:

    $ cd cpp

Edit ```config\Make.rules.mak``` to establish your build configuration. The comments in the file provide more information.

Now you're ready to build Ice:

    > nmake /f Makefile.mak

This will build the Ice core libraries, services, and tests.

### Running the Test Suite

Python is required to run the test suite. After a successful build, you can run the tests as follows:

    > python allTests.py

If everything worked out, you should see lots of ```ok``` messages. In case of a failure, the tests abort with ```failed```.

### x64 Platform

Building Ice on x64 with the Visual Studio C++ compiler is like building Ice on x86. You just need to perform the build in an "x64 Command Prompt", and not in a regular "Developer Command Prompt".

> *You must be using a Windows x64 platform when compiling a 64-bit version of Ice.*

## Installing a C++ Source Build on Windows

Simply run ```nmake /f Makefile.mak install```. This will install Ice in the directory specified by the ```prefix``` variable in ```config\Make.rules.mak```.

If you built a 64-bit version of Ice, the binaries are installed in the ```bin\x64``` directory and the libraries are installed in the ```lib\x64``` directory.
