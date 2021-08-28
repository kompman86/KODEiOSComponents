Pod::Spec.new do |s|

	# 1
	s.platform = :ios
	s.ios.deployment_target = '11.0'
	s.name = "KODEiOSComponents"
	s.summary = "A collection of reusable iOS components"
	s.requires_arc = true

	# 2
	s.version = "0.5.0"

	# 3
	s.license = { :type => 'Commercial', :text => <<-LICENSE
	   /* Copyright (C) KODE */
	    LICENSE
	  }

	# 4 
	s.author = { "Artem Makarov" => "artemmakaroff@yahoo.com" }

	# 5
	s.homepage = "https://bitbucket.org/kode-t/kode-ios-components"

	# 6
	s.source = { :git => "git@git.kode-t.ru:base-code/kode-ios-components.git", 
		     	 :branch => "develop", 
	             :tag => s.version.to_s }

	# 7
	s.framework = "UIKit"

	# 8
	s.source_files = '**/Sources/**/*.swift'

	# 10
	s.swift_version = "5.0"

		# Bottom Sheet View Controller
		s.subspec 'KODEBottomSheetViewController' do |sp|
			sp.source_files  = 'BottomSheetViewController/Sources/Extensions/*.swift', 'BottomSheetViewController/Sources/ViewController/*.swift', 'BottomSheetViewController/Sources/Views/*.swift', 'BottomSheetViewController/Sources/Enums/*.swift'
			sp.public_header_files = 'BottomSheetViewController/*.h' 
		end

		# Stories
		s.subspec 'Stories' do |sp|
			sp.source_files  = 'Stories/Sources/Extensions/*.swift', 'Stories/Sources/Default/*.swift', 'Stories/Sources/Utils/*.swift', 'Stories/Sources/Model/*.swift', 'Stories/Sources/StoriesList/*.swift', 'Stories/Sources/StoriesList/Cell/*.swift', 'Stories/Sources/Story/*.swift', 'Stories/Sources/Story/Views/*.swift', 'Stories/Sources/Story/Views/ViewModels/*.swift', 'Stories/Sources/Story/Views/StoryControlView/*.swift', 'Stories/Sources/Story/Views/ProgressBar/*.swift', 'Stories/Sources/Protocols/*.swift'
			sp.public_header_files = 'Stories/*.h' 
			sp.dependency 'SnapKit'
			sp.dependency 'Kingfisher'
		end

end
