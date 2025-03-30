# Gemup

Quickly update your `Gemfile` from the command line.

## Usage

```bash
gemup some-gem
```
gemup will display a list of versions for the given gem. After selecting with the enter key, the selected version will be added to your Gemfile

```
gemup some-gem 1.2.3
```
gemup will add the specified gem version to your Gemfile

Note: If the given gem is already present in your Gemfile, it will be overwritten

## TODOs
* Version specifier support
* Upserting multiple gems at once
* Group support