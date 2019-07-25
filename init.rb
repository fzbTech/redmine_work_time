require 'redmine'

Redmine::Plugin.register :redmine_work_time do
  name 'Redmine Work Time plugin'
  author 'Tomohisa Kusukawa'
  description 'A plugin to view and update TimeEntry by each user'
  version '0.4.0'
  url 'http://www.redmine.org/plugins/redmine_work_time'
  author_url 'http://about.me/tkusukawa'
  
  project_module :work_time do
    permission :view_work_time_tab, {:work_time =>
            [:show,:member_monthly_data,
             :total,:total_data,:edit_relay,:relay_total,:relay_total_data,
             :total_data_with_act, :relay_total_data_with_act,
             :register_project_settings,
            ]}
    permission :view_work_time_other_member, {:work_time =>
            [:show,:member_monthly_data,
             :total,:total_data,:edit_relay,:relay_total,:relay_total_data,
             :total_data_with_act, :relay_total_data_with_act,
             :register_project_settings,
            ]}
    permission :edit_work_time_total, {}
    permission :edit_work_time_other_member, {}
  end
	#menu :top_menu, :DareAuto_WorkTime_main_menu, { :controller => 'dareauto_wktime_main', :action => 'index' }, :caption => :work_time, :if => Proc.new { Object.new.extend(WktimeHelper).checkViewPermission } 
  #menu :top_menu, :time_tracker_main_menu, {:controller => 'tt_menu_switcher', :action => 'index'}, :caption => :time_tracker_label_main_menu,
  #     # if the user has one or more of the permissions declared within this Plug-In, he should see the "TimeTracker"-Menu
  #     :if => permission_checker([:tt_log_time, :tt_edit_own_time_logs, :tt_edit_time_logs, :tt_view_bookings, :tt_book_time, :tt_edit_own_bookings, :tt_edit_bookings])

  
  menu :account_menu, :work_time,
    {:controller => 'work_time', :action => 'index'},
    :before => :my_account,
    :caption => :work_time,
    :if => Proc.new{User.current.logged? && Setting.plugin_redmine_work_time['show_account_menu']}

  menu :project_menu, :work_time,
    {:controller => 'work_time', :action => 'show'}, :caption => :work_time,
    :after => :gantt

  settings :default => {'account_start_days' => {}, 'show_account_menu' => 'true'},
           :partial => 'settings/work_time_settings'

  Rails.configuration.to_prepare do
    require_dependency 'projects_helper'
    unless ProjectsHelper.included_modules.include? WorkTimeProjectsHelperPatch
      ProjectsHelper.send(:include, WorkTimeProjectsHelperPatch)
    end
  end
end
