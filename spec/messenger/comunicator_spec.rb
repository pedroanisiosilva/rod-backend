require "rails_helper"

RSpec.feature "Comunicator" do
  @telegram = nil

  context "when comunicate with telegram" do
    before do
      @telegram = Comunicator::RodTelegram.new
    end
    scenario "without message and photo" do
      expect { @telegram.send_msg(nil) }.to raise_error 'message or photo is required!'
      expect { @telegram.send_msg(nil, "") }.to raise_error 'message or photo is required!'
    end
    scenario "buildin msg" do
      allow(Faraday::UploadIO).to receive(:new).and_return("teste")
      attrs = @telegram.send :new_group_msg, "Teste", "teste"
      expect(attrs[:chat_id]).to eq(-127271582)
      expect(attrs[:text]).to eq("Teste")
      expect(attrs[:caption]).to eq("Teste")
      expect(attrs[:photo]).to eq("teste")

      # allow(bot).to receive(:send_message).and_return(nil)
      # @telegram.send_msg "Teste"
      # expect(bot).to have_received(:send_message) do |msg|
      #   expect(msg.chat.title).to eq("ROD")
      #   expect(msg.text).to eq("Teste")
      # end
    end

  end

end
