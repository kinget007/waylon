require 'sinatra'
require 'date'
require 'jenkins_api_client'
require 'yaml'

class Waylon < Sinatra::Application
  get '/' do
    config = YAML.load(File.open('./waylon_config.yml'))

    # Refresh the page every `refresh_interval` seconds.
    refresh_interval = config['config'][0]['refresh_interval'].to_s

    # For each Jenkins instance in "jobs", connect to the server,
    # and get the status of the jobs specified in the config.
    filter          = []
    errors          = []
    failed_jobs     = []
    building_jobs   = []
    successful_jobs = []

    config['jobs'].each do |hash|
      hash.keys.each do |server|
        filter += hash[server] # job the job filter

        client = JenkinsApi::Client.new(:server_url => server)

        # Attempt to establish a connection to `server`
        begin
          client.get_root
        rescue SocketError
          errors << "Unable to connect to server: #{server}"
          next
        end

        # list_by_status() gets an alphanumeric list of jobs based on the
        # friendly status returned by color_to_status(). We break this up
        # into two arrays: failed and successful. The failed jobs will
        # display above the successful jobs in the dashboard, in
        # alphanumeric order. If you want them to be displayed differently
        # (e.g. last-run at the top), take a look at list_details(job_name).
        # That approach is slightly more complicated though.

        # Get the list of jobs that are building. If the job is in the job
        # filter, append it to the array that we'll display in the dashboard.
        client.job.list_by_status('running').each do |building_job|
          if(filter.include?(building_job)) then
            building_jobs << building_job
          end
        end

        # Get the list of failed jobs. If the job is in the job filter,
        # append it to the array that we'll display in the dashboard.
        client.job.list_by_status('failure').each do |failed_job|
          if(filter.include?(failed_job)) then
             failed_jobs << failed_job
          end
        end

        # Get the list of successful jobs. If the job is in the job filter,
        # append it to the array that we'll display in the dashboard.
        client.job.list_by_status('success').each do |successful_job|
          if(filter.include?(successful_job)) then
             successful_jobs << successful_job
          end
        end
      end
    end

    # If all jobs are green, display the image of the day. These images
    # are located in `public/img/` and follow the convention `imgNN.png`,
    # where NN is the day (number) of the week, starting with 0 (Sunday).
    if(failed_jobs.empty?) then
      nirvana = true
      wday = Time.new.wday
      nirvana_img = "img/img0#{wday}.png"
    end

    erb :index,
      :locals => {
        :refresh_interval => refresh_interval,
        :nirvana          => nirvana,
        :nirvana_img      => nirvana_img,
        :errors           => errors,
        :failed_jobs      => failed_jobs,
        :building_jobs    => building_jobs,
        :successful_jobs  => successful_jobs,
    }
  end
end
