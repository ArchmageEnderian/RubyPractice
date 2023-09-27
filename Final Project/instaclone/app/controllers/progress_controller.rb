class ProgressController < ApplicationController
  def show
    @content = File.read(Rails.root.join('OtherThings/TODO.txt'))
  end

end
