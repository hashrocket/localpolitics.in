class CapitolWord

  class << self
    def construct_url(congress_person, namespace, method, options)
      options = options.dup
      case namespace
      when "lawmaker"
        case method
        when "latest"
          options[:results] ||= 5
          "http://www.capitolwords.org/api/#{namespace}/#{congress_person.bioguide_id}/latest/top#{options[:results]}.json"
        end
      end
    end

    def latest_for(congress_person, options={})
      latest_words = HTTParty.get(construct_url(congress_person, "lawmaker", "latest", options))
      latest_words.map do |latest_word|
        CapitolWord.new(latest_word)
      end
    end
  end

  attr_reader :word, :count

  def initialize(attributes)
    @word  = attributes["word"]
    @count = attributes["word_count"].to_i
  end

  def to_s
    @word
  end
end
