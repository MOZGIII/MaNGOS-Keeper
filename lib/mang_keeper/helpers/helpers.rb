def os_windows?
  !!(RUBY_PLATFORM =~ /mswin|mingw/)
end

class String
  def to_i!(*args)
    self.gsub(/[^0-9]/,'').to_i(*args)
  end
end