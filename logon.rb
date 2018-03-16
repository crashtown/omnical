def user_logon
  app = "OmniCal"
  system "clear"
  puts "Welcome to the #{app}!"
  puts "Please choose an option from below."
  login_table_menu = ["Login", "Register"]
  login_table2_menu = [
    ["About" , "Quit"]
  ]
  login_table = Terminal::Table.new headings: login_table_menu, rows: login_table2_menu
  puts login_table
  puts ""
  login_input = gets.chomp.downcase.capitalize
    if login_input == "Register"
      then user_registration_dup_check
      user_registration_password_confirm
    elsif login_input == "Login"
      then auth_logon
    elsif login_input == "About"
      logo = File.read("logo.txt")
      system "clear"
      puts ""
      puts logo
      puts ""
      puts "Developed by Matt Greham & Nic Devlin".center(60)
      puts "v 0.1.10".center(60)
      sleep 5
      system "clear"

  elsif login_input == "Quit"
    system "clear"
    puts "Thanks for using the #{app}!"
    sleep 1
    exit

  else puts "Invalid option, please try again."
      sleep 3
  end
  end

  def auth_logon
      @auth_status = false
    loop do
      system "clear"
      puts "| Logon |"
      puts "Please enter user email."
      puts ""
      @auth_user = gets.chomp
      system "clear"
      puts "| Logon |"
      puts "Please enter user password."
      puts ""
      pass_user = STDIN.noecho(&:gets).chomp
      @user_credentials.each do | user |
        if @auth_user == user[:email_address] && pass_user == user[:password]
          then @auth_status = true
          @first_name = user[:first_name]
          @last_name = user[:last_name]
          else
        end
      end
        if @auth_status == true
          system "clear"
          puts "| Logon |"
          puts "Logon successful, please wait..."
          puts ""
          sleep 2
          system "clear"
          break

        elsif @auth_status == false
           system "clear"
           puts "| Logon |"
           puts "Credentials mismatch, please try again."
           sleep 2
        end
    end
  end
