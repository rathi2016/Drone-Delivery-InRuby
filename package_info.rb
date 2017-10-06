
class GetPackageInfo

  URL = "https://codetest.kube.getswift.co/packages"

  def get_package_info
    uri = URI.parse(URL)
    response = Net::HTTP.get_response(uri)
    response.body
  end

end

# programs = GetPackageInfo.new.get_package_info
# puts programs
