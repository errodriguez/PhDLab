# PhDLab
A set of BASH scripts and other scriptlets to easily interact with Twitter's API from the command line.

## Current status

As you will read below, there is an ongoing restoration effort. Currently, only the items in the `main` branch are the only ones that have been restored and tested to work as originally intended. Items that are being reviewed and being restored are in the `restoration` branch. You can check them out, but there is no guarantee what they do or how they work.

In general, both for the `main` branch and sub-branches derived from it, the software is presented as is, no guarantees are given, you test them at your own risk and no responsibility is assumed for the results or effects that may arise.

## Backgound

This set of scripts were developed between 2016 thru 2018 as part of my PhD research at the IPN Centre for Computing Research (Centro de Investigación en Computación del Instituto Politécnico Nacional) at Mexico City, Mexico. There were not intended to be released to the public since they were developed with a very much specific idea and purpose in mind.

However, all of these scripts have been quite useful on various occasions and I have been using them multiple times for various reasons and for various purposes. So finally I decided to dust them off, restore them, and update them for these modern times.


-- Eduardo

## REQUIREMENTS

These scripts were developed for BASH v4.0+ and has been tested with BASH v5.0 in macOS 10.15 "Catalina" thru macOS 12 "Monterey" with BASH v5 (compiled in Intel and M1 machines). Some additional utilities may be required, depending from your unix distribution:

- OS X and macOS systems require:

  + A `sysvbanner` port.

    `$ brew install kuperman/sysvbanner/sysvbanner`

  + `jq` utility. It can be installed with brew or compiled from source.

## DIRECTORIES AND FILES

Current status in restoration effort:

  .
  `-- src
      |-- Configuration
      |   `-- UNIX
      |-- Library
      |   |-- API
      |   |-- Keychain
      |   `-- Scriptlets
      `-- Tools

## ENVIRONMENT VARIABLES

To be added

## INSTALLATION

1. Be sure you have review and meet all requirements.
2. Clone the project.
3. If not done yet, generate access and token keys in Twitter. Copy thoose values in a file in `src/Library/Keychain` (see `README` file in this directory for instructions. Name the file with the account name used to generate the keys. File extension must be `.tks`.)

## ACTIVATION

To activate the "environment", from the BASH command line, type:

`$ source src/Configuration/UNIX/PhDLab.scd`

After this, three new commands will be available:

+ `vars`.- Display all variables of this project.
+ `tree3`.- A shortcut for the `tree` command with a useful configuration.
+ `lab`.- A shortcut to quickly go to the root directory of the project.

## COMPONENTS USAGE

### `console.sh` script

The `console.sh` script is a wrapper for many of the elements of this project to interact with the Twitter API and other scripts. For example, to get the user timeline using the URL resource `https://api.twitter.com/1.1/statuses/user_timeline.json`.

`$ $PHDTLS/console.sh -A <user> GET https://api.twitter.com/1.1/statuses/user_timeline.json`

where `<user>` must be replaced with the Twitter account name that will be use to access Twitter API. Alternatively, `-A` option can be replaced with the `PHDACC` variable. It can be previously defined or used inline.

`$ PHDACC=<user> $PHDTLS/console.sh GET https://api.twitter.com/1.1/statuses/user_timeline.json`

## OUTPUT PROCESSING WITH `jq`

Returned results from Twitter API services can be from a REST query or a streaming flow. When they comes from a REST request they are return as an array. For example for the request of `https://api.twitter.com/1.1/statuses/user_timeline.json` with the `$PHDTLS/console.sh` script, what is returned is an array with tweets of the timeline, while when the request is through a streaming endpoint tweets are returned individually. REST results can put in the same way as streaming with an aditional processing with `jq`, for this case:

`$ PHDACC=<user> $PHDTLS/console.sh GET https://api.twitter.com/1.1/statuses/user_timeline.json | jq '.[]'` 

So, output can be stored and processed in the same way as if it comes from a streaming endpoint.
