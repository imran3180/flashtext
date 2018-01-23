require 'flashtext'
require 'json'

RSpec.describe "Flashtext Replacer" do
  it "keyword replacer should working fine - Case Insensitive" do
    path = File.join(File.dirname(__FILE__), 'keyword_extractor_test_cases.json')
    file = File.read(path)
    test_cases = JSON.parse(file)
    test_cases.each_with_index do |test_case, test_id|
      keyword_replacer = Flashtext::KeywordProcessor.new
      test_case["keyword_dict"].each do |key, values|
        values.each do |value|
          keyword_replacer.add_keyword(value, key.gsub(" ", "_"))
        end
      end
      new_sentence = keyword_replacer.replace_keywords(test_case["sentence"])

      keyword_mapping = {}
      test_case["keyword_dict"].each do |key, values|
        values.each do |value|
          keyword_mapping[value] = key.gsub(" ", "_")
        end
      end

      keyword_mapping.keys.sort{ |a, b| b.length <=> a.length }.each do |key|
        lowercase = Regexp.new(r'(?<!\w){}(?!\w)'.format(Regexp.escape(key)))
        # replaced_sentence = lowercase.gsub(keyword_mapping[key], replaced_sentence)
        replaced_sentence = replaced_sentence.gsub(lowercase, keyword_mapping[key])
      end
      expect(new_sentence).to eq(replaced_sentence), "Test-id: #{test_id}, Test-Data: #{test_case.to_json}, Result: #{new_sentence}, Expected: #{replaced_sentence}"
    end
  end
end