def path_to(page_name)
  case page_name
  
  when /home/i
    root_path
 
  when /"(.*?)" locality/i
    zip_path(:f_address => $1)
  # Add more page name => path mappings here
  
  else
    raise "Can't find mapping from \"#{page_name}\" to a path."
  end
end
