# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!

def realm
  pod 'RealmSwift', '~> 0.102'
end
def reactive_cocoa
  pod 'ReactiveCocoa', '~> 4.1.0'
end

target 'reviews' do
  realm
  reactive_cocoa
  pod 'ObjectMapper', '~> 1.0'
  pod 'Alamofire', '~> 3.0'
  pod 'AlamofireObjectMapper', '~> 3.0'
  pod 'SnapKit', '~> 0.21.0'
end

target 'reviewsTests' do

end
