module MangKeeper
  
  module DBHelpers
  
    def set_default_db database
      @default_db = database
    end
    
    def set_mysql_auth user, pass
      @mysql_user, @mysql_pass = user, pass
    end
  
    def upload_file_to_db filename, database = @default_db, options = {}
      do_log = options[:log]
      do_log = true if log.nil?
      full_path_in_log = options[:full_path_in_log]
      full_path_in_log = false if full_path_in_log.nil?
      
      if do_log
        log_filename = full_path_in_log ? file : File.basename(file)
        puts "Uploading file: #{log_filename} to #{db}"
      end
      `mysql -B -u#{@mysql_user} -p#{@mysql_pass} -D#{database} < "#{filename}"`
      # puts "Done" if do_log
    end
    
    def recreate_db database
      puts "Recreating DB: #{database}"
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
      Dir.glob(glob).version_sort.each do |file|
        next if exclude.member? File.basename(file)
        next if filters.any? { |filter_proc| filter_proc && !filter_proc.call(file) }
        upload_file_to_db file, db
      end
    end

  end

end