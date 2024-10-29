require 'csv'
require 'google/apis/civicinfo_v2'
require 'time'
# require 'erb'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def clean_homephone(homephone)
  number = homephone.to_s.gsub(/[^0-9]/, '')
  length = number.length

  unless length == 10 || length == 11 && number.start_with?("1") == true
    number = "invalid number"
  end
  if length == 11 && number.start_with?("1") == true
    number = number[1..10]
  end

  number
end

def get_reghour(regdate)
  Time.strptime(regdate, "%D %R").strftime("%k hours")
end

def get_regday(regdate)
  day_number = Date.strptime(regdate, "%D").wday
  day_number = Date::DAYNAMES[day_number]
end

# def legislators_by_zipcode(zip)
#   civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
#   civic_info.key = File.read('secret.key.txt').strip

#   begin
#     civic_info.representative_info_by_address(
#       address: zip,
#       levels: 'country',
#       roles: ['legislatorUpperBody', 'legislatorLowerBody']
#     ).officials
#   rescue
#     'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
#   end
# end

# def save_thank_you_letter(id,form_letter)
#   Dir.mkdir('output') unless Dir.exist?('output')

#   filename = "output/thanks_#{id}.html"

#   File.open(filename, 'w') do |file|
#     file.puts form_letter
#   end
# end

puts 'EventManager initialized!'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
  )

# template_letter = File.read('form_letter.html')
# erb_template = ERB.new template_letter

contents.each do |row|
  # id = row[0]

  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  homephone = clean_homephone(row[:homephone])

  reghour = get_reghour(row[:regdate])

  regday = get_regday(row[:regdate])

  # legislators = legislators_by_zipcode(zipcode)

  puts "#{name}, #{zipcode}, #{homephone}, #{reghour}, #{regday}"

  # form_letter = erb_template.result(binding)
  
  # save_thank_you_letter(id,form_letter)
end