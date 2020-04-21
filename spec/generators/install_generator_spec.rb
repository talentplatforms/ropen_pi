# require 'generators/ropen_pi/install_generator'

# module RopenPi
#   describe InstallGenerator do
#     include GeneratorSpec::TestCase
#     destination File.expand_path('tmp', __dir__)

#     before(:all) do
#       prepare_destination
#       fixtures_dir = File.expand_path('fixtures', __dir__)
#       FileUtils.cp_r("#{fixtures_dir}/spec", destination_root)

#       run_generator
#     end

#     it 'installs the ropen_pi_helper for rspec' do
#       assert_file('spec/ropen_pi_helper.rb')
#     end
#   end
# end
