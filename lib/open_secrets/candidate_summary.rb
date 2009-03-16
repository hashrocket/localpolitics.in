module OpenSecrets
  class CandidateSummary
    API_KEY = APP_CONFIG[:open_secrets_api_key] or warn("No OpenSecrets API key configured")

    READERS = :cand_name, :cash_on_hand, :chamber, :cid, :cycle, :debt, :first_elected, :last_updated, :next_election, :origin, :party, :source, :spent, :state, :total
    attr_reader *READERS

    def initialize(crp_id)
      result_data = summary_result(crp_id)
      candidate = result_data["response"]["summary"]
      candidate.each do |key, value|
        instance_variable_set("@#{key}", formatted_return_value(value)) if READERS.include?(key.to_sym)
      end
    end

    def full_name
      @cand_name.split(/,\s*/).reverse.join(" ").squeeze if @cand_name
    end

    def summary_result(crp_id)
      response = begin
          Timeout.timeout(10) do
            url = "#{OpenSecrets::API_BASE_URL}?method=candSummary&cid=#{crp_id}&apikey=#{API_KEY}"
            HTTParty.get(url)
          end
        rescue OpenURI::HTTPError, Timeout::Error
          empty_response
        end
      use_empty_response?(response) ? empty_response : response
    end

    def use_empty_response?(response)
      response.is_a?(String)
    end

    def empty_response
      {"response" => {"summary" => []}}
    end

    def formatted_return_value(input)
      if numeric?(input)
        input.to_i
      elsif date?(input)
        Date.parse(input)
      else
        input
      end
    end

    def date?(value)
      true if Date.parse(value) rescue false
    end

    def numeric?(value)
      true if Float(value) rescue false
    end

  end
end


