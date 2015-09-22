require 'sidekiq/web'
require 'rake'
class TwilioController < ApplicationController

  include Sidekiq::Worker

  def send_sms
    current_dreamer.reality_check = true
    current_dreamer.save
    redirect_to profile_path(current_dreamer)
  end

end