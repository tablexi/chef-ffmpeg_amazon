# Description

This cookbook follows the [Compile FFMPEG on CentOS](https://trac.ffmpeg.org/wiki/CompilationGuide/Centos) for setting up FFMPEG on Amazon Linux.

Encoders from source:

* faac
* lame
* ogg
* vorbis
* x264
* yasm

# Requirements

## Cookbooks:

This cookbook has dependencies on the following cookbooks:

* git

## Platforms:

* Amazon

# TODO:

* Create uninstall process.
* Allow for adding and removing encoders (using a resource)
