

require 'telegram/bot'

module Comunicator

  CONFIG = YAML::load_file('config/telegram/telegram.yml').symbolize_keys
  LOGGER = Logger.new(STDOUT, Logger::DEBUG)

  class RodTelegram

    attr :bot, :rod_group

    def send_text_only(txt,chat_id)

      LOGGER.debug "send msg to ROD"

      Logger.info("Telegram not configured for this env") unless CONFIG[:telegram][Rails.env].present?

      Telegram::Bot::Client.run(CONFIG[:telegram][Rails.env]["token"]) do |bot|

        bot.api.send_message new_group_msg(txt,chat_id) if txt.present?

      end if CONFIG[:telegram][Rails.env].present?

      LOGGER.debug "end send msg to ROD"
    end

    def send_image(image,chat_id)

      LOGGER.debug "send image to ROD"

      Logger.info("Telegram not configured for this env") unless CONFIG[:telegram][Rails.env].present?

      Telegram::Bot::Client.run(CONFIG[:telegram][Rails.env]["token"]) do |bot|
        bot.api.send_photo(new_raw_image(image,"",chat_id))


      end if CONFIG[:telegram][Rails.env].present?

      LOGGER.debug "end send image to ROD"
    end
    

    def send_image_with_caption(image,caption,chat_id)
      LOGGER.debug "send image to ROD"

      Logger.info("Telegram not configured for this env") unless CONFIG[:telegram][Rails.env].present?

      Telegram::Bot::Client.run(CONFIG[:telegram][Rails.env]["token"]) do |bot|
        bot.api.send_photo(new_raw_image(image,caption,chat_id))

      end if CONFIG[:telegram][Rails.env].present?

      LOGGER.debug "end send image to ROD"      
    end


    def send_msg(txt, run = nil, chat_id)
      raise 'message or photo is required!' if !txt.present? and !run.present?

      LOGGER.debug "send msg to ROD"

      Logger.info("Telegram not configured for this env") unless CONFIG[:telegram][Rails.env].present?

      Telegram::Bot::Client.run(CONFIG[:telegram][Rails.env]["token"]) do |bot|

        bot.api.send_message new_group_msg(txt,chat_id) if txt.present?

        run.rod_images.each do |image|

          bot.api.send_photo(new_group_photo(image,chat_id)) if image.image_file_size.present? and image.image_file_name.present?

        end if run.rod_images.present?

      end if CONFIG[:telegram][Rails.env].present?

      LOGGER.debug "end send msg to ROD"
    end

    private
      def new_group_msg(txt,chat_id)
        {chat_id: chat_id, text: txt}
      end

      def new_group_photo(photo,chat_id)

        {chat_id: chat_id, photo: Faraday::UploadIO.new(Paperclip.io_adapters.for(photo.image), photo.image_content_type), caption: photo.caption || ""}
      end

      def new_raw_image(image,caption,chat_id)

        {chat_id: chat_id, photo: image, caption: caption}
      end


  end

end
