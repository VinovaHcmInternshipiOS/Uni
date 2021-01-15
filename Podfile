# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Uni' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'Firebase/Analytics'
  pod 'Firebase/InAppMessaging'
  pod 'IQKeyboardManagerSwift'
  pod 'Firebase/Messaging'
  pod 'Firebase/Auth'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'ShimmerSwift'
  pod 'BarcodeScanner'
  pod 'SkeletonView'
  pod 'Charts'
  pod 'SDWebImage', '~> 5.0'	
  # Pods for Uni
post_install do |installer|
     installer.pods_project.targets.each do |target|
         target.build_configurations.each do |config|
            if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 9.0
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
            end
         end
     end
  end

end
