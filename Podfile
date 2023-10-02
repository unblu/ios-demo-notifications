platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!

workspace 'UnbluDemo'

project 'UnbluDemo.xcodeproj'

def firebase_pods
  pod 'Firebase/Core', '~> 7.0'
  pod 'Firebase/Messaging'
end

target 'UnbluDemo' do
  project 'UnbluDemo.xcodeproj'
  firebase_pods
end
