class DataEncryptingKeysController < ApplicationController

  def rotate_key
    if no_job_running? || ENV['CURRENT_JOB_ID'].nil?
      ENV['CURRENT_JOB_ID'] = RotateKey.perform_async
      message = 'Successfully started Rotation Job'
      render json: {message: message}, status: :ok
    else
      message = "Cannot start new job as one job is already #{fetch_status_of_job.to_s.capitalize}"
      render json: {message: message}, status: :forbidden
    end
  end

  def fetch_current_status
    job_status = "Current Job is #{fetch_status_of_job.to_s.capitalize}"
    render json: {message: job_status}, status: :ok
  end

  private

  def fetch_status_of_job
    Sidekiq::Status::status(ENV['CURRENT_JOB_ID'])
  end

  def no_job_running?
    Sidekiq::Status::complete?(ENV['CURRENT_JOB_ID']) || Sidekiq::Status::failed?(ENV['CURRENT_JOB_ID']) || Sidekiq::Status::interrupted?(ENV['CURRENT_JOB_ID'])
  end


end
