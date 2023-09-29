class ProgressController < ApplicationController
  def show
    file_path = Rails.root.join('OtherThings/TODO.txt')
    if File.exist?(file_path)
      @content = File.read(file_path)
    else
      @content = "File not found"
    end
  end

end
