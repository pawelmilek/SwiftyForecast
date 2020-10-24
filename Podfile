platform :ios, '12.0'
use_frameworks!

def shared_pods
  pod 'GooglePlaces', '~> 2.7'
  pod 'ReachabilitySwift'
  pod 'RealmSwift'
  pod 'SearchTextField', '1.2.4'
end

# Pods for App
target 'SwiftyForecast' do
  shared_pods
end

# Pods for App's extension
target 'SwiftyForecast Widget' do
  shared_pods
end
