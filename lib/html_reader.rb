require 'rubygems'
require 'nokogiri'
require_relative 'url_checker'
require_relative '../config'

class HtmlReader

  def initialize(html_page, parent_node, child_node)
    @html_page = html_page
    @parent_node = parent_node
    @child_node = child_node
  end

  def get_content
    lists = []
    doc = Nokogiri::HTML.parse(@html_page)
    parent = doc.css(@parent_node)
    if parent
      childs = parent.css(@child_node)
      childs.each do |child|
        logo = get_logo(child)
        name = get_name(child)
        info = child.css('p.tile-title')
        review_url = get_review_url(info[0]) if info[0]
        desc = get_desc(info[1]) if info[1]
        reviews_count = get_reviews_count(info[2]) if info[2]
        lists << {
          name: name,
          logo: logo,
          review_url: review_url,
          description: desc,
          reviews_count: reviews_count
        }
      end
    end
    lists
  end

  private

    def get_logo(node)
      img = node.at('img')
      logo = ""
      if img
        logo = img['src'] if img['src']
        logo = img['data-original'] if img['data-original']
      end
      logo
    end

    def get_name(node)
      name = node.css('span.text-bold')&.text
      name || "Unknow Company"
    end

    def get_review_url(node)
      url = node.at('a')['href'] || nil
      url.nil? ? "" : "#{BASE_URL}#{url}"
    end

    def get_desc(node)
      node.text || 'No information'
    end

    def get_reviews_count(node)
      node.css('span.label').text || 0
    end
end
