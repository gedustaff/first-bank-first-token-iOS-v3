# Podfile
platform :ios, '13.0' # Ensure your minimum deployment target is 13.0 or higher

target 'FirstBankApp' do
  use_frameworks!
  # pod 'SmileID', '~> 11.1'
  # pod 'SmileIDUI', '11.0.2' # <-- Uncomment if you need UI components
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # Enable module stability for SmileID
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    end
  end
end


# If you have other targets (e.g., test targets), you might need to add SmileID there too
# or ensure they link correctly.