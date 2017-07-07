Pod::Spec.new do |spec|
    spec.name                  = 'BOOLRefreshController'
    spec.version               = '1.0.2'
    spec.summary               = 'Decoupled solution for DROP DOWN TO REFRESH'

    spec.description           = <<-DESC
                               DROP DOWN TO REFRESH is popular, but this is the best decoupled. 
                               DESC

    spec.homepage              = 'https://github.com/pgbo/BOOLRefreshController.git'
    spec.license               = { :type => 'MIT', :file => 'LICENSE' }
    spec.author                = { 'pgbo' => '460667915@qq.com' }
    spec.platform              = :ios, '7.0'
    spec.source                = { :git => 'https://github.com/pgbo/BOOLRefreshController.git', :tag => spec.version }
    spec.source_files          = 'Classes/*.{h,m}'
    spec.requires_arc          = true
    spec.frameworks            = 'UIKit', 'Foundation'

end