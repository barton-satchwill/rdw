root = File.absolute_path(File.dirname(__FILE__))

file_cache_path "/tmp" 
cookbook_path [File.join(root,"site-cookbooks"), root]
json_attribs File.join(root, "backup-solo.json") 

