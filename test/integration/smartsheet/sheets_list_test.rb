require_relative 'test_scenario'

describe Smartsheet::Sheets do
  describe 'when making List Sheets requests' do
    describe 'when listing sheets with no parameters' do
      it 'calls as expected' do
        TestScenario.run 'List Sheets - No Params' do |client|
          sheets = client.sheets.list
          sheets.wont_be_empty
          sheets[:data][0][:id].must_equal 1
        end
      end
    end

    describe 'when listing sheets with a filter' do
      it 'calls as expected' do
        TestScenario.run 'List Sheets - Include Owner Info' do |client|
          client.sheets.list(params: {include: 'ownerInfo'})
        end
      end
    end
  end
end