Redmine::Plugin.register :redmine_tclub_support do
  name 'Redmine Tclub Support plugin'
  author 'Bilel-kedidi'
  description 'This is used or client to add new issue '
  version '0.0.1'
  url 'https://github.com/bilel-kedidi/redmine_tclub_support'
  author_url 'https://github.com/bilel-kedidi'

  settings :default => {
      tracker_id: nil,
      status_id: nil
  }, :partial => 'tclub_settings/setting'
end
