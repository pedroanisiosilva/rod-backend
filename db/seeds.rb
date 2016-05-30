# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Run.create(duration:Time.new(01, 05, 06), distance:'10.0', datetime: DateTime.new(2016, 5, 19, 8, 14) )
Run.create(duration:Time.new(01, 05, 06), distance:'5.6', datetime: DateTime.new(2016, 5, 18, 18, 00) )
Run.create(duration:Time.new(01, 05, 06), distance:'25.4', datetime: DateTime.new(2016, 5, 15, 6, 54) )

User.create(name:'Pedro Anisio Silva', email:'pedroanisio@me.com')
User.create(name:'Ana', email:'annetlugard@me.com')