require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

configure do
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Login'
  end
end

before '/secure/*' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = 'Sorry, you need to be logged in to visit ' + request.path
    halt erb(:login_form)
  end
end

get '/' do
  erb 'Can you handle a <a href="/secure/place">secret</a>?'
end

get '/login/form' do
  erb :login_form
end

post '/login/attempt' do
  @username = params[:username]
  @password = params[:password]

  if @username == 'admin' && @password == 'admin'
    session[:identity] = params['username']
  end
  
  where_user_came_from = session[:previous_url] || '/'
  redirect to where_user_came_from
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
end

get '/secure/place' do
  erb 'This is a secret place that only <%=session[:identity]%> has access to!'
end


get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/index' do
	erb :index
end

get '/secure/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end

post '/contacts' do
	erb :contacts

	@email = params[:email]
	@msg = params[:msg]

		@title = 'Thank you!'
		@message = "Your #{@email} and message added."

		f = File.open './public/contacts.txt', 'a'
		f.write "Email: #{@email}, message: #{@msg}\n"
		f.close
		erb :message

end


post '/visit' do
	erb :visit

	@username = params[:username]
	@phone =     params[:phone]
	@date_time = params[:date_time]
	@master = params[:master]

			@title = 'Thank you!'
			@message = "Dear #{@username}, #{@master} be waiting for you at #{@date_time}, this is your phone: #{@phone}"

		
			f = File.open './public/users.txt', 'a'
			f.write "User: #{@username}, Phone: #{@phone}, Date and time: #{@date_time}, master #{@master}\n"
			f.close
			erb :message

end