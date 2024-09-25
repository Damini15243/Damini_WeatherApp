# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Damini_WeatherApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Damini_WeatherApp
  pod 'RealmSwift'
  pod 'SwiftLint'
  pod 'NVActivityIndicatorView', :git => 'https://github.com/ninjaprox/NVActivityIndicatorView.git', :tag => '4.8.0'

  target 'Damini_WeatherAppTests' do
    inherit! :search_paths
    
    # Pods for testing
    pod 'RealmSwift'
    pod 'SwiftLint'
    pod 'NVActivityIndicatorView', :git => 'https://github.com/ninjaprox/NVActivityIndicatorView.git', :tag => '4.8.0'
  end

  target 'Damini_WeatherAppUITests' do
    
    # Pods for testing
    pod 'RealmSwift'
    pod 'SwiftLint'
    pod 'NVActivityIndicatorView', :git => 'https://github.com/ninjaprox/NVActivityIndicatorView.git', :tag => '4.8.0'
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
