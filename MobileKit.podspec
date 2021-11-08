Pod::Spec.new do |s|

  s.name         = 'MobileKit'
  s.version      = '0.0.1'
  s.summary      = 'Common Components'

  s.description  = <<-DESC
                   This repo contains code shared between iOS mobile applications.
                   DESC

  s.homepage     = 'https://github.com/nickbolton/mobilekit.git'
  s.license      = 'MIT'
  s.authors = { 'Nick Bolton' => 'nick@pixeol.com' }

  s.ios.deployment_target = '13.0'
  s.source = { :git => 'https://github.com/nickbolton/mobilekit.git', :branch => 'master' }

  s.subspec 'Core' do |s|
    s.source_files = 'Source/Core/**/*.{swift,m,h}'
    s.dependency 'SwiftyBeaver', '~> 1.4'
    s.dependency 'ReachabilitySwift', '~> 4.3'
    s.dependency 'FXKeychain', '~> 1.5'
    s.exclude_files = '**/Info*.plist'
  end

  s.subspec 'Animator' do |s|
    s.source_files = 'Source/Animator/**/*.{swift,m,h}'
    s.dependency 'MobileKit/Core'
    s.exclude_files = '**/Info*.plist'
  end

  s.subspec 'Text' do |s|
    s.source_files = 'Source/Text/**/*.{swift,m,h}'
    s.dependency 'MobileKit/Core'
    s.dependency 'Cache', '~> 4.1'
    s.exclude_files = '**/Info*.plist'
  end

  s.subspec 'Redux' do |s|
    s.source_files = 'Source/Redux/**/*.{swift,m,h}'
    s.dependency 'MobileKit/Core'
    s.dependency 'RxSwift', '~> 4.4'
    s.dependency 'ReSwift', '~> 4.0'
    s.exclude_files = '**/Info*.plist'
  end

  s.subspec "iOSApplication" do |s|
    s.dependency "MobileKit/Core"
    s.dependency "MobileKit/Animator"
    s.dependency "MobileKit/Text"
    s.exclude_files = "**/Info*.plist"
  end

end
