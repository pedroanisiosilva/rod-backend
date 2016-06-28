module Comunicator

  CONFIG = YAML::load_file('config/telegram/telegram.yml').symbolize_keys
  LOGGER = Logger.new(STDOUT, Logger::DEBUG)

  class Telegram

    attr :bot, :rod_group

    def send_msg(txt)
      LOGGER.debug "send msg to ROD"
      bot.send_message new_group_msg(txt)
      LOGGER.debug "end send msg to ROD"
    end

    private
      def new_group_msg(txt)
        TelegramBot::OutMessage.new(chat: rod_group, text: txt)
      end

      def bot
        @bot ||= TelegramBot.new(token: CONFIG[:telegram]["token"], logger: LOGGER)
      end

      def rod_group
        @rod_group ||= TelegramBot::GroupChat.new(id: CONFIG[:telegram]["chat_id"], logger: LOGGER, title: CONFIG[:telegram]["title"])
      end
  end

end
