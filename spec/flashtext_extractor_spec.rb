require 'flashtext'
require 'json'

RSpec.describe "Flashtext Extractor" do
  it "keyword extractor should working fine - Case Insensitive" do
    path = File.join(File.dirname(__FILE__), 'keyword_extractor_test_cases.json')
    file = File.read(path)
    test_cases = JSON.parse(file)
    test_cases.each_with_index do |test_case, test_id|
      keyword_processor = Flashtext::KeywordProcessor.new
      keyword_processor.add_keywords_from_hash(test_case['keyword_dict'])
      keyword_extracted = keyword_processor.extract_keywords(test_case['sentence'])
      expect(keyword_extracted).to eq(test_case['keywords']), "Test-id: #{test_id}, Test-Data: #{test_case.to_json}, Result: #{keyword_extracted}, Expected: #{test_case['keywords']}"
    end
  end

  it "keyword extractor should working fine - Case Sensitive" do
    path = File.join(File.dirname(__FILE__), 'keyword_extractor_test_cases.json')
    file = File.read(path)
    test_cases = JSON.parse(file)
    test_cases.each_with_index do |test_case, test_id|
      keyword_processor = Flashtext::KeywordProcessor.new(case_sensitive = true)
      keyword_processor.add_keywords_from_hash(test_case['keyword_dict'])
      keyword_extracted = keyword_processor.extract_keywords(test_case['sentence'])
      expect(keyword_extracted).to eq(test_case['keywords_case_sensitive']), "Test-id: #{test_id}, Test-Data: #{test_case.to_json}, Result: #{keyword_extracted}, Expected: #{test_case['keywords_case_sensitive']}"
    end
  end
end