module ActionView
  module Helpers
    module AssetTagHelper
      def asset_url(entry)
        ActionDispatch::Http::URL.url_for :path => asset_path(entry), :host => Settings.host
      end

      module StylesheetTagHelpers
        def stylesheet_url(entry)
          ActionDispatch::Http::URL.url_for :path => stylesheet_path(entry), :host => Settings.host
        end
      end

      module JavascriptTagHelpers
        def javascript_url(entry)
          ActionDispatch::Http::URL.url_for :path => javascript_path(entry), :host => Settings.host
        end
      end
    end
  end
end
