project 'period-flow.xcodeproj'
source 'https://github.com/CocoaPods/Specs.git'
# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'period-flow' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for period-flow
  pod 'RealmSwift'
  pod 'JTAppleCalendar', '~> 6.0'
  pod 'ActionSheetPicker-3.0', '~> 2.1.0'
  pod 'SwiftDate', '~> 4.0'
  pod 'Google/Analytics'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end

