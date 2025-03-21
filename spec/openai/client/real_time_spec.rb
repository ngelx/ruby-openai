RSpec.describe OpenAI::RealTime do
  let(:client) { OpenAI::Client.new }
  let(:realtime) { client.real_time }

  describe "#create" do
    context "when no model is specified" do
      it "uses the default model" do
        VCR.use_cassette("realtime_session_create_default") do
          response = realtime.create
          expect(response["model"]).to eq(OpenAI::RealTime::DEFAULT_REALTIME_MODEL)
        end
      end
    end

    context "when a model is specified" do
      it "uses the specified model" do
        custom_model = "gpt-4o-realtime-preview-2024-12-18"
        VCR.use_cassette("realtime_session_create_custom_model") do
          response = realtime.create(parameters: { model: custom_model })
          expect(response["model"]).to eq(custom_model)
        end
      end
    end

    context "with additional parameters" do
      it "sends all parameters to the API" do
        parameters = {
          model: "gpt-4o-realtime-preview-2024-12-17",
          voice: "alloy",
          instructions: "You are a helpful assistant."
        }

        VCR.use_cassette("realtime_session_create_with_params") do
          response = realtime.create(parameters: parameters)
          expect(response["model"]).to eq(parameters[:model])
          expect(response["voice"]).to eq(parameters[:voice])
          expect(response["instructions"]).to eq(parameters[:instructions])
        end
      end
    end
  end
end
