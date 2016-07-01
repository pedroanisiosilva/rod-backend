class RunObserver < ActiveRecord::Observer
  attr :comunicator
  def after_create(run)
    comunicator.send_msg("👏👏👏 #{short_name(run.user.name)} correu #{run.distance}Km em #{Time.at(run.duration).utc.strftime("%H:%M:%S")}✔️", run.rod_images.first);
  end

  def comunicator
    @comunicator ||= Comunicator::RodTelegram.new
  end

    def short_name(full_name)
    	%{#{full_name.split(" ")[0]} #{full_name.split(" ")[-1]}}
  	end
end