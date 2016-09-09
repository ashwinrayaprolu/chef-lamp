# I would suggest naming your function using underscore rather than camelcase
# because of Ruby naming conventions
#
# puts $LOAD_PATH
# ipadd = NetAddr::CIDR.create("192.9.200.0/24")

# Generate IP's in given Range
# IpList = Nodemanager.convert_ip_range('192.168.1.101', '192.168.1.106')



module Nodemanager

  # Generates range of ips from start to end
  def convert_ip_range(start_ip, end_ip)
    start_ip = IPAddr.new(start_ip)
    end_ip   = IPAddr.new(end_ip)
  
    # map to_s if you like, you can also call to_a, 
    # IPAddrs have some neat functions regarding IPs, 
    # be sure to check them out
    #
    (start_ip..end_ip).map(&:to_a) 
  end
  
  def convertIPrange first, last
    first, last = [first, last].map{|s| s.split(".").inject(0){|i, s| i = 256 * i + s.to_i}}
    (first..last).map do |q|
      a = []
      (q, r = q.divmod(256)) && a.unshift(r) until q.zero?
      a.join(".")
    end
  end

end


