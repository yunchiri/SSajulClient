source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '2.3'
    end
  end
end

target "Ssajul" do

    pod 'Alamofire', '~> 3.0'
    pod 'Kanna', '~> 1.0.0'
    pod 'KMPlaceholderTextView', '~> 1.2.0' 

    pod 'Google-Mobile-Ads-SDK', '~> 7.0'
    pod 'ActiveLabel'
    
    pod 'Colours/Swift'

    pod 'RealmSwift'
    pod 'PagingMenuController' ,'~> 0.10.2'

    pod 'ChameleonFramework/Swift'
    pod 'CocoaLumberjack/Swift'    

    pod 'Fabric'
    pod 'Crashlytics'

	pod 'SVProgressHUD'

end


