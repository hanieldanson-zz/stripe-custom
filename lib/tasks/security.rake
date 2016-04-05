task :rails_best_practices do
	path = File.expand_path("../../..", __FILE__)
	sh "rails_best_practices #{path}"	
end

task :brakeman do
	sh "brakeman -q -z"
end
# -q suppress informational; -z treat warnings as errors.

task :check do
	Rake::Task['test'].invoke # this can also be spec if using rspec
	Rake::Task['brakeman'].invoke
	Rake::Task['rails_best_practices'].invoke
end

task :deploy do
	Rake::Task['check'].invoke
	sh "git push origin heroku"
end