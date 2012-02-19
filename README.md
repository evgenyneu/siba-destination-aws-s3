# Overview

This is a plugin for [SIBA backup and restore utility](https://github.com/evgenyneu/siba). It allows to use Amazon S3 as backup destination.

## Installation

        $ gem install siba-destination-aws-s3

## Usage

1. Create a configuration file:

        $ siba generate mybak

2. Backup:

        $ siba backup mybak

3. Restore:

        $ siba restore mybak

Run `siba` command without arguments to see the list of all available options.
