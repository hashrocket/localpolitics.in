# http://www.fedspending.org/faads/faads.php?datype=X&detail=-1&sortby=f&fiscal_year=2006&max_records=10&recipient_zip=#{zip_code}
require 'open-uri'

class FedSpending
  class << self
    def construct_url(args={})
      raise ArgumentError, "Must specify zip_code" unless args.has_key?(:zip_code)
      url = "http://www.fedspending.org/faads/faads.php?detail=-1&sortby=f"
      url += "&datype=#{args[:datype] || 'X'}"
      url += "&fiscal_year=#{args[:fiscal_year] || '2006'}"
      url += "&max_records=#{args[:max_records] || '10'}"
      url += "&recipient_zip=#{args[:zip_code]}"
      url
    end

    def top_recipients(args={})
      xml = Nokogiri::XML(open(construct_url(args)))
      recipients = xml.search('top_recipients/recipient').map do |node|
        {:name => format_name(node.text), :amount => node['total_obligatedAmount'], :rank => node['rank']}
      end
      recipients.sort_by {|x| Integer(x[:rank]) }
    end

    def format_name(name)
      name.titleize
    end
  end
end

