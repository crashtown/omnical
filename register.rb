def user_registration_dup_check

  ############################################
  # USER REGISTRATION FUNCTION START
  ############################################
  loop do
    duplicate = nil
    system "clear"
    puts "| Registration - Enter Email Address |"
    puts "What is your email address?"
    #Enter email address
    @email_address = gets.chomp.downcase
    #Iterate through user hashes within array
    @user_credentials.each do | user |
    #If email address within user hash matches entered email address, checks against all hashes
      if @email_address == user[:email_address]
      then duplicate = true
      end
    end
    if duplicate == true
    then puts "A duplicate user already exists, please try again."
    sleep 2
    else break loop if duplicate == nil
    end
  end
end


def user_registration_password_confirm
############################################
# PASSWORD FUNCTION START
############################################
  loop do
    system "clear"
    puts "| Registration - Enter Password |"
    puts "Please enter your password."
    @password = STDIN.noecho(&:gets).chomp
    system "clear"
    puts "| Registration - Re-enter Password |"
    puts "Please re-enter your password."
    @password_confirm = STDIN.noecho(&:gets).chomp
    if @password_confirm == @password
        then
        system "clear"
        puts "| Registration - Enter Name |"
        puts "Please enter your first name."
        @first_name = gets.chomp
        system "clear"
        puts "| Registration - Enter Name |"
        puts "Please enter your last name."
        @last_name = gets.chomp
        system "clear"
        puts "| Registration - Complete |"
        puts "Your account registration has been successful, you may now log on to OmniCal."
        @user_credentials.push(email_address:@email_address, first_name:@first_name, last_name:@last_name, password:@password)
        sleep 3
        break
      else puts "Password's do not match, enter them again."
        sleep 3
    end
  end
end
