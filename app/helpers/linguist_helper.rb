module LinguistHelper
  class Linguist
    def initialize(path)
      @rugged = Rugged::Repository.new(path)
      @repo = Linguist::Repository.new(@rugged, @rugged.head.target_id)
    end

    def get_languages_size
      languages = @repo.languages.sort_by { |_, size| size }.reverse
      return @repo.language,  #=> "Python"
            languages         #=> [["Python", 352226], ["HTML", 29856], ["CSS", 9128], ["JavaScript", 5295], ["Shell", 32]]
    end

    def get_languages_percent
      language, languages = get_languages_size
      languages.map do |item|
        size = item[1]
        percentage = ((size / @repo.size.to_f) * 100)
        percentage = (sprintf '%.2f' % percentage).to_f
        item[1] = percentage
      end
      return language, languages
    end
  end
end

if __FILE__ == $0
  path = '/Users/mic/workspace/erp'
  p l = LinguistHelper::Linguist.new(path).get_languages_percent
  # TODO: remove 'Shell', 'CSS', 'HTML' for package
end