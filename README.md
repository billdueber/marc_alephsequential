# marc_alephsequential
[![Build Status](https://secure.travis-ci.org/billdueber/marc_alephsequential.png)](http://travis-ci.org/billdueber/marc_alephsequential)

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
  reader.log = log # optional. Set up a logger; otherwise, no logging of warnings will be done
  
  begin
    reader.each do |r|
      # do stuff with the record
    end  
  rescue MARC::AlephSequential::Error => e
    log.error "Error while parsing record #{e.record_id} at/near #{e.line_number}: #{e.message}"
  rescue => e
    log.error "Other error of some sort. quitting. #{e.message}"
  end

```

## Description of the Aleph Sequential format

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

### How to read the Aleph sequential "value"

The leader and control fields have no internal structure, but spaces in the value are displayed as '^' for some reason. (The reader, obviously, changes them back into spaces)

For data fields, the subfields are indicated as follows:

* A _subfield start marker_ (let's just say "SSM") matches /\$\$[a-z0-9]/ (e.g., $$a)
* The value string for a data field must start with an SSM 
* An SSM marks the start of a subfield (and the end of the previous subfield, if any)

### Obvious limitations of the Aleph sequential format

Actually, it's not all bad; I like it in a lot of ways. A little verbose at times, but easy to read for a human, and easy to write one-off scripts to run through a file and get statistics about use of tags, find a specific record (just match the bib ID at the beginning of the line), etc. 

The easy-to-see problems are:

* fixed field size. Aleph has a lot of Cobol underneath. So if your bib ids don't happen to be nine characters, well, too bad.
* You can't have an embedded '$$' in a data field's value, because it will be interpreted as the start of a new subfield. '$$' isn't super common as a typo, but I've seen it.


## Parse errors and workarounds

* Lines that don't start with a nine-digit id will be assumed to be a part of the previous line that has an illegal spurious newline. The newline will be removed and all put back together again. If there is no "previous line" because it's the first line of the file, throw an error.
* Any complete record that doesn't include a leader (LDR) will throw an error
* Datafield values that don't start with '$$' will be logged as an error and assumed that the first set of data should be in subfield $$a



## Install

    $ gem install marc_alephsequential

## Copyright

Copyright (c) 2013 Bill Dueber

See {file:LICENSE.txt} for details.
