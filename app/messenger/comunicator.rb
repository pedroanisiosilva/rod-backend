

require 'telegram/bot'

module Comunicator

  CONFIG = YAML::load_file('config/telegram/telegram.yml').symbolize_keys
  LOGGER = Logger.new(STDOUT, Logger::DEBUG)

  class RodTelegram

    attr :bot, :rod_group

    def send_msg(txt, photo = nil)
      raise 'message or photo is required!' if !txt.present? and !photo.present?

      LOGGER.debug "send msg to ROD"

      Telegram::Bot::Client.run(CONFIG[:telegram]["token"]) do |bot|
        if photo.present?
          bot.api.send_photo(new_group_msg(txt,photo))
        else txt.present?
          bot.api.send_message new_group_msg(txt)
        end
      end
      LOGGER.debug "end send msg to ROD"
    end

    private
      def new_group_msg(txt, p = nil)
        attrs = {chat_id: CONFIG[:telegram]["chat_id"], text: txt}
        attrs.merge!({photo: Faraday::UploadIO.new(Paperclip.io_adapters.for(p.image), p.image_content_type), caption: p.caption}) if p.present?
        attrs
      end

  end

end
