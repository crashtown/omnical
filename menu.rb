require 'terminal-table'
require 'icalendar'
require 'gmail_sender'
require 'date'
require 'io/console'
require 'colourize'
#include registration method
require_relative 'register'
require_relative 'logon'
app = "OmniCal"
@user_credentials = [
  {email_address:"bob@tmart.com", first_name:"Bob",last_name:"Jayne",password:"bob123"},
  {email_address:"ernie@tmart.com", first_name:"Ernie",last_name:"Jayne",password:"ernie123"},
  # {email_address:"resurrectiongfx@live.com", first_name:"Matt",last_name:"Greham",password:"123"},
  {email_address:"nic@nicdevlin.com.au", first_name:"Nic",last_name:"Devlin",password:"pass"},
]

#####################
####APP IKIMASU!#####
#####################
###USER SCREEN#######
system "clear"
user_logon
if @auth_status == true
  then
  else user_logon
end
####CHECK VARIABLE FOR LOGGED ON USER HERE#####
loop do
puts "Welcome to #{app}!"
puts "Please choose an option from below."
title1menu = ["Create Event","Show Events"]
title2menu = [
  ["About", "Quit"]
]
table = Terminal::Table.new headings: title1menu, rows: title2menu
puts table
puts ""
menu_input = gets.chomp.downcase.capitalize
##-----About------##
  if menu_input == "About"
    logo = File.read("logo.txt")
    system "clear"
    puts ""
    puts logo.red
    puts ""
    puts "Developed by Matt Greham & Nic Devlin".center(60)
    puts "v 0.1.10".center(60)
    sleep 5
    system "clear"
##-----Quit-------##
  elsif menu_input == "Quit"
  system "clear"
  puts "Thanks for using OmniCal!"
  sleep 1
  exit
##-----Create-----##
  elsif menu_input == "Create event"
    loop do
    system "clear"
      eventdetails=Hash.new()
      system "clear"
      puts "| Create Event - Input Title |"
      puts "Please input a title for your event."
      puts ""
      eventdetails["Event Title"] = gets.chomp
        loop do
          system "clear"
          puts "| Create Event - Date/Time |"
          puts "Please input the date/time of your event - eg. '2018-02-28, 16:00'"
          puts ""
          eventdetails["Time and Date"] = gets.chomp
          if eventdetails["Time and Date"].match ('^\D*(\d\d\d\d)\D+(\d\d)\D+(\d\d).\s(\d\d.\d\d)\D*$')
            system "clear"
            puts "| Create Event - Location |"
            puts "Please input the event location."
            puts ""
            eventdetails["Location"] = gets.chomp
            break
          else
            system "clear"
            puts "| Create Event - Date/Time |"
            puts "Invalid date/time, please re-enter."
            sleep 1
          end
        end
      system "clear"
      puts "| Create Event - Description |"
      puts "Please input a brief description of your event."
      puts ""
      eventdetails["Description"] = gets.chomp
      system "clear"
      puts "| Create Event - Confirm |"
      puts "-------------------------------------"
        eventdetails.each do |key, value|
        puts "#{key}: #{value}"
        end
      puts "-------------------------------------"
      puts ""
      puts "Is this information correct? Type 'Yes' to confirm or 'No' to re-enter details."
      puts ""
      response = gets.chomp.downcase
      if response != "yes"
      else
        system "clear"
        puts "| Create Event - Invite Guests |"
        puts "Please enter your guests email addresses separated by a single space."
        puts "For example trey@southpark.com matt@southpark.com"
        puts ""
        @guests = gets.chomp
        system "clear"
        puts "| Create Event - Creation and Delivery |"
        puts "Please wait while your OmniCal event file is generated..."
 ##-----ics-----##
      dt = DateTime.parse("#{eventdetails["Time and Date"]}").strftime('%Y%m%dT%H%M%S')

      cal = Icalendar::Calendar.new
      cal.event do |e|
        e.dtstart     = Icalendar::Values::Date.new("#{dt}")
        e.summary     = "#{eventdetails["Event Title"]}"
        e.location    = "#{eventdetails["Location"]}"
        e.description = "#{eventdetails["Description"]}"
      end

      cal.publish
      cal_string = cal.to_ical

      File.write("#{eventdetails["Event Title"]}.ics", "#{cal_string}")

      g = GmailSender.new("calendarappca@gmail.com", "Coder2018")
      g.attach("#{eventdetails["Event Title"]}.ics")
      g.send(:to => "#{@auth_user}",
             :subject => "OmniCal Event - #{eventdetails["Event Title"]}",
             :content => "Hello, you're invited to #{eventdetails["Event Title"]}!<br>
                         <br>
                         This is a notication of your event '#{eventdetails["Event Title"]}' on #{eventdetails["Time and Date"]}. <br>
                         Please use the attached file to import this event to your calendar application of choice! <br>
                         <br>
                         Cheers, OmniCal.",
             :content_type => 'text/html')
#######################GUESTS MAILER#####################################
             g = GmailSender.new("calendarappca@gmail.com", "Coder2018")
             g.attach("#{eventdetails["Event Title"]}.ics")
             g.send(:to => "#{@guests}",
                    :subject => "OmniCal Event - #{eventdetails["Event Title"]}",
                    :content => "Hello, you're invited to #{eventdetails["Event Title"]}!<br>
                                <br>
                                This is a notication of your event '#{eventdetails["Event Title"]}' on #{eventdetails["Time and Date"]}. <br>
                                Please use the attached file to import this event to your calendar application of choice! <br>
                                <br>
                                Cheers, OmniCal.",
                    :content_type => 'text/html')
          puts "--------------------"
          puts "Success! Your event has been generated and emailed to all guests."
          puts "Please advise them to open the email to add it to their calendar application of choice!"
          sleep 8
          system "clear"
    break
    end
  end
##-----Show Events-----##
  elsif menu_input == "Show events"
    system "clear"
    puts "----- Current Events -----"
    puts Dir.glob("*.ics")
    puts ""
    puts "Will return to main menu in 10 seconds..."
    sleep 10
    system "clear"
##-----Invalid Input-----##
  else
   puts ""
   puts "---------------------------------"
   puts "Invalid option, please try again."
   puts "---------------------------------"
   sleep 2
   system "clear"
 end
end
