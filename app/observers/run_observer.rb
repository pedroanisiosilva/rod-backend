class RunObserver < ActiveRecord::Observer
  attr :comunicator
  def after_create(run)
    comunicator.send_msg("WoWWWWW!!! #{run.user.name.upcase} RANNNNNN #{run.distance} in #{Time.at(run.duration).utc.strftime("%H:%M:%S")} ", run.rod_images.first);
  end

  def comunicator
    @comunicator ||= Comunicator::RodTelegram.new
  end
end
