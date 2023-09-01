# Use the specified Ruby version as the base image
FROM ruby:3.2.2

# Install essential Linux packages
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs postgresql-client

# Create a directory for the application and use it as the working directory
RUN mkdir /app
WORKDIR /app

# Add Gemfile and install gems
ADD Gemfile* /app/
RUN bundle install

# Add the application code to the image
ADD . /app

# Expose port 3000
EXPOSE 3000

RUN rm -f /app/tmp/pids/server.pid

# Default command to run the server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
