class TopLevelDomain < ActiveRecord::Base
  attr_accessible :name
  TLD_DATA_URL = 'http://data.iana.org/TLD/tlds-alpha-by-domain.txt'

  def self.populate_top_level_domains
    response = Typhoeus::Request.get(TLD_DATA_URL)
    if response.code == 200
      body = response.body.split('\n')
      domains = []
      body.each do |row|
        domains << TopLevelDomain.new(:name => row.downcase)
      end
      TopLevelDomain.import domains
    end
  end

  def self.validate_email(email, format, domain)
    result = {
        :email_format => false,
        :email_domain => false
    }

    result[:email_format] = self.validate_email_format(email) if format
    result[:email_domain] = self.validate_email_domain(email) if domain

    return result

  end
  def self.validate_email_domain(email)
    require 'resolv'
    begin
      domain = email.match(/\@(.+)/)[1]
      Resolv::DNS.open do |dns|
        @mx = dns.getresources(domain, Resolv::DNS::Resource::IN::MX) +
                dns.getresources(domain, Resolv::DNS::Resource::IN::A)
      end
      @mx.size > 0 ? true : false
    rescue
      return false
    end
  end

  def self.validate_email_format(email)
    email_pattern = (email =~ /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z0-9\.]*[a-zA-Z]$/)
    email_pattern.nil? ? false : true
  end

end
