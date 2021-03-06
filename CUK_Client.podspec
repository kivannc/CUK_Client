Pod::Spec.new do |s|
  s.name             = "CUK_Client"
  s.version          = "0.1.13"
  s.summary          = "CUK_Client is HTTPClient that modified  for our needs."
  s.description      = "A base httpclient. Get it to your project than categorize it use to  according to your rest api."
  s.homepage         = "https://github.com/kivannc/CUK_Client"
  s.license          = 'MIT'
  s.author           = { "Kivanc ERTURK" => "kivanc@kns.com.tr" }
  s.source           = { :git => "https://github.com/kivannc/CUK_Client.git", :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'CUK_Client' => ['Pod/Assets/*.png']
  }
  s.public_header_files = 'Pod/Classes/**/*.h'
  s.dependency 'AFNetworking', '~> 2.3'
end
