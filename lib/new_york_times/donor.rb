module NewYorkTimes

  class Donor

    def self.top_by_zip(zip, n)
      summarize_results(NewYorkTimes::CampaignFinance.new.donor_search_by_postal_code(zip)["results"]).first(n)
    end

    def self.summarize_results(results)
      sum_hash = {}
      results.each do |donation|
        donor_name = donation["donor_first_name"] + " " + donation["donor_last_name"]
        donor_name = donor_name.titleize
        sum_hash[donor_name] ||= 0
        sum_hash[donor_name] += donation["donation_amount"]
      end

      sum_hash.sort {|a,b| a[1] <=> b[1] }.reverse
    end

  end

end
