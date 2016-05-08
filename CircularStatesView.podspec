Pod::Spec.new do |s|
  s.name              = "CircularStatesView"
  s.version           = "1.0"
  s.summary           = "Custom view to display a vertical connected circular states written in Swift"
  s.description       = <<-DESC
                        A custom view written in Swift that allows you to dispaly a vertical states progress. Real handy when you need to present the user the current state of a progress while showing him the next steps.
                      DESC
  s.homepage          = "https://github.com/orxelm/CircularStatesView"
  s.license           = { :type => "MIT", :file => "LICENSE" }
  s.author            = { "Or Elmaliah" => "orxelm@gmail.com" }
  s.social_media_url  = "https://twitter.com/OrElm"
  s.platform          = :ios, "8.0"
  s.source            = { :git => "https://github.com/orxelm/CircularStatesView.git", :tag => s.version }
  s.source_files      = "CircularStatesView/Sources/*.swift"
  s.requires_arc      = true
  s.framework         = "UIKit"
end