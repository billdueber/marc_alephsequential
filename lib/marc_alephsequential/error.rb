class MARC::AlephSequential::Error < RuntimeError
  attr_accessor :record_id
end