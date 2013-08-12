# marc_alephsequential

A [ruby-marc](https://github.com/ruby-marc/ruby-marc) reader for MARC files in the Aleph sequential format

* [Homepage](https://github.com/billdueber/marc_alephsequential#readme)
* [Issues](https://github.com/billdueber/marc_alephsequential/issues)
* [Documentation](http://rubydoc.info/gems/marc_alephsequential/frames)
* [Email](mailto:bill at dueber.com)

## Examples

```ruby

  require 'marc'
  require 'marc_alephsequential'

  log = GetALogFromSomewhere.new
  reader = MARC::AlephSequential::Reader.new('myfile.seq')
  reader.flexible = true # fix bad indicators, look for embedded newlines, etc.
  reader.log = log # set up a logger; otherwise, no logging of warnings will be done
  
  begin
    reader.each do |r|
      # do stuff with the record
    end  
  rescue MARC::AlephSequential::Error => e
    log.error "Error while parsing record #{e.record_id}: #{e.message}"
    retry # see if we can continue with other records
  rescue => e
    log.error "Other error of some sort. quitting. #{e.message}"
  end

```

## Description

Aleph sequential is a MARC serialization format that is easily output by Ex Libris' Aleph software.
Each MARC record is presented as a series of unicode text lines, one field per line.

  000000228 LDR   L ^^^^^nam^a22002891^^4500
  000000228 001   L 000000228
  000000228 003   L MiU
  000000228 005   L 19880715000000.0
  000000228 006   L m^^^^^^^^d^^^^^^^^
  000000228 007   L cr^bn^---auaua
  000000228 008   L 880715r19691828nyuab^^^^^^^^|00000^eng^^
  000000228 010   L $$a68055188
  000000228 020   L $$a083711750X
  000000228 035   L $$a(RLIN)MIUG0021856-B

Each line has the following format (note: All must be in utf-8)

* 9 characters (generally digits) for the aleph record ID
* [space]
* 3 character tag (left-justified if need be)
* 1 character indicator 1
* 1 character indicator 2
* [space L space], for some historic reasons I don't know
* The tag's value, perhaps with internal subfields

### How to read the alephsequential "value"

The leader and control fields have no internal structure, but spaces are turned into '^' for some reason.

For data fields, the subfields are indicated as follows:

* A _subfield start marker_ (let's just say "SSM") matches /\$\$[a-z0-9]/
* The value string for a data field must start with an SSM 
* An SSM marks the start of a subfield (and the end of the previous subfield, if any)


## _Flexible_ mode

If `reader.flexible` is set to true (or left at the `true` default), the following changes will be made on read and emit warnings:

* Indicators that are not 0-9 or space will be changed to space
* Lines that don't start with a nine-digit id will be assumed to be a part of the previous line that has an illegal spurious newline. The newline will be replaced by a space and all put back together again.
* Values that don't start with '$$' will be noted as an error and assumed that the first set of data should be in subfield $a



## Install

    $ gem install marc_alephsequential

## Copyright

Copyright (c) 2013 Bill Dueber

See {file:LICENSE.txt} for details.
