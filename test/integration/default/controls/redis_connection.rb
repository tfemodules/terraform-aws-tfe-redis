control 'redis_connection' do
    title 'Redis connection test.'
    desc 'Confirms connectivity between a test EC2 instance and Redis.'
    
    describe command("redis-cli -a #{input('input_redis_auth_token')} -c PING") do
        its('stdout') { should eq "PONG\n" }
    end

end