require 'tty-prompt'
require 'net/http'
require 'json'

class GemUp
  GEMFILE_PATH = "Gemfile"

  def initialize
    @prompt = TTY::Prompt.new
  end

  def update_gem(gem_name, version = nil)
    versions = fetch_versions(gem_name)
    return puts "Gem not found: #{gem_name}" if versions.nil? || versions.empty?

    version ||= @prompt.select("Select a version:", versions)
    
    unless versions.include?(version)
      puts "Version #{version} is not available."
      return
    end

    modify_gemfile(gem_name, version)
  end

  private

  def fetch_versions(gem_name)
    url = "https://rubygems.org/api/v1/versions/#{gem_name}.json"
    response = Net::HTTP.get_response(URI(url))

    return nil unless response.is_a?(Net::HTTPSuccess)

    json = JSON.parse(response.body)
    json.map { |v| v["number"] }
  end

  def modify_gemfile(gem_name, version)
    gemfile = File.read(GEMFILE_PATH)
    regex = /^gem ['"]#{gem_name}['"],?\s*['"]?([\d\.]+)?['"]?$/

    if gemfile.match?(regex)
      gemfile.gsub!(regex, "gem '#{gem_name}', '#{version}'")
      puts "Updated #{gem_name} to #{version}"
    else
      gemfile << "\ngem '#{gem_name}', '#{version}'\n"
      puts "Added #{gem_name} #{version}"
    end

    File.write(GEMFILE_PATH, gemfile)
  end
end
