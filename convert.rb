# encoding: utf-8
$:.push(Dir.pwd)

def generate_script(filename)
	output = File.open("src/#{filename}", "w+");
	lines = File.readlines("RGDirectXP/Data/scripts/#{filename}")
	script_paths = []
	lines.each do |line|
		if line =~ /^require \"(.*)\"/
			script_paths.push("RGDirectXP/Data/scripts/#{$1}.rb")
		end
	end
	for i in 0...script_paths.size
		path = script_paths[i]
		output.write File.read(path) << "\n"
		output.write "\n" if i < script_paths.size - 1
	end
	output.close
end

generate_script "compatibility_head.rb"
generate_script "compatibility_tail.rb"