require 'activeresource'
require 'json'

class Company

  def initialize
    data_path = 'data'
    file_name = 'companies.json'
    records = File.read(File.join(data_path, file_name))
    @records = JSON.parse(records)
  end

  def all
    @records
  end

  def max
  end

end
