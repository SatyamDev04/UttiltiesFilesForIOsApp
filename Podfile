# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'UttiltiesFilesForIOsApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for UttiltiesFilesForIOsApp
  pod 'IQKeyboardManager'
  pod 'Cosmos'
  pod 'DropDown'
  pod 'FSCalendar'
  pod 'SpreadsheetView'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'NVActivityIndicatorView'
  pod 'MBProgressHUD', '~> 1.1.0'
  pod 'ReachabilitySwift'
  pod 'GoogleMaps', '6.1.1'
  pod 'GooglePlaces'
  pod 'GooglePlacesSearchController'
  pod 'Google-Maps-iOS-Utils'
  pod 'Alamofire'
  pod 'GoogleSignIn'
  pod 'SDWebImage'
  pod 'SwiftGifOrigin', '~> 1.7.0'
  pod 'OpalImagePicker'
  pod 'FirebaseMessaging'
  pod 'FirebaseAnalytics'
  pod 'Firebase/Crashlytics'
  pod 'DateScrollPicker'
  pod 'QCropper'
  pod 'SnackBar.swift'
  pod 'AssetsPickerViewController', '~> 2.0'
  pod 'CalendarKit'
  pod 'ISEmojiView'
  pod 'TwilioConversationsClient', '~> 3.1'
  pod 'AdvancedPageControl'
  target 'UttiltiesFilesForIOsAppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'UttiltiesFilesForIOsAppUITests' do
    # Pods for testing
  end

end
post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end

