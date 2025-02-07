RSpec.describe OpenAI::Client do
  describe "#usage" do
    let(:one_day_ago) { Time.now.to_i - 86_400 }
    let(:client) { OpenAI::Client.new }

    shared_examples "usage endpoint" do |endpoint_name|
      describe "##{endpoint_name}" do
        let(:response) do
          client.usage.public_send(endpoint_name, parameters: { start_time: one_day_ago })
        end

        it "retrieves #{endpoint_name} usage data" do
          VCR.use_cassette("usage_#{endpoint_name}") do
            expect(response["object"]).to eq("page")
            expect(response["data"]).to be_an(Array)
            expect(response["has_more"]).to be(true).or be(false)
            expect(response.dig("data", 0, "object")).to eq("bucket")
          end
        end
      end
    end

    %w[
      completions
      embeddings
      moderations
      images
      audio_speeches
      audio_transcriptions
      costs
    ].each do |endpoint|
      include_examples "usage endpoint", endpoint
    end
  end
end
