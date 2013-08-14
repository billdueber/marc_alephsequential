require 'marc'
require 'marc_alephsequential/version'
require 'marc_alephsequential/error'
require 'marc_alephsequential/reader'


# Need to allow FMT tags as control tags

MARC::ControlField.control_tags << 'FMT'