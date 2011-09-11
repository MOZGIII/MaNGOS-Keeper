module MangKeeper
  
  module DBHelpers
  
    def set_default_db database
      @default_db = database
    end
    
    def set_mysql_auth user, pass
      @mysql_user, @mysql_pass = user, pass
    end
  
    def upload_file_to_db filename, database = @default_db, options = {}
      do_log = options[:log].nil? ? true : options[:log]
      full_path_in_log = options[:full_path_in_log].nil? ? true : options[:full_path_in_log]
      read_only_mode = options[:read_only_mode].nil? ? false : options[:read_only_mode]
      
      if do_log
        log_filename = full_path_in_log ? filename : File.basename(filename)
        puts "Uploading file: #{log_filename} to #{database}"
      end
      `mysql -B -u#{@mysql_user} -p#{@mysql_pass} -D#{database} < "#{filename}"` if !read_only_mode && !MangKeeper.application.db_readonly?
      # puts "Done" if do_log
    end
    
    def recreate_db database
      puts "Recreating DB: #{database}"
      return if MangKeeper.application.db_readonly?
      if os_windows?
        `echo DROP DATABASE IF EXISTS #{database}; | mysql -B -u#{@mysql_user} -p#{@mysql_pass}`
        `echo CREATE DATABASE IF NOT EXISTS #{database}; | mysql -B -u#{@mysql_user} -p#{@mysql_pass}`
      else
        `echo "DROP DATABASE IF EXISTS #{database};" | mysql -B -u#{@mysql_user} -p#{@mysql_pass}`
        `echo "CREATE DATABASE IF NOT EXISTS #{database};" | mysql -B -u#{@mysql_user} -p#{@mysql_pass}`  
      end
    end


    def upload_by_glob glob, options = {}
      db = options[:db] || 'mangos'
      exclude = options[:exclude] || []
      filters = options[:filters] || []
      Dir.glob(glob).each do |file|
        next if exclude.member? File.basename(file)
        next if filters.any? { |filter_proc| filter_proc && !filter_proc.call(file) }
        upload_file_to_db file, db, { :read_only_mode => options[:read_only] }
      end
    end

  end

end