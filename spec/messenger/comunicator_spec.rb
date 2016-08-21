require "rails_helper"

RSpec.feature "Comunicator" do
  @telegram = nil

  context "when comunicate with telegram" do
    before do
      @telegram = Comunicator::RodTelegram.new
    end
    scenario "without message and photo" do
      expect { @telegram.send_msg(nil, "",-149144441) }.to raise_error 'message or photo is required!'
    end

    scenario "buildin msg" do
      @image = RodImage.new(:caption => "Teste")
      allow(@image).to receive(:image).and_return("Image")
      allow(Faraday::UploadIO).to receive(:new).and_return(nil)
      allow(Paperclip.io_adapters).to receive(:for).and_return(nil)
      attrs = @telegram.send :new_group_msg, "Teste","-149144441"
      expect(attrs[:chat_id]).to eq("-149144441")
      expect(attrs[:text]).to eq("Teste")

      attrs = @telegram.send :new_group_photo, @image,"-149144441"
      expect(attrs[:caption]).to eq(@image.caption)
      expect(attrs[:photo]).to eq(nil)
    end

  end

end
