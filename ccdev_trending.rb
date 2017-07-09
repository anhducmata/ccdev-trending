require_relative 'config'
require_relative 'lib/base'
require_relative 'models/base'

class CcdevTrending

  def initialize
  end

  def index(limit_page = nil)
    puts "Welcome chuyencuadev.com Trending..."
    companies = []
    current_page = 1
    total_page = 1
    while current_page > 0 do
      page_url = current_page == 1 ? BASE_URL : "#{BASE_URL}/page/#{current_page}"
      if url_exist?(page_url)
        res = RequestSending.new.get(page_url)
        data = HtmlReader.new(res, '#list-companies', '.tile').get_content
        companies = companies + data
        total_page = current_page
        if limit_page
          if current_page <= limit_page
            current_page += 1
          else
            current_page = 0
          end
        else
          current_page += 1
        end
      else
        STDERR.puts "Page not found"
        current_page = 0
      end
    end
    save_json_file companies
    STDERR.puts "Total page: #{total_page}"
    STDERR.puts "Total companies: #{companies.count}"
  end

  def top
  end

  private

    def save_json_file(array)
      data_path = 'data'
      file_name = 'companies.json'
      opts = { short:true, wrap:60, decimals:3, sort:true, aligned:true,
           padding:1, after_comma:1, around_colon_n:1 }
      File.open(File.join(data_path, file_name), "w") do |f|
        json = JSON.pretty_generate(array, opts)
        f.write(json)
      end
      STDERR.puts "The json file has been saved"
    rescue
      STDERR.puts "Can't save json file"
    end

end
