# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.new({username:"shawn",email:"shawn@draftin.co",verified:true,admin:true,password:"neverforget"}).save
User.new({username:"admin",email:"admin@draftin.co",verified:true,admin:true,password:"neverforget"}).save
ChatRoom.new({title:"Draftin' Global Chat"}).save