module OpenSecrets
  class CandidateSummary
    API_KEY = APP_CONFIG[:open_secrets_api_key]

    attr_accessor :cand_name, :cash_on_hand, :chamber, :cid, :cycle, :debt, :first_elected, :last_updated, :next_election, :origin, :party, :source, :spent, :state, :total

    def initialize(crp_id)
      result_data = summary_result(crp_id)
      candidate = result_data["response"]["summary"]
      candidate.each do |key, value| 
        instance_variable_set("@#{key}", value) if OpenSecrets::CandidateSummary.instance_methods.include? key
      end
      candidate
    end

    def name
      @cand_name.split(/,\s*/).reverse.join(" ") rescue @cand_name
    end

    def summary_result(crp_id)
      begin
        Timeout.timeout(10) do
          url = "#{OpenSecrets::API_BASE_URL}?method=candSummary&cid=#{crp_id}&apikey=#{API_KEY}"
          puts "getting url: #{url}"
          HTTParty.get(url)
        end
      rescue OpenURI::HTTPError, Timeout::Error
        "<xml></xml>"
      end
    end
  end
end


