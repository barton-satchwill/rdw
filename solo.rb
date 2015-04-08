root = File.absolute_path(File.dirname(__FILE__))

file_cache_path "/var/chef-solo" #root
cookbook_path File.expand_path("..", root)
json_attribs File.join(root, "solo.json") 
