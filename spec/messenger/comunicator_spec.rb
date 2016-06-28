require "rails_helper"

RSpec.feature "Comunicator" do
  @telegram = nil

  context "when comunicate with telegram" do
    before do
      @telegram = Comunicator::Telegram.new
    end

    scenario "create group" do
      rod = @telegram.send :rod_group
      expect(rod.id).to eq(-127271582)
      expect(rod.title).to eq("ROD")
    end

    scenario "create bot" do
      expect { @telegram.send :bot }.not_to raise_error
    end

    scenario "sending a msg" do
      bot = @telegram.send :bot
      allow(bot).to receive(:send_message).and_return(nil)
      @telegram.send_msg "Teste"
      expect(bot).to have_received(:send_message) do |msg|
        expect(msg.chat.title).to eq("ROD")
        expect(msg.text).to eq("Teste")
      end
    end

  end

end
