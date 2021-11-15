![Project logo](Resources/Images/PhDLab-logo.png)
# PhDLab

v 0.1.0

Dr. Eduardo René Rodríguez Ávila


## Introduction

**PhDLab** is a set of BASH scripts and other scriptlets to easily interact with Twitter's API from the command line.  This set of scripts were developed between 2016 thru 2018 as part of my PhD research at the Centre for Computing Research of the National Polytechnic Institute (Centro de Investigación en Computación del Instituto Politécnico Nacional) at Mexico City, Mexico. There were not intended to be released to the public since they were developed for a very much specific idea and purpose in mind.

However, all of these scripts have been quite useful on various occasions and I have been using them multiple times for various reasons and for various purposes. So finally I decided to dust them off, restore them, and update them for these modern times.

-- Eduardo


## Requirements and installation

This document, as its title implies, its an end-user manual to help on the scripts usage. For technical information on the installation, components, technology used and similar topics, please check the `README.md` file.


## SYMBOLS AND CONVENTIONS

In this manual, next symbols and conventions are used:

+ **...** (_dieresis_).-  represents part of a string omitted that is neither particularly necessary nor important in the example shown.

+ **<_symbol_>**.- represents a value (generically named in italics) that has to be replaced (substitued) by a specific string of characters or numerical value.

+ **Twitter account**.- Generally speaking, *twitter account* will refer to any _screen name_ (in Twitter's parlance). For this documents and examples provided (unless explicitly mentioned otherwise) *twitter account** will be used to reference the Twitter account used to access the API. It should not be confused with the screen name or user ID values that could be queried from the API.

+ **Screen name**.- Screen name refers to the Twitter account name, the user name. It is refer as the `screen_name` field or parameter in the Twitter API. The string of characters that follows the **@** symbol.

+ **User ID**.- This is an internally used number which is associated with the Twitter account and it is inmutable. While **screen name** can be changed many times, the **user ID** value remains the same and cannot be changed.


## ACTIVATION

To activate the "environment", from the BASH command line, type:

`$ source src/Configuration/UNIX/PhDLab.scd`

After this, three new commands will be available:

+ `vars`.- Display all variables of this project.
+ `tree3`.- A shortcut for the `tree` command with a useful configuration.
+ `phdlab`.- A shortcut to quickly go to the root directory of the project.

## `console.sh`

The `console.sh` script is a wrapper for many of the elements of this project to interact with the Twitter API and other scripts. For example, to get the user timeline using the URL resource `https://api.twitter.com/1.1/statuses/user_timeline.json`.

`$ $PHDTLS/console.sh -A <user> GET https://api.twitter.com/1.1/statuses/user_timeline.json`

where `<user>` must be replaced with the Twitter account name that will be use to access Twitter API. Alternatively, `-A` option can be replaced with the `PHDACC` variable. It can be previously defined or used inline.

`$ PHDACC=<user> $PHDTLS/console.sh GET https://api.twitter.com/1.1/statuses/user_timeline.json`

## OUTPUT PROCESSING WITH `jq`

Returned results from Twitter API services can be from a REST query or a streaming flow. When they comes from a REST request they are return as an array. For example for the request of `https://api.twitter.com/1.1/statuses/user_timeline.json` with the `$PHDTLS/console.sh` script, what is returned is an array with tweets of the timeline, while when the request is through a streaming endpoint tweets are returned individually. REST results can put in the same way as streaming with an aditional processing with `jq`, for this case:

`$ PHDACC=<user> $PHDTLS/console.sh GET https://api.twitter.com/1.1/statuses/user_timeline.json | jq '.[]'` 

So, output can be stored and processed in the same way as if it comes from a streaming endpoint.



## Getting tweets

### Timelines

To get a user timeline using the `console.sh` script:

`$PHDTLS/console.sh -A <*twitter account*> GET https://api.twitter.com/1.1/statuses/user_timeline.json screen_name jack count 1`
