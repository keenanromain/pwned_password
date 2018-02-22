require 'digest'
require 'io/console'
require 'net/http'
require 'uri'

print "Enter password to be searched in the PwnedPasswords.com database: "
password = STDIN.noecho(&:gets).chomp
hashedpw = (Digest::SHA1.hexdigest password).upcase

uri = URI.parse('https://api.pwnedpasswords.com/range/'+hashedpw[0...5])
response = Net::HTTP.get_response(uri)

pwned = false
if response.kind_of? Net::HTTPSuccess
    response.body.split("\n").each do |item|
        if item.include? hashedpw[5..-1]
            pwned = true
            puts "\nYour password is not secure! Occurences found: "+item.split(":")[1]
            break
        end
    end
    puts "\nYour password has not been found in the PwnedPasswords.com database" if not pwned
else
    puts "\nOops! Error querying API."
end

