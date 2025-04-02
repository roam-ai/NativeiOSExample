# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'iOSNativeSelfTracking' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for iOSNativeSelfTracking
  pod 'roam-ios', '0.1.31'
  pod 'roam-ios/RoamBatchConnector', '0.1.31'
  
  
  post_install do |installer|
    bitcode_strip_path = `xcrun --find bitcode_strip`.chomp
    # Ensure bitcode_strip tool is found
    if bitcode_strip_path.empty?
      raise 'bitcode_strip tool not found. Please ensure Xcode Command Line Tools are installed.'
    end
    # Define a method to strip bitcode from framework
    def strip_bitcode_from_framework(bitcode_strip_path, framework_relative_path)
    framework_path = File.join(Dir.pwd, framework_relative_path)
    if File.exist?(framework_path)
      command = "#{bitcode_strip_path} #{framework_path} -r -o #{framework_path}"
      puts "Stripping bitcode from #{framework_relative_path}: #{command}"
      system(command)
    else
      puts "Framework not found: #{framework_relative_path}"
    end
  end
  # Define the paths for AWS frameworks to strip bitcode from
  framework_paths = [
  "Pods/roam-ios/Roam/AWSAuthCore.xcframework/ios-arm64_armv7/AWSAuthCore.framework/AWSAuthCore",
  "Pods/roam-ios/Roam/AWSCognitoIdentityProvider.xcframework/ios-arm64_armv7/AWSCognitoIdentityProvider.framework/AWSCognitoIdentityProvider",
  "Pods/roam-ios/Roam/AWSCognitoIdentityProviderASF.xcframework/ios-arm64_armv7/AWSCognitoIdentityProviderASF.framework/AWSCognitoIdentityProviderASF",
  "Pods/roam-ios/Roam/AWSCore.xcframework/ios-arm64_armv7/AWSCore.framework/AWSCore",
  "Pods/roam-ios/Roam/AWSIoT.xcframework/ios-arm64_armv7/AWSIoT.framework/AWSIoT",
  "Pods/roam-ios/Roam/AWSMobileClientXCF.xcframework/ios-arm64_armv7/AWSMobileClientXCF.framework/AWSMobileClientXCF"
  ]
  # Strip bitcode from each framework in the list
  framework_paths.each do |framework_relative_path|
    strip_bitcode_from_framework(bitcode_strip_path, framework_relative_path)
  end
end

end
