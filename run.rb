load File.join(File.dirname(__FILE__), "application.rb")

application = Application.new

trap('TERM') { application.shutdown }
trap('INT') { application.shutdown }

application.run
