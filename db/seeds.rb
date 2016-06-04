	# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#User.create(name:'Pedro Anisio Silva', email:'pedroanisio@gmail.com')
# User.create(name:'Ana', email:'annetlugard@me.com')

#// Dump Pedro
a = User.find_by(email:'pedroanisio@gmail.com')

Run.create(user_id:a.id, distance:'27.0',duration_formated:'02:40:41', datetime:DateTime.new(2016, 5, 22).at_midday())
Run.create(user_id:a.id, distance:'25.4',duration_formated:'02:46:12', datetime:DateTime.new(2016, 5, 15).at_midday())
Run.create(user_id:a.id, distance:'25.4',duration_formated:'02:42:16', datetime:DateTime.new(2016, 5, 8).at_midday())
Run.create(user_id:a.id, distance:'25.4',duration_formated:'02:37:15', datetime:DateTime.new(2016, 5, 1).at_midday())
Run.create(user_id:a.id, distance:'15.0',duration_formated:'01:33:01', datetime:DateTime.new(2016, 5, 13).at_midday())
Run.create(user_id:a.id, distance:'14.2',duration_formated:'01:20:56', datetime:DateTime.new(2016, 5, 20).at_midday())
Run.create(user_id:a.id, distance:'13.6',duration_formated:'01:28:06', datetime:DateTime.new(2016, 5, 5).at_midday())
Run.create(user_id:a.id, distance:'10.0',duration_formated:'01:05:06', datetime:DateTime.new(2016, 5, 19).at_midday())
Run.create(user_id:a.id, distance:'10.0',duration_formated:'01:12:40', datetime:DateTime.new(2016, 5, 25).at_midday())
Run.create(user_id:a.id, distance:'9.2',duration_formated:'00:55:59', datetime:DateTime.new(2016, 5, 7).at_midday())
Run.create(user_id:a.id, distance:'9.0',duration_formated:'00:53:05', datetime:DateTime.new(2016, 5, 14).at_midday())
Run.create(user_id:a.id, distance:'8.4',duration_formated:'00:50:20', datetime:DateTime.new(2016, 5, 20).at_midday())
Run.create(user_id:a.id, distance:'8.0',duration_formated:'00:54:46', datetime:DateTime.new(2016, 5, 10).at_midday())
Run.create(user_id:a.id, distance:'7.9',duration_formated:'00:51:46', datetime:DateTime.new(2016, 5, 3).at_midday())
Run.create(user_id:a.id, distance:'7.1',duration_formated:'00:47:30', datetime:DateTime.new(2016, 5, 24).at_midday())
Run.create(user_id:a.id, distance:'5.6',duration_formated:'00:39:14', datetime:DateTime.new(2016, 5, 18).at_midday())

#regex

#^(\d+)-(\w+)\t(\d+\.\d+)\t(.*)$
#Run.create(user_id:a.id, distance:'\3',duration_formated:'\4', datetime:DateTime.new(2016, 5, \1).at_midday())


# a = User.find_by(email:'pedroanisio@gmail.com')
# a.runs.where(:datetime => Time.new(2016, 5)..Time.new(2016, 6)).count
# a.runs.where(:datetime => Time.new(2016, 5)..Time.new(2016, 6)).average(:distance).to_i
# a.runs.where(:datetime => Time.new(2016, 5)..Time.new(2016, 6)).maximum(:distance).to_i
# a.runs.where(:datetime => Time.new(2016, 5)..Time.new(2016, 6)).sum(:distance).to_i
# a.runs.where(:datetime => 1.week.ago.beginning_of_week..1.week.ago.end_of_week).count

