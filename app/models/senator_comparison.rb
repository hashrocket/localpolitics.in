class SenatorComparison < ActiveRecord::Base
  ROOT = "http://www.opencongress.org"

  validates_presence_of :govtrack_id_1, :govtrack_id_2
  def self.for!(id_1, id_2)
    returning find_or_initialize_by_govtrack_id_1_and_govtrack_id_2(id_1, id_2) do |instance|
      instance.scrape_if_expired
    end
  end

  def self.for(id_1, id_2)
    self.for!(id_1, id_2)
  rescue OpenURI::HTTPError, Timeout::Error
  end

  def expired?
    updated_at.nil? || updated_at < 2.weeks.ago
  end

  def scrape_if_expired
    scrape if expired?
  end

  def scrape
    self.body = node.map(&:inner_html).first
    save!
  end

  def document
    require 'open-uri'
    Timeout.timeout(10) do
      @document ||= Nokogiri::HTML(open(url))
    end
  end

  def node
    unless @node
      @node = document.search(".cols-box.comps")
      @node.search("a").each do |n|
        n["href"] = "#{ROOT}#{n["href"]}"
      end
      @node.search("h3").remove
    end
    @node
  end

  def url
    "#{ROOT}/person/compare?person1=#{govtrack_id_1}&person2=#{govtrack_id_2}"
  end

  def to_s
    body
  end
end
