#!/Users/djt469/.rvm/rubies/ruby-2.1.1/bin/ruby

# Ruby Bits

print "\nHello everybody! "
print "Welcome to RUBY\n"
print "------------------------------------\n";


=begin

Basic Methods

    to_s converts things to strings.
    to_i converts things to integers (numbers.)
    to_a converts things to arrays.

Files
print File.read("/Home/comics.txt")

# Creating functions:
def load_­comics(pat­h)
	comics= {}
	File.forea­ch(path)do­|line|
		name, url = line.­split(': ')
		comics[nam­e] = url.s­trip
	end
   	comics
end

comics = load_comics('/comics.txt')

=end

b = { 	id: 3,
		status: "I just ate some delicious brain",
		zombie: "Jim"
	}

# puts t[:status] == puts t.status

# CRUD
# Create
t = TableName.new
t.key = value
t.save

Zombie.create

# REad
Tweet.find(2)
Tweet.find(3,4,5)
Tweet.first
Tweet.last
Tweet.all
Tweet.count
Tweet.order(:zombie)
Tweet.limit(10)
Tweet.where(zombie: "ash")

# combining:
Tweet.where(zombie: "ash").order(:status).limit(10)

#UPDATE
t = TableName.find(id)
t.key = value
t.save
#which is the same us
t = Tweet.find(2)
t.message = "whatever"
t.save
#i.e. for several of them
t = Tweet.find(2)
t.attributes = {
	status: "Can I munch your eyeballs?",
	zombie: "EyeballChomper"
}
t.save

# DELETE
t = Tweet.find(2)
t.destroy

Tweet.find(2).destroy
Tweet.destroy.all






