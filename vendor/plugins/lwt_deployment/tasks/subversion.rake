namespace :svn do
  desc "Display svn messages. (date=today user=username)"
  task :messages => :environment do
    date = ENV['date'] ? Chronic.parse(ENV['date']).to_date : Date.today
      
    messages = svn_messages_since(date, ENV['user'])
    
    if messages.empty?
      puts "No changes since #{date}..."
    else
      puts messages.map { |m| "* #{m}\n" }
    end
  end
end

def svn_messages_since(start_date, user = nil)
  require 'rexml/document'
  require 'chronic'

  puts "Retrieving svn messages since #{start_date}..."
  doc = REXML::Document.new(`svn log --xml #{RAILS_ROOT} -r {#{start_date}}:HEAD`)

  messages = []
  doc.elements.each('log/logentry') do |logentry|
    # Stip blank messages
    message = logentry.elements['msg'].text.to_s.strip
    next if message.blank?

    # Skip messages from other users if a specific user is given
    author = logentry.elements['author'].text
    next if user and author != user
    
    # Skip messages before the start date
    date = Chronic.parse(logentry.elements['date'].text[0,10]).to_date
    next if date < start_date

    messages << "#{date}: #{message} (#{author})"
  end    
  messages.uniq
end